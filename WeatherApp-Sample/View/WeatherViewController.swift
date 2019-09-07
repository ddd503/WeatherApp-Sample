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
    @IBOutlet private weak var weatherImageView: UIImageView!
    @IBOutlet private weak var weatherTitleLabel: UILabel!
    @IBOutlet private weak var minTemperatureLabel: UILabel!
    @IBOutlet private weak var maxTemperatureLabel: UILabel!
    @IBOutlet private weak var summaryLabel: UILabel!
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
            self?.afterDaysForecastsView.reloadData()
        }
    }

    func notFoundTodayWeatherInfo() {

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
