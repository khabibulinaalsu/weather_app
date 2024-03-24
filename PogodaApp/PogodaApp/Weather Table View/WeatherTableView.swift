import UIKit


final class WeatherTableView: UIView {
		
		private enum Constants {
				static let todayHeight: CGFloat = 504
				static let dailyHeight: CGFloat = 150
		}
		
		private let tableView: UITableView = UITableView(frame: .zero)
		private let model: WeatherGetModel
		
		init(frame: CGRect, model: WeatherGetModel) {
				self.model = model
				super.init(frame: frame)
				configureTable()
		}
		
		required init?(coder: NSCoder) {
				fatalError("init(coder:) has not been implemented")
		}
		
		private func configureTable() {
				tableView.dataSource = self
				tableView.delegate = self
				tableView.register(TodayCard.self, forCellReuseIdentifier: TodayCard.reuseID)
				tableView.register(DailyCard.self, forCellReuseIdentifier: DailyCard.reuseID)
				
				addSubview(tableView)
				tableView.frame = bounds
		}
}

extension WeatherTableView: UITableViewDelegate {
		func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
				if indexPath.row == 0 {
						return Constants.todayHeight
				}
				return Constants.dailyHeight
		}
}

extension WeatherTableView: UITableViewDataSource {
		func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
				return model.daily.count
		}
		
		func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
				switch indexPath.row {
						case 0:
								if let cell = tableView.dequeueReusableCell(withIdentifier: TodayCard.reuseID,
																														for: indexPath) as? TodayCard {
										cell.applyData(model)
										return cell
								}
						case 1:
								if let cell = tableView.dequeueReusableCell(withIdentifier: DailyCard.reuseID,
																														for: indexPath) as? DailyCard {
										cell.applyData(model.daily[indexPath.row])
										cell.applyDay("Завтра")
										return cell
								}
						default:
								if let cell = tableView.dequeueReusableCell(withIdentifier: DailyCard.reuseID,
																														for: indexPath) as? DailyCard {
										cell.applyData(model.daily[indexPath.row])
										cell.applyDay(
												Date(timeIntervalSince1970:
																TimeInterval(model.daily[indexPath.row].dt))
												.formatted(
														Date.FormatStyle()
																.month(.abbreviated)
																.day(.twoDigits)
																.weekday(.abbreviated)))

										return cell
								}
				}
				return UITableViewCell()
		}
}
