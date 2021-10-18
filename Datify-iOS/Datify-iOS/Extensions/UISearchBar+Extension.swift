
//
//  UISearchBar+Extension.swift
//  LFW
//
//  Created by Jassie on 04/06/2018.
//  Copyright © 2018 CodingPixel. All rights reserved.
//

import Foundation
import UIKit

public extension UISearchBar {
    func setStyleColor(_ color: UIColor) {
        tintColor = color
        guard let tf = (value(forKey: "searchField") as? UITextField) else { return }
        tf.textColor = color
        if let glassIconView = tf.leftView as? UIImageView, let img = glassIconView.image {
            let newImg = img.blendedByColor(color)
            glassIconView.image = newImg
        }
        if let clearButton = tf.value(forKey: "clearButton") as? UIButton {
            clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
            clearButton.tintColor = color
        }
    }
}

