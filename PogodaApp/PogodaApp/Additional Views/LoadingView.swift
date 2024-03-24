import UIKit


final class LoadingView: UIView {
		private var loadingIndicator: UIActivityIndicatorView = {
				let indicator = UIActivityIndicatorView(style: .large)
				indicator.color = .black
				indicator.startAnimating()
				indicator.translatesAutoresizingMaskIntoConstraints = false
				return indicator
		}()
		
		override init(frame: CGRect) {
				super.init(frame: frame)
				addSubview(loadingIndicator)
				NSLayoutConstraint.activate([
						loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
						loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
				])
		}
		
		required init?(coder: NSCoder) {
				fatalError("init(coder:) has not been implemented")
		}
		
}
