//
//  WeatherInfo.swift
//  WeatherApp-Sample
//
//  Created by kawaharadai on 2019/09/07.
//  Copyright © 2019 kawaharadai. All rights reserved.
//

import Foundation

struct WeatherInfo: Codable {
    let location: Location
    let title: String
    let publicTime: String
    let description: Description
    let forecasts: [Forecast]
    let copyright: Copyright
}

struct Location: Codable {
    let area: String
    let prefecture: String
    let city: String
}

struct Description: Codable {
    let text: String
    let publicTime: String
}

struct Forecast: Codable {
    let date: String
    let dateLabel: String
    let telop: String
    let image: Image
    let temperature: Temperature
}

struct Image: Codable {
    let title: String
    let url: String
}

struct Temperature: Codable {
    let max: Max?
    let min: Min?
}

struct Max: Codable {
    let celsius: String
    let fahrenheit: String
}

struct Min: Codable {
    let celsius: String
    let fahrenheit: String
}

struct Copyright: Codable {
    let title: String
    let link: String
}
