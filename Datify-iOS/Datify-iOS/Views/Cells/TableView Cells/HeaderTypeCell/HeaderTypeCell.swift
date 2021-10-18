//
//  HeaderTypeCell.swift
//  Datify-iOS
//
//  Created by Sobhan Asim on 06/10/2021.
//

import UIKit

class HeaderTypeCell: UITableViewCell {

    static let identifier = "HeaderTypeCell"
    
    @IBOutlet weak var userPhotoImg: UIImageView!
    
    @IBOutlet weak var userProfileTagsCollView: UICollectionView!
    
    @IBOutlet weak var userNameLbl: UILabel!
    
    @IBOutlet weak var occupationStackView: UIStackView!
    @IBOutlet weak var occupationImg: UIImageView!
    @IBOutlet weak var occupationLbl: UILabel!
    
    @IBOutlet weak var educationStackView: UIStackView!
    @IBOutlet weak var educationImg: UIImageView!
    @IBOutlet weak var educationLbl: UILabel!
    
    static var index = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpCollectionView()
    }
    
    func setUpCollectionView(){
        userProfileTagsCollView.delegate = self
        userProfileTagsCollView.dataSource = self
        userProfileTagsCollView.register(UINib(nibName: TagsCell.identifier,
                                               bundle: nil),
                                         forCellWithReuseIdentifier: TagsCell.identifier
        )
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        userProfileTagsCollView.collectionViewLayout = layout
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


// MARK: - Collection view Delegates
extension HeaderTypeCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HeaderTypeCell.index % 2 == 0 ? 2 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagsCell.identifier, for: indexPath) as! TagsCell
            
        
        switch indexPath.row {
        case 0:
            cell.tagTextLbl.text = "bff"
            cell.cellBackgroundView.backgroundColor = UIColor(hexColor: "4497BC")
            return cell
            
        case 1:
            cell.tagTextLbl.text = "Newly Joined"
            cell.cellBackgroundView.backgroundColor = UIColor(hexColor: "FDBD24")
            return cell
            
        default:
            cell.tagTextLbl.text = "bff"
            cell.cellBackgroundView.backgroundColor = UIColor(hexColor: "4497BC")
            
            return cell
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let cell = self.collectionView(collectionView, cellForItemAt: indexPath) as? TagsCell else {return CGSize(width: 10, height: 10)}
        
        return CGSize(width: 35 + ((cell.tagTextLbl.text ?? "bff").width(withConstraintedHeight: 18, font: UIFont(name: "Futura-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14))), height: 25)
        
    }
    
    
}
