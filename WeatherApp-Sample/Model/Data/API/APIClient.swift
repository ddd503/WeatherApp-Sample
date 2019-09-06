//
//  APIClient.swift
//  WeatherApp-Sample
//
//  Created by kawaharadai on 2019/09/07.
//  Copyright © 2019 kawaharadai. All rights reserved.
//

import Foundation

private enum ApiStatusCode: Int {
    case success = 200
}

enum APIError: Error {
    case notFoundURLResponse
    case notFoundResponseData
    case requestFailure
}

struct APIClient {
    func request(session: URLSession, urlRequest: URLRequest, completion: @escaping (Result<Data, Error>) -> ()) {
        let task = session.dataTask(with: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            guard let response = response as? HTTPURLResponse else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(APIError.notFoundURLResponse))
                }
                return
            }

            switch response.statusCode {
            case ApiStatusCode.success.rawValue:
                guard let data = data else {
                    completion(.failure(APIError.notFoundResponseData))
                    return
                }
                completion(.success(data))
            default:
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(APIError.requestFailure))
                }
            }

            session.finishTasksAndInvalidate()
        }
        task.resume()
    }
}
