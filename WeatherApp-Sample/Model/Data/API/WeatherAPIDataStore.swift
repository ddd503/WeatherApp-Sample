//
//  WeatherAPIDataStore.swift
//  WeatherApp-Sample
//
//  Created by kawaharadai on 2019/09/07.
//  Copyright © 2019 kawaharadai. All rights reserved.
//

import Foundation

struct WeatherAPIDataStore {
    let baseURLString = "http://weather.livedoor.com/forecast/webservice/json/v1"

    func requestApi(method: String = "GET", parameters: [String: String] = [:], completion: @escaping (Result<Data, Error>) -> ()) {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let urlRequest = createRequest(method: method, parameters: parameters)
        APIClient().request(session: session, urlRequest: urlRequest, completion: completion)
    }

    func createRequest(method: String, parameters: [String: String]) -> URLRequest {
        var urlComponents = URLComponents(url: URL(string: baseURLString)!, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = []
        parameters.forEach { (key, value) in
            let query = URLQueryItem(name: key, value: value)
            urlComponents.queryItems?.append(query)
        }
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.httpMethod = method
        return urlRequest
    }
}
