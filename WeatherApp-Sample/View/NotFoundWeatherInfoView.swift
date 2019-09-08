//
//  NotFoundWeatherInfoView.swift
//  WeatherApp-Sample
//
//  Created by kawaharadai on 2019/09/09.
//  Copyright © 2019 kawaharadai. All rights reserved.
//

import UIKit

class NotFoundWeatherInfoView: UIView {
    
    let task: (() -> ())

    init(frame: CGRect, task: @escaping () -> ()) {
        self.task = task
        super.init(frame: frame)
        let customView = Bundle.main.loadNibNamed("NotFoundWeatherInfoView", owner: self, options: nil)!.first! as! UIView
        addSubview(customView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func didTapRequest(_ sender: UIButton) {
        task()
    }
}
