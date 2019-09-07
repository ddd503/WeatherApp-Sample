//
//  APIClientTest.swift
//  WeatherApp-SampleTests
//
//  Created by kawaharadai on 2019/09/07.
//  Copyright © 2019 kawaharadai. All rights reserved.
//

import XCTest
@testable import WeatherApp_Sample

class APIClientTest: XCTestCase {
    func test_request_通信テスト() {
        let expectation = self.expectation(description: "通信テスト")
        let session = URLSession(configuration: .default)
        guard let url = URL(string: "http://weather.livedoor.com/forecast/webservice/json/v1?city=130010") else {
            XCTFail("URLが不正")
            return
        }
        let urlRequest = URLRequest(url: url)
        APIClient().request(session: session, urlRequest: urlRequest) { (result) in
            switch result {
            case .success(let data):
                expectation.fulfill()
                XCTAssertNotNil(data)
            default: XCTFail("get error response")
            }
        }
        wait(for: [expectation], timeout: 3.0)
    }
}
