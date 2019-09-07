//
//  WeatherAPIDataStore.swift
//  WeatherApp-Sample
//
//  Created by kawaharadai on 2019/09/07.
//  Copyright © 2019 kawaharadai. All rights reserved.
//

import Foundation

protocol WeatherAPIDataStore {
    func requestApi(urlRequest: URLRequest, completion: @escaping (Result<WeatherInfo, Error>) -> ())
    func createRequest(baseUrlString: String, method: String, parameters: [String: String]) -> URLRequest
}

struct WeatherAPIDataStoreImpl: WeatherAPIDataStore {
    func requestApi(urlRequest: URLRequest, completion: @escaping (Result<WeatherInfo, Error>) -> ()) {
        let session = URLSession(configuration: .default)
        let urlRequest = urlRequest
        APIClient().request(session: session, urlRequest: urlRequest, completion: { (result) in
            switch result {
            case .success(let data):
                do {
                    let info = try JSONDecoder().decode(WeatherInfo.self, from: data)
                    completion(.success(info))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }

    func createRequest(baseUrlString: String, method: String, parameters: [String: String]) -> URLRequest {
        var urlComponents = URLComponents(url: URL(string: baseUrlString)!, resolvingAgainstBaseURL: true)!
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
