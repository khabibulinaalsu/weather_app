import UIKit


final class TodayCard: UITableViewCell {
		static let reuseID: String = "TodayCard"
		
		private let dayLabel: UILabel = UILabel()
		private let tempLabel: UILabel = UILabel()
		private let minMaxTempLabel: UILabel = UILabel()
		private let descriptionLabel: UILabel = UILabel()
		private let infoHumidity: UsefulInfoView = UsefulInfoView(type: .humidity)
		private let infoUVIndex: UsefulInfoView = UsefulInfoView(type: .uvindex)
		private let infoWind: UsefulInfoView = UsefulInfoView(type: .wind)
		private let infoFeelsLike: UsefulInfoView = UsefulInfoView(type: .feelslike)
		private let infoClouds: UsefulInfoView = UsefulInfoView(type: .clouds)
		
		override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
				super.init(style: style, reuseIdentifier: reuseIdentifier)
				configureUI()
		}
		
		required init?(coder: NSCoder) {
				fatalError("init(coder:) has not been implemented")
		}
		
		public func applyData(_ data: WeatherGetModel) {
				tempLabel.text = "\(Int(data.current.temp))º"
				minMaxTempLabel.text = "\(Int(data.daily[0].temp.max))º / \(Int(data.daily[0].temp.min))º"
				descriptionLabel.text = data.current.weather[0].description
				infoHumidity.applyValue("\(data.current.humidity) %")
				infoUVIndex.applyValue("\(data.current.uvi)")
				infoWind.applyValue("\(data.current.wind_speed) м/с")
				infoFeelsLike.applyValue("\(Int(data.current.feels_like))º")
				infoClouds.applyValue("\(data.current.clouds) %")
		}
		
		private func configureUI() {
				dayLabel.text = "Сегодня"
				dayLabel.font = .systemFont(ofSize: 24, weight: .semibold)
				tempLabel.font = .systemFont(ofSize: 96, weight: .medium)
				minMaxTempLabel.font = .systemFont(ofSize: 20)
				descriptionLabel.font = .systemFont(ofSize: 20)
				
				let stacks: [UIStackView] = [
						UIStackView(arrangedSubviews: [infoHumidity, infoUVIndex, infoWind]),
						UIStackView(arrangedSubviews: [infoFeelsLike, infoClouds, UIView()])
				]
				stacks.forEach {
						$0.axis = .vertical
						$0.spacing = 24
				}
				
				let infoBar = UIStackView(arrangedSubviews: stacks)
				infoBar.axis = .horizontal
				infoBar.spacing = 72
				
				let cardStack = UIStackView(arrangedSubviews: [
						dayLabel, tempLabel, minMaxTempLabel, descriptionLabel, infoBar
				])
				cardStack.distribution = .fillProportionally
				cardStack.alignment = .center
				cardStack.axis = .vertical
				cardStack.spacing = 12
				
				addSubview(cardStack)
				cardStack.translatesAutoresizingMaskIntoConstraints = false
				NSLayoutConstraint.activate([
						cardStack.topAnchor.constraint(equalTo: topAnchor),
						cardStack.leadingAnchor.constraint(equalTo: leadingAnchor),
						cardStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
						cardStack.trailingAnchor.constraint(equalTo: trailingAnchor)
				])
		}
}
