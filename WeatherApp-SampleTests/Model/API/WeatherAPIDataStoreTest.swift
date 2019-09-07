//
//  WeatherAPIDataStoreTest.swift
//  WeatherApp-SampleTests
//
//  Created by kawaharadai on 2019/09/07.
//  Copyright © 2019 kawaharadai. All rights reserved.
//

import XCTest
@testable import WeatherApp_Sample

class WeatherAPIDataStoreTest: XCTestCase {
    func test_createRequest_リクエストの生成テスト() {
        let dataStore: WeatherAPIDataStore = WeatherAPIDataStoreImpl()
        let baseUrlString = "http://weather.livedoor.com/forecast/webservice/json/v1"
        let method = "GET"
        let parameters = ["city": "130010"]
        let request = dataStore.createRequest(baseUrlString: baseUrlString, method: method, parameters: parameters)
        XCTAssertEqual(request.url!.absoluteString, "http://weather.livedoor.com/forecast/webservice/json/v1?city=130010")
        XCTAssertEqual(request.httpMethod!, "GET")
        XCTAssertEqual(request.url!.query!, "city=130010")
    }

    func test_requestApi_お天気APIから指定した地域の天気情報を正しくパースして受け取るテスト() {
        let expectation = self.expectation(description: "お天気APIから指定した地域の天気情報を正しくパースして受け取るテスト")
        let dataStore: WeatherAPIDataStore = WeatherAPIDataStoreImpl()
        let baseUrlString = "http://weather.livedoor.com/forecast/webservice/json/v1"
        let method = "GET"
        let parameters = ["city": "400040"] // 久留米のエリアコード
        let urlRequest = dataStore.createRequest(baseUrlString: baseUrlString, method: method, parameters: parameters)
        dataStore.requestApi(urlRequest: urlRequest) { (result) in
            switch result {
            case .success(let info):
                expectation.fulfill()
                XCTAssertEqual(info.location.prefecture, "福岡県")
                XCTAssertEqual(info.location.area, "九州")
                XCTAssertEqual(info.location.city, "久留米")
            default: XCTFail("get error response")
            }
        }
        wait(for: [expectation], timeout: 3.0)
    }
}
