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
								case .error(_):
										presentedView = ErrorView(frame: view.frame) { [weak self] in
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
				locationManager.startUpdatingLocation()
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
								if let error {
										self?.state = .error(error)
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
				locationManager.stopUpdatingLocation()
				
		}
		
		func locationManager(_ manager: CLLocationManager, didFailWithError error: Swift.Error) {
				state = .error(error)
		}
}
