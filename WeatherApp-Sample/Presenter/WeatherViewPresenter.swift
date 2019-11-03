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
    func didSelectTableViewRow(indexPath: IndexPath)
    func callApi(request: URLRequest)
}

protocol WeatherViewPresenterOutputs: class {
    func receivedWeatherInfo(_ info: WeatherInfo)
    func notFoundTodayWeatherInfo()
    func startIndicator()
    func stopIndicator()
    func transitionAfterDayWeatherInfoVC(weatherInfo: Forecast)
    func notFoundAfterDayWeatherInfo()
}

final class WeatherViewPresenter: WeatherViewPresenterInputs {

    weak var view: WeatherViewPresenterOutputs?
    private let weatherAPIDataStore: WeatherAPIDataStore
    private var createRequest: URLRequest {
        return weatherAPIDataStore.createRequest(baseUrlString: "http://weather.livedoor.com/forecast/webservice/json/v1",
                                                 method: "GET",
                                                 parameters: ["city": "130010"])
    }
    var info: WeatherInfo?

    init(weatherAPIDataStore: WeatherAPIDataStore) {
        self.weatherAPIDataStore = weatherAPIDataStore
    }

    func bind(view: WeatherViewPresenterOutputs) {
        self.view = view
    }

    func viewDidLoad() {
        view?.startIndicator()
        callApi(request: createRequest)
    }

    func reload() {
        view?.startIndicator()
        callApi(request: createRequest)
    }

    func didSelectTableViewRow(indexPath: IndexPath) {
        guard let info = info, info.forecasts.count > indexPath.row + 1 else {
            view?.notFoundAfterDayWeatherInfo()
            return
        }
        view?.transitionAfterDayWeatherInfoVC(weatherInfo: info.forecasts[indexPath.row + 1])
    }

    func callApi(request: URLRequest) {
        weatherAPIDataStore.requestApi(urlRequest: request) { [weak self] (result) in
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
