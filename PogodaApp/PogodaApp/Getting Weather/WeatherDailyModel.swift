import Foundation
import UIKit


public enum State {
		case success(WeatherGetModel)
		case loading
		case error(Error)
}


public protocol WeatherDailyModelProtocol {
		func tryGetWeather()
}


public protocol Statable {
		var state: State? { get set }
}
public typealias StatableViewController = Statable & UIViewController


final class WeatherDailyModel: WeatherDailyModelProtocol {
		
		weak private var controller: StatableViewController?
		private let client: WeatherProvider = WeatherAPIClient()
		private let latitude: Double
		private let longitude: Double
		
		public init(for controller: StatableViewController, latitude: Double, longitude: Double) {
				self.latitude = latitude
				self.longitude = longitude
				self.controller = controller
				self.tryGetWeather()
		}
		
		public func tryGetWeather() {
				controller?.state = .loading
			
				self.client.weatherDailyList(lat: latitude, lon: longitude) { [weak self] res in
						switch res {
								case Result.success(let model):
										self?.controller?.state = .success(model)
								case Result.failure(let error):
										self?.controller?.state = .error(error)
						}
				}
		}
		
		
}
