//
//  NotFoundWeatherInfoView.swift
//  WeatherApp-Sample
//
//  Created by kawaharadai on 2019/09/09.
//  Copyright © 2019 kawaharadai. All rights reserved.
//

import UIKit

final class NotFoundWeatherInfoView: UIView {
    
    private var task: (() -> ())?

    static func make(frame: CGRect, task: @escaping () -> ()) -> NotFoundWeatherInfoView {
        let view = UINib(nibName: "NotFoundWeatherInfoView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! NotFoundWeatherInfoView
        view.frame = frame
        view.task = task
        return view
    }

    @IBAction func didTapRequest(_ sender: UIButton) {
        task?()
    }
}
