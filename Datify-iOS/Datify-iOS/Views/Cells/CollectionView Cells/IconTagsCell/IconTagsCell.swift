//
//  IconTagsCell.swift
//  Datify-iOS
//
//  Created by Sobhan Asim on 07/10/2021.
//

import UIKit

class IconTagsCell: UICollectionViewCell {

    static let identifier = "IconTagsCell"
    
    @IBOutlet weak var tagTextLbl: UILabel!
    @IBOutlet weak var tagIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
