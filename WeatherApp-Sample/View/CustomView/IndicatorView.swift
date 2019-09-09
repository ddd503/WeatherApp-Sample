//
//  IndicatorView.swift
//  WeatherApp-Sample
//
//  Created by kawaharadai on 2019/09/09.
//  Copyright © 2019 kawaharadai. All rights reserved.
//

import UIKit

class IndicatorView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        if let customView = Bundle.main.loadNibNamed("IndicatorView", owner: self, options: nil)?.first as? UIView {
            addSubview(customView)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
