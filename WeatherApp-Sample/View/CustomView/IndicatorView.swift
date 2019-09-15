//
//  IndicatorView.swift
//  WeatherApp-Sample
//
//  Created by kawaharadai on 2019/09/09.
//  Copyright © 2019 kawaharadai. All rights reserved.
//

import UIKit

final class IndicatorView: UIView {

    static func make(frame: CGRect) -> IndicatorView {
        let view = UINib(nibName: "IndicatorView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! IndicatorView
        view.frame = frame
        return view
    }

}
