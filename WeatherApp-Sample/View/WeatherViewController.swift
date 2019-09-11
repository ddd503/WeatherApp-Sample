//
//  WeatherViewController.swift
//  WeatherApp-Sample
//
//  Created by kawaharadai on 2019/09/06.
//  Copyright © 2019 kawaharadai. All rights reserved.
//

import UIKit

final class WeatherViewController: UIViewController {

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
    private lazy var indicatorView = IndicatorView(frame: view.bounds)
    private lazy var notFoundWeatherInfoView = NotFoundWeatherInfoView(frame: self.view.frame) { [weak self] in
        self?.presenter.reload()
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
            self.view.subviews.filter { $0 is NotFoundWeatherInfoView }.forEach { $0.removeFromSuperview() }
            if let todayWeatherInfo = info.forecasts.first, todayWeatherInfo.dateLabel == "今日" {
                self.titleLabel.text = "\(info.location.prefecture)の天気"
                self.dateLabel.text = todayWeatherInfo.date
                self.weatherTitleLabel.text = todayWeatherInfo.telop
                if let min = todayWeatherInfo.temperature.min {
                    self.minTemperatureLabel.text = "最低気温\n\(min.celsius)℃"
                } else {
                    self.minTemperatureLabel.text = "最低気温\n不明"
                }
                if let max = todayWeatherInfo.temperature.max {
                    self.maxTemperatureLabel.text = "最高気温\n\(max.celsius)℃"
                } else {
                    self.maxTemperatureLabel.text = "最高気温\n不明"
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
        }
    }

    func notFoundTodayWeatherInfo() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self,
                !self.view.subviews.contains(where: { $0 is NotFoundWeatherInfoView }) else { return }
            self.view.addSubview(self.notFoundWeatherInfoView)
            self.view.bringSubviewToFront(self.notFoundWeatherInfoView)
        }
    }

    func startIndicator() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self,
                !self.view.subviews.contains(where: { $0 is IndicatorView }) else { return }
            self.view.addSubview(self.indicatorView)
            self.view.bringSubviewToFront(self.indicatorView)
        }
    }

    func stopIndicator() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.view.subviews.filter { $0 is IndicatorView }.forEach { $0.removeFromSuperview() }
        }
    }

    func transitionAfterDayWeatherInfoVC(weatherInfo: Forecast) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let afterDayWeatherInfoVC = AfterDayWeatherInfoViewController(presenter: AfterDayWeatherInfoViewPresenter(),
                                                                          weatherInfo: weatherInfo)
            afterDayWeatherInfoVC.modalPresentationStyle = .custom
            afterDayWeatherInfoVC.transitioningDelegate = self
            self.present(afterDayWeatherInfoVC, animated: true)
            if let indexPathForSelectedRow = self.afterDaysForecastsView.indexPathForSelectedRow {
                self.afterDaysForecastsView.deselectRow(at: indexPathForSelectedRow, animated: true)
            }
        }
    }

    func notFoundAfterDayWeatherInfo() {
        DispatchQueue.main.async { [weak self] in
            if let indexPathForSelectedRow = self?.afterDaysForecastsView.indexPathForSelectedRow {
                self?.afterDaysForecastsView.deselectRow(at: indexPathForSelectedRow, animated: true)
            }
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectTableViewRow(indexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let info = presenter.info else { return 0 }
        return tableView.bounds.size.height / CGFloat(info.forecasts.count - 1)
    }
}

extension WeatherViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return WeatherViewPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
