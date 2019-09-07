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
    @IBOutlet private weak var otherDaysForecastsView: UITableView! {
        didSet {
            otherDaysForecastsView.dataSource = self
            otherDaysForecastsView.delegate = self
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

}

extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension WeatherViewController: UITableViewDelegate {}
