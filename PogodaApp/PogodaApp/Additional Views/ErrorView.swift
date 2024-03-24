import UIKit


final class ErrorView: UIView {

		private let label: UILabel = {
				let label: UILabel = UILabel()
				label.text = "Error occurred\nPlease, try again"
				return label
		}()
		private let button: UIButton = {
				let button: UIButton = UIButton(type: .system)
				button.setTitle("Try again", for: .normal)
				button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
				return button
		}()
		private let tryAgain: () -> Void
		
		init(frame: CGRect, tryAgain: @escaping () -> Void) {
				self.tryAgain = tryAgain
				super.init(frame: frame)
				configureUI()
		}
		
		required init?(coder: NSCoder) {
				fatalError("init(coder:) has not been implemented")
		}
		
		private func configureUI() {
				button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
				let stack = UIStackView(arrangedSubviews: [label, button])
				stack.axis = .vertical
				stack.spacing = 16
				addSubview(stack)
				stack.translatesAutoresizingMaskIntoConstraints = false
				NSLayoutConstraint.activate([
						stack.centerXAnchor.constraint(equalTo: centerXAnchor),
						stack.centerYAnchor.constraint(equalTo: centerYAnchor)
				])
		}
		
		@objc
		private func buttonTapped(_ sender: UIButton) {
				tryAgain()
		}
}
