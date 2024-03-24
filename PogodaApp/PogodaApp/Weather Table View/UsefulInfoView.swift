import UIKit


enum InfoType: String, CaseIterable {
		case humidity = "Влажность"
		case wind = "Ветер"
		case feelslike = "Ощущение"
		case uvindex = "Индекс УФ"
		case clouds = "Облачность"
		
		var image: UIImage? {
				switch self {
						case .humidity:
								return UIImage(systemName: "humidity")
						case .wind:
								return UIImage(systemName: "wind")
						case .feelslike:
								return UIImage(systemName: "thermometer")
						case .uvindex:
								return UIImage(systemName: "rays")
						case .clouds:
								return UIImage(systemName: "cloud")
				}
		}
}


final class UsefulInfoView: UIView {
		private let type: InfoType
		private let symbol: UIImageView = UIImageView(image: UIImage())
		private let name: UILabel = UILabel()
		private let value: UILabel = UILabel()
		
		init(type: InfoType) {
				self.type = type
				super.init(frame: .zero)
				configureUI()
		}
		
		required init?(coder: NSCoder) {
				fatalError("init(coder:) has not been implemented")
		}
		
		public func applyValue(_ value: String) {
				self.value.text = value
		}
		
		private func configureUI() {
				symbol.image = type.image
				name.text = type.rawValue
				name.font = .systemFont(ofSize: 12, weight: .light)
				value.font = .systemFont(ofSize: 16)
				
				let stack = UIStackView(arrangedSubviews: [
						symbol, name, value
				])
				stack.alignment = .center
				stack.axis = .vertical
				stack.spacing = 4
				stack.distribution = .fillProportionally
				addSubview(stack)
				stack.translatesAutoresizingMaskIntoConstraints = false
				NSLayoutConstraint.activate([
						stack.topAnchor.constraint(equalTo: topAnchor),
						stack.leadingAnchor.constraint(equalTo: leadingAnchor),
						stack.bottomAnchor.constraint(equalTo: bottomAnchor),
						stack.trailingAnchor.constraint(equalTo: trailingAnchor)
				])
		}
}
