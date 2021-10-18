//
//  TagsCell.swift
//  Datify-iOS
//
//  Created by Sobhan Asim on 07/10/2021.
//

import UIKit

class TagsCell: UICollectionViewCell {

    static let identifier = "TagsCell"
    
    @IBOutlet weak var tagTextLbl: UILabel!
    @IBOutlet weak var cellBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
