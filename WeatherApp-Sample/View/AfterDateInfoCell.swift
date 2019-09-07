//
//  AfterDateInfoCell.swift
//  WeatherApp-Sample
//
//  Created by kawaharadai on 2019/09/07.
//  Copyright © 2019 kawaharadai. All rights reserved.
//

import UIKit

final class AfterDateInfoCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!

    static var identifier: String {
        return String(describing: self)
    }

    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    func setInfo(info: Forecast) {
        titleLabel.text = "\(info.dateLabel)の天気： \(info.telop)"
    }
}
