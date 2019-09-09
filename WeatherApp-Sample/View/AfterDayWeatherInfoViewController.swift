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
    @IBOutlet private weak var copylightTitleLabel: UILabel!
    @IBOutlet private weak var copylightLinkLabel: UILabel!

    private let weatherInfo: Forecast

    init(weatherInfo: Forecast) {
        self.weatherInfo = weatherInfo
        super.init(nibName: String(describing: AfterDayWeatherInfoViewController.self), bundle: .main)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()


    }

}
