import Foundation


public struct WeatherGetModel: Decodable {
		let lat: Double
		let lon: Double
		let timezone: String
		let timezone_offset: Int
		let current: Current
		let daily: [Daily]
}


struct Weather: Decodable {
		let id: Int
		let main: String
		let description: String
		let icon: String
}


struct Temp: Decodable {
		let day: Double
		let min: Double
		let max: Double
		let night: Double
		let eve: Double
		let morn: Double
}


struct FeelsLike: Decodable {
		let day: Double
		let night: Double
		let eve: Double
		let morn: Double
}


struct Current: Decodable {
		let dt: Int
		let sunrise: Int?
		let sunset: Int?
		let temp: Double
		let feels_like: Double
		let pressure: Int
		let humidity: Int
		let dew_point: Double
		let uvi: Double
		let clouds: Int
		let visibility: Int
		let wind_speed: Double
		let wind_deg: Int
		let wind_gust: Double?
		let rain: AnyDecodable?
		let snow: AnyDecodable?
		let weather: [Weather]
}


struct Daily: Decodable {
		let dt: Int
		let sunrise: Int?
		let sunset: Int?
		let moonrise: Int
		let moonset: Int
		let moon_phase: Double
		let summary: String
		let temp: Temp
		let feels_like: FeelsLike
		let pressure: Int
		let humidity: Int
		let dew_point: Double
		let wind_speed: Double
		let wind_deg: Int
		let wind_gust: Double?
		let weather: [Weather]
		let clouds: Int
		let pop: Double
		let rain: Double?
		let snow: Double?
		let uvi: Double
}
