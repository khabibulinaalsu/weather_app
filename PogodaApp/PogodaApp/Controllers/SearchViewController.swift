import UIKit
import CoreLocation


final class SearchViewController: StatableViewController {
		public var state: State? {
				didSet {
						stateDidChange()
				}
		}
		
		private var presentedView: UIView = UIView()
		private var weatherDailyModel: WeatherDailyModelProtocol?
		private let searchField: UISearchTextField = UISearchTextField()
		private let searchButton: UIButton = {
				let button = UIButton(type: .system)
				button.setTitle("Поиск", for: .normal)
				return button
		}()
		private let cancelButton: UIButton = {
				let button = UIButton(type: .system)
				button.setTitle("Отмена", for: .normal)
				return button
		}()
		private let stack: UIStackView = UIStackView(arrangedSubviews: [])
		
		override func viewDidLoad() {
				super.viewDidLoad()
				view.backgroundColor = .systemBackground
				state = nil
				configureTextField()
		}
		
		private func stateDidChange() {
				presentedView.removeFromSuperview()
				if let state = state {
						let newFrame = view.safeAreaLayoutGuide.layoutFrame
								.inset(by: UIEdgeInsets(top: searchField.intrinsicContentSize.height + 20.0, left: 0, bottom: 0, right: 0))
						switch state {
								case .success(let model):
										presentedView = WeatherTableView(frame: newFrame, model: model)
								case .loading:
										presentedView = LoadingView(frame: newFrame)
								case .error(let error):
										print("\(error)")
										presentedView = ErrorView(frame: newFrame, error: error) { [weak self] in
												self?.reloadData()
										}
						}
				} else {
						presentedView = UIView()
				}
				view.addSubview(presentedView)
		}
		
		private func reloadData() {
				weatherDailyModel?.tryGetWeather()
		}
		
		private func findPlace(_ name: String) {
				state = .loading
				let geocoder = CLGeocoder()
				var location = CLLocation()
				geocoder.geocodeAddressString(name) { [weak self] (placemarks, error) in
						if let placemark = placemarks?.first {
								location = placemark.location ?? CLLocation()
								self?.setLocation(location)
						} else {
								if error != nil {
										self?.state = .error(.geocoderError)
								}
						}
				}
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
		
		private func configureTextField() {
				searchField.placeholder = "Введите название города"
				searchButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
				cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
				
				stack.spacing = 4
				stack.addArrangedSubview(searchField)
				stack.addArrangedSubview(searchButton)
				view.addSubview(stack)
				stack.translatesAutoresizingMaskIntoConstraints = false
				NSLayoutConstraint.activate([
						stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
						stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
						stack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
				])
		}
		
		private func addCancelButton() {
				stack.addArrangedSubview(cancelButton)
		}
		
		@objc
		private func buttonTapped(_ sender: UIButton) {
				if let search = searchField.text {
						if search.count > 0 {
								findPlace(search)
								addCancelButton()
						}
				}
		}
		
		@objc
		private func cancelButtonTapped(_ sender: UIButton) {
				state = nil
				searchField.text = nil
				stack.removeArrangedSubview(cancelButton)
				cancelButton.removeFromSuperview()
				title = "В другом городе"
		}
}
