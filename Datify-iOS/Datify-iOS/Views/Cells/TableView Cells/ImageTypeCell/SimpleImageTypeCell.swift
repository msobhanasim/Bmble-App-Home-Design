//
//  SimpleImageTypeCell.swift
//  Datify-iOS
//
//  Created by Sobhan Asim on 06/10/2021.
//

import UIKit

class SimpleImageTypeCell: UITableViewCell {

    static let identifier = "SimpleImageTypeCell"
    
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func calculateAndUpdateCellHeight(forGivenWidth width: CGFloat){
        let heightInPoints = profileImageView.image?.size.height
        let heightInPixels = (heightInPoints ?? 1.0) * (profileImageView.image?.scale ?? 1.0)

        let widthInPoints = profileImageView.image?.size.width
        let widthInPixels = (widthInPoints ?? 1.0) * (profileImageView.image?.scale ?? 1.0)
        
        let ratio =  heightInPixels / widthInPixels
        
        imageHeight.constant = ratio * width
        
        UIView.animate(withDuration: 1.0) {
            self.contentView.layoutIfNeeded()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
