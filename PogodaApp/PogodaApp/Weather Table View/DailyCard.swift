import UIKit


final class DailyCard: UITableViewCell {
		static let reuseID: String = "DailyCard"
		
		private let dayLabel: UILabel = UILabel()
		private let minMaxTempLabel: UILabel = UILabel()
		private let descriptionLabel: UILabel = UILabel()
		private let icon: UIImageView = UIImageView()
		private let session = URLSession(configuration: URLSessionConfiguration.default)
		
		override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
				super.init(style: style, reuseIdentifier: reuseIdentifier)
				configureUI()
		}
		
		required init?(coder: NSCoder) {
				fatalError("init(coder:) has not been implemented")
		}
		
		public func applyData(_ data: Daily) {
				minMaxTempLabel.text = "\(Int(data.temp.max))º / \(Int(data.temp.min))º"
				descriptionLabel.text = data.weather[0].description
				
				let url = URL(string: "https://openweathermap.org/img/wn/\(data.weather[0].icon)@4x.png")
				guard let url else { return }
				
				var request = URLRequest(url: url)
				request.httpMethod = "GET"
				let task = session.dataTask(with: request) { data, _, _ in
						guard let data else { return }
						let res = UIImage(data: data)
						DispatchQueue.main.async { [weak self] in
								self?.icon.image = res
						}
				}
				task.resume()
		}
		
		public func applyDay(_ day: String) {
				dayLabel.text = day
		}
		
		private func configureUI() {
				dayLabel.font = .systemFont(ofSize: 24, weight: .semibold)
				minMaxTempLabel.font = .systemFont(ofSize: 40, weight: .bold)
				descriptionLabel.font = .systemFont(ofSize: 16)

				
				let stack = UIStackView(arrangedSubviews: [
						dayLabel, minMaxTempLabel, descriptionLabel
				])
				stack.axis = .vertical
				stack.distribution = .fillProportionally
				
				let cardStack = UIStackView(arrangedSubviews: [
						 stack, icon
				])
				cardStack.axis = .horizontal
				cardStack.distribution = .fillProportionally
				
				addSubview(cardStack)
				cardStack.translatesAutoresizingMaskIntoConstraints = false
				NSLayoutConstraint.activate([
						cardStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
						cardStack.centerYAnchor.constraint(equalTo: centerYAnchor),
						cardStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
						icon.heightAnchor.constraint(equalToConstant: 120),
						icon.widthAnchor.constraint(equalToConstant: 120)
				])
		}
}
