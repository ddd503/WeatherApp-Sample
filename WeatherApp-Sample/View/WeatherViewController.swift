//
//  WeatherViewController.swift
//  WeatherApp-Sample
//
//  Created by kawaharadai on 2019/09/06.
//  Copyright © 2019 kawaharadai. All rights reserved.
//

import UIKit

final class WeatherViewController: UIViewController {

    @IBOutlet private weak var forecastView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var weatherImageView: UIImageView!
    @IBOutlet private weak var weatherTitleLabel: UILabel!
    @IBOutlet private weak var minTemperatureLabel: UILabel!
    @IBOutlet private weak var maxTemperatureLabel: UILabel!
    @IBOutlet private weak var summaryLabel: UILabel!
    @IBOutlet private weak var copylightTitleLabel: UILabel!
    @IBOutlet private weak var copylightLinkLabel: UILabel!
    @IBOutlet private weak var afterDaysForecastsView: UITableView! {
        didSet {
            afterDaysForecastsView.dataSource = self
            afterDaysForecastsView.delegate = self
            afterDaysForecastsView.register(AfterDateInfoCell.nib(),
                                            forCellReuseIdentifier: AfterDateInfoCell.identifier)
        }
    }

    let presenter: WeatherViewPresenterInputs!

    init(presenter: WeatherViewPresenterInputs) {
        self.presenter = presenter
        super.init(nibName: String(describing: WeatherViewController.self), bundle: .main)
        self.presenter.bind(view: self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }

}

extension WeatherViewController: WeatherViewPresenterOutputs {
    func receivedWeatherInfo(_ info: WeatherInfo) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.view.subviews.forEach {
                if $0 is NotFoundWeatherInfoView {
                    $0.removeFromSuperview()
                }
            }
            if let todayWeatherInfo = info.forecasts.first,
                todayWeatherInfo.dateLabel == "今日" {
                self.titleLabel.text = "\(todayWeatherInfo.dateLabel)の天気"
                self.dateLabel.text = todayWeatherInfo.date
                self.weatherTitleLabel.text = todayWeatherInfo.telop
                if let min = todayWeatherInfo.temperature.min {
                    self.minTemperatureLabel.text = "最低気温: \(min.celsius)℃"
                } else {
                    self.minTemperatureLabel.text = "不明"
                }
                if let max = todayWeatherInfo.temperature.max {
                    self.maxTemperatureLabel.text = "最高気温: \(max.celsius)℃"
                } else {
                    self.maxTemperatureLabel.text = "不明"
                }
                self.summaryLabel.text = info.description.text
                if let url = URL(string: todayWeatherInfo.image.url),
                    let imageData = try? Data(contentsOf: url),
                    let image = UIImage(data: imageData) {
                    self.weatherImageView.image = image
                } else {
                    self.weatherImageView.image = UIImage(named: "no_image")!
                }
                self.copylightTitleLabel.text = info.copyright.title
                self.copylightLinkLabel.text = info.copyright.link
            }
            self.afterDaysForecastsView.reloadData()
            self.forecastView.isHidden = false
            self.afterDaysForecastsView.isHidden = false
        }
    }

    func notFoundTodayWeatherInfo() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let notFoundWeatherInfoView = NotFoundWeatherInfoView(frame: self.view.frame) {
                self.presenter.reload()
            }
            self.view.insertSubview(notFoundWeatherInfoView, aboveSubview: self.forecastView)
            self.forecastView.isHidden = true
            self.afterDaysForecastsView.isHidden = true
        }
    }
}

extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let info = presenter.info, !info.forecasts.isEmpty else { return 0 }
        return info.forecasts.count - 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AfterDateInfoCell.identifier, for: indexPath) as? AfterDateInfoCell,
            let info = presenter.info else {
            fatalError("can not create cell")
        }
        cell.setInfo(info: info.forecasts[indexPath.row + 1])
        return cell
    }
}

extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.size.height / 2
    }
}
