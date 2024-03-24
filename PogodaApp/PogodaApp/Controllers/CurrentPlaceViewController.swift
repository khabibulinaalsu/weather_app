import UIKit
import CoreLocation


final class CurrentPlaceViewController: StatableViewController {

		public var state: State? {
				didSet {
						stateDidChange()
				}
		}
		
		private var presentedView: UIView = UIView()
		private var weatherDailyModel: WeatherDailyModelProtocol?
		
		private let locationManager: CLLocationManager = {
				let manager = CLLocationManager()
				return manager
		}()
		
		override func viewWillAppear(_ animated: Bool) {
				start()
		}
		
		override func viewDidLoad() {
				super.viewDidLoad()
				view.backgroundColor = .systemBackground
				state = .loading
				getLocation()
		}
		
		private func stateDidChange() {
				presentedView.removeFromSuperview()
				if let state = state {
						switch state {
								case .success(let model):
										presentedView = WeatherTableView(frame: view.frame, model: model)
								case .loading:
										presentedView = LoadingView(frame: view.frame)
								case .error(let error):
										presentedView = ErrorView(frame: view.frame, error: error) { [weak self] in
												self?.reloadData()
										}
						}
				}
				view.addSubview(presentedView)
		}
		
		private func reloadData() {
				weatherDailyModel?.tryGetWeather()
				getLocation()
		}
		
		private func getLocation() {
				locationManager.delegate = self
				locationManager.requestLocation()
		}
		
		private func setLocation(_ location: CLLocation) {
				weatherDailyModel = WeatherDailyModel(
						for: self,
						latitude: location.coordinate.latitude,
						longitude: location.coordinate.longitude
				)
				
				let geocoder = CLGeocoder()
				geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
						if let placemark = placemarks?.first {
								self?.title = placemark.locality ?? placemark.subLocality ?? placemark.administrativeArea ?? placemark.subAdministrativeArea ?? "Unknown place"
						} else {
								if error != nil {
										self?.state = .error(.geocoderError)
								}
						}
				}
		}
		
		private func start() {
				self.locationManager.requestWhenInUseAuthorization()
				
				DispatchQueue.global().async { [weak self] in
						if CLLocationManager.locationServicesEnabled() {
								self?.locationManager.desiredAccuracy = kCLLocationAccuracyBest
						}
				}
		}
}

extension CurrentPlaceViewController: CLLocationManagerDelegate {
		func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
				
				let userlocation = locations[0] as CLLocation
				setLocation(locationManager.location ?? userlocation)
				
		}
		
		func locationManager(_ manager: CLLocationManager, didFailWithError error: Swift.Error) {
				switch manager.authorizationStatus {
						case .authorizedAlways, .authorizedWhenInUse:
								state = .error(.locationError)
						case .denied, .restricted:
								state = .error(.locationDenied)
						case .notDetermined:
								reloadData()
						@unknown default:
								state = .error(.unknownError)
				}
		}
}
