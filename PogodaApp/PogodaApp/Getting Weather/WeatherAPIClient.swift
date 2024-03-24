import Foundation


public enum ClientError: Error {
		case urlError
		case getRequestError
		case decodeJsonError
}


public protocol WeatherProvider {
		func weatherDailyList(
				lat: Double,
				lon: Double,
				completion: @escaping (Result<WeatherGetModel, Error>) -> Void
		)
}


final class WeatherAPIClient: WeatherProvider {
		
		private enum Constants {
				static let UrlDefault: String = "https://api.openweathermap.org/data/3.0/onecall?"
				static let APIkey: String = "6de60ac3ec29bd28cb977bcd4f51a3d8"
		}
		
		private let session = URLSession(configuration: URLSessionConfiguration.default)
		private let decoder = JSONDecoder()
		var units: String = "metric"
		
		func weatherDailyList(
				lat: Double,
				lon: Double,
				completion: @escaping (Result<WeatherGetModel, Error>) -> Void) {
						let url = URL(string: Constants.UrlDefault + "lat=\(lat)&lon=\(lon)&exclude=minutely,hourly,alerts&appid=\(Constants.APIkey)&units=\(units)&lang=ru")
						guard let url else {
								DispatchQueue.main.async {
										completion(.failure(ClientError.urlError))
								}
								return
						}
						
						var request = URLRequest(url: url)
						request.httpMethod = "GET"
						let task = session.dataTask(with: request) { data, _, _ in
								guard let data else {
										DispatchQueue.main.async {
												completion(.failure(ClientError.getRequestError))
										}
										return
								}
								do {
										let res = try self.decoder.decode(WeatherGetModel.self, from: data)
										DispatchQueue.main.async {
												completion(.success(res))
										}
								} catch {
										DispatchQueue.main.async {
												completion(.failure(ClientError.decodeJsonError))
										}
										return
								}
						}
						task.resume()
		}
		
}
