//
//  WeatherViewController.swift
//  WeatherApp-Sample
//
//  Created by kawaharadai on 2019/09/06.
//  Copyright © 2019 kawaharadai. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    let presenter: WeatherViewPresenterInputs!

    init(presenter: WeatherViewPresenterInputs) {
        self.presenter = presenter
        super.init(nibName: String(describing: WeatherViewController.self), bundle: .main)
        self.presenter.bind(view: self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension WeatherViewController: WeatherViewPresenterOutputs {}
