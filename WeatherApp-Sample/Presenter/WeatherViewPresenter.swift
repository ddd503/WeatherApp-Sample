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
    var info: WeatherInfo? { get }
    func bind(view: WeatherViewPresenterOutputs)
    func viewDidLoad()
    func reload()
}

protocol WeatherViewPresenterOutputs: class {
    func receivedWeatherInfo(_ info: WeatherInfo)
    func notFoundTodayWeatherInfo()
    func startIndicator()
    func stopIndicator()
}

final class WeatherViewPresenter: WeatherViewPresenterInputs {

    weak var view: WeatherViewPresenterOutputs?
    private let weatherAPIDataStore: WeatherAPIDataStore
    var info: WeatherInfo?

    init(weatherAPIDataStore: WeatherAPIDataStore) {
        self.weatherAPIDataStore = weatherAPIDataStore
    }

    func bind(view: WeatherViewPresenterOutputs) {
        self.view = view
    }

    func viewDidLoad() {
        view?.startIndicator()
        callApi()
    }

    func reload() {
        view?.startIndicator()
        callApi()
    }

    private func callApi() {
        let urlRequest = weatherAPIDataStore.createRequest(baseUrlString: "http://weather.livedoor.com/forecast/webservice/json/v1",
                                                           method: "GET",
                                                           parameters: ["city": "130010"])
        weatherAPIDataStore.requestApi(urlRequest: urlRequest) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let info):
                guard let todayWeatherInfo = info.forecasts.first, todayWeatherInfo.date == Date().dateString else {
                    self.view?.notFoundTodayWeatherInfo()
                    break
                }
                self.info = info
                self.view?.receivedWeatherInfo(info)
            case .failure(let error):
                self.view?.notFoundTodayWeatherInfo()
                print(error.localizedDescription)
            }
            self.view?.stopIndicator()
        }
    }
}

private extension Date {
    var dateString: String {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd" // 2019-09-07みたいな
        return format.string(from: self)
    }
}
