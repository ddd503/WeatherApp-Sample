//
//  WeatherViewPresenter.swift
//  WeatherApp-Sample
//
//  Created by kawaharadai on 2019/09/06.
//  Copyright © 2019 kawaharadai. All rights reserved.
//

import Foundation

protocol WeatherViewPresenterInputs {
    var view: WeatherViewPresenterOutputs? { get set }
    func bind(view: WeatherViewPresenterOutputs)
}

protocol WeatherViewPresenterOutputs: class {
}

final class WeatherViewPresenter: WeatherViewPresenterInputs {

    weak var view: WeatherViewPresenterOutputs?

    func bind(view: WeatherViewPresenterOutputs) {
        self.view = view
    }

}
