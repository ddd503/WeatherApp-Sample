//
//  AfterDayWeatherInfoViewPresenter.swift
//  WeatherApp-Sample
//
//  Created by kawaharadai on 2019/09/10.
//  Copyright © 2019 kawaharadai. All rights reserved.
//

import Foundation

protocol AfterDayWeatherInfoViewPresenterInputs {
    var view: AfterDayWeatherInfoViewPresenterOutputs? { get set }
    func bind(view: AfterDayWeatherInfoViewPresenterOutputs)
    func viewDidLoad()
}

protocol AfterDayWeatherInfoViewPresenterOutputs: class {
    func setupLayout()
}

final class AfterDayWeatherInfoViewPresenter: AfterDayWeatherInfoViewPresenterInputs {

    weak var view: AfterDayWeatherInfoViewPresenterOutputs?

    func bind(view: AfterDayWeatherInfoViewPresenterOutputs) {
        self.view = view
    }

    func viewDidLoad() {
       view?.setupLayout()
    }
}
