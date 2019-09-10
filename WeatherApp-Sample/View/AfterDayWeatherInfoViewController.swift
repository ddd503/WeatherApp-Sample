//
//  AfterDayWeatherInfoViewController.swift
//  WeatherApp-Sample
//
//  Created by kawaharadai on 2019/09/10.
//  Copyright © 2019 kawaharadai. All rights reserved.
//

import UIKit

final class AfterDayWeatherInfoViewController: UIViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var weatherImageView: UIImageView!
    @IBOutlet private weak var weatherTitleLabel: UILabel!
    @IBOutlet private weak var minTemperatureLabel: UILabel!
    @IBOutlet private weak var maxTemperatureLabel: UILabel!

    let presenter: AfterDayWeatherInfoViewPresenterInputs!
    private let weatherInfo: Forecast

    init(presenter: AfterDayWeatherInfoViewPresenterInputs, weatherInfo: Forecast) {
        self.presenter = presenter
        self.weatherInfo = weatherInfo
        super.init(nibName: String(describing: AfterDayWeatherInfoViewController.self), bundle: .main)
        self.presenter.bind(view: self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }

    @IBAction func didTapBackgruond(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }

}

extension AfterDayWeatherInfoViewController: AfterDayWeatherInfoViewPresenterOutputs {
    func setupLayout() {
        titleLabel.text = "\(weatherInfo.dateLabel)の天気"
        dateLabel.text = weatherInfo.date
        weatherTitleLabel.text = weatherInfo.telop
        if let min = weatherInfo.temperature.min {
            minTemperatureLabel.text = "最低気温\n\(min.celsius)℃"
        } else {
            minTemperatureLabel.text = "最低気温\n不明"
        }
        if let max = weatherInfo.temperature.max {
            maxTemperatureLabel.text = "最高気温\n\(max.celsius)℃"
        } else {
            maxTemperatureLabel.text = "最高気温\n不明"
        }
        if let url = URL(string: weatherInfo.image.url),
            let imageData = try? Data(contentsOf: url),
            let image = UIImage(data: imageData) {
            weatherImageView.image = image
        } else {
            weatherImageView.image = UIImage(named: "no_image")!
        }
    }
}
