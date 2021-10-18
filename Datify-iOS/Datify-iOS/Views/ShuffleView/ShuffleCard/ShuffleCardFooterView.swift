///
/// MIT License
///
/// Copyright (c) 2020 Mac Gallagher
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.
///

import UIKit

class ShuffleCardFooterView: UIView {
    
    private var label = UILabel()
    private var distanceLabel = UILabel()
    private var distanceView = UIView()
    private var distanceIcon = UIImageView()
    
    private var gradientLayer: CAGradientLayer?
    
    init(withTitle title: String?, subtitle: String? , distance : String = "0 Miles" ) {
        super.init(frame: CGRect.zero)
        //    backgroundColor = .clear
        
        
        backgroundColor = UIColor(hexColor: "000000").withAlphaComponent(0.7)
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        layer.cornerRadius = 13
        clipsToBounds = true
        isOpaque = false
        initialize(title: title, subtitle: subtitle, distance: distance)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    private func initialize(title: String?, subtitle: String? , distance : String) {
        let attributedText = NSMutableAttributedString(string: (title ?? "") + "\n",
                                                       attributes: NSAttributedString.Key.titleAttributes)
        
        if let subtitle = subtitle, !subtitle.isEmpty {
            attributedText.append(NSMutableAttributedString(string: subtitle,
                                                            attributes: NSAttributedString.Key.subtitleAttributes))
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            paragraphStyle.lineBreakMode = .byTruncatingTail
            attributedText.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle],
                                         range: NSRange(location: 0, length: attributedText.length))
            label.numberOfLines = 2
        }
        
        distanceLabel.attributedText = NSMutableAttributedString(string: distance ,
                                                                 attributes: NSAttributedString.Key.distanceTitleAttributes)
        
        label.attributedText = attributedText
        addSubview(distanceView)
        addSubview(label)
        
    }
    
    
    
    override func layoutSubviews() {
        let padding: CGFloat = 20
        label.frame = CGRect(x: padding,
                             y: bounds.height - label.intrinsicContentSize.height - padding,
                             width: (bounds.width - 2 * padding - 100),
                             height: label.intrinsicContentSize.height)
        
        setDisatnceView()
        
        
        
        
    }
    func setDisatnceView () {
        distanceView.backgroundColor = .clear
        distanceView.cornerRadius = 14
        distanceView.frame = CGRect(x: bounds.width - 70, y: 0, width: 70, height: bounds.height)
        distanceLabel.frame = CGRect(x: 18, y: 0, width: 60, height: distanceView.bounds.height)
        distanceIcon.image = UIImage(named: "locationPin")?.withRenderingMode(.alwaysTemplate)
        distanceIcon.frame = CGRect(x: 0, y: 0, width: 15, height: distanceView.bounds.height)
        distanceIcon.tintColor = .white
        distanceIcon.backgroundColor = .clear
        distanceIcon.contentMode = .scaleAspectFit
//        (distanceView.bounds.height / 2) - 7.5
        
        distanceView.addSubview(distanceLabel)
        distanceView.addSubview(distanceIcon)
        
    }
}

extension NSAttributedString.Key {
    
    static var shadowAttribute: NSShadow = {
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: 0, height: 1)
        shadow.shadowBlurRadius = 2
        shadow.shadowColor = UIColor.black.withAlphaComponent(0.3)
        return shadow
    }()
    
    
    
    static var distanceTitleAttributes: [NSAttributedString.Key: Any] = [
        // swiftlint:disable:next force_unwrapping
        //    NSAttributedString.Key.font: UIFont(name: "ArialRoundedMTBold", size: 24)!,
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.0),
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.shadow: NSAttributedString.Key.shadowAttribute
    ]
    static var titleAttributes: [NSAttributedString.Key: Any] = [
        // swiftlint:disable:next force_unwrapping
        //    NSAttributedString.Key.font: UIFont(name: "ArialRoundedMTBold", size: 24)!,
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.0),
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.shadow: NSAttributedString.Key.shadowAttribute
    ]
    
    static var subtitleAttributes: [NSAttributedString.Key: Any] = [
        // swiftlint:disable:next force_unwrapping
        //    NSAttributedString.Key.font: UIFont(name: "Arial", size: 17)!,
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.0),
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.shadow: NSAttributedString.Key.shadowAttribute
    ]
}
