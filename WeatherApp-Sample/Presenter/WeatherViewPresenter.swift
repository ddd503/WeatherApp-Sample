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
    func viewDidLoad()
}

protocol WeatherViewPresenterOutputs: class {

}

final class WeatherViewPresenter: WeatherViewPresenterInputs {

    weak var view: WeatherViewPresenterOutputs?
    private let weatherAPIDataStore: WeatherAPIDataStore

    init(weatherAPIDataStore: WeatherAPIDataStore) {
        self.weatherAPIDataStore = weatherAPIDataStore
    }

    func bind(view: WeatherViewPresenterOutputs) {
        self.view = view
    }

    func viewDidLoad() {
        let urlRequest = weatherAPIDataStore.createRequest(baseUrlString: "http://weather.livedoor.com/forecast/webservice/json/v1",
                                                           method: "GET",
                                                           parameters: ["city": "130010"])
        weatherAPIDataStore.requestApi(urlRequest: urlRequest) { (result) in
            switch result {
            case .success(let info):
                print(info)
//                print(String(data: data, encoding: .utf8)!)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
