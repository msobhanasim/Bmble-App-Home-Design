//
//  TextAndTagsTypeCell.swift
//  Datify-iOS
//
//  Created by Sobhan Asim on 06/10/2021.
//

import UIKit

struct HobbyTags{
    var imge: UIImage
    var text: String
}

class TextAndTagsTypeCell: UITableViewCell {

    static let identifier = "TextAndTagsTypeCell"
    
    @IBOutlet weak var userInterestsTagsCollView: DynamicHeightCollectionView!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    
    var hobbies: [HobbyTags] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpCollectionView()
        
    }
    
    func setUpCollectionView(){
        hobbies = [
            HobbyTags(imge: UIImage(systemName: "globe")!, text: "Trevelling World"),
            HobbyTags(imge: UIImage(systemName: "book")!, text: "Reading Books"),
            HobbyTags(imge: UIImage(systemName: "person.3")!, text: "Meeting New People"),
            HobbyTags(imge: UIImage(systemName: "bicycle")!, text: "Riding"),
            HobbyTags(imge: UIImage(systemName: "hand.wave")!, text: "Helping Others"),
            HobbyTags(imge: UIImage(systemName: "questionmark.circle")!, text: "Nothing")
        ]
        userInterestsTagsCollView.delegate = self
        userInterestsTagsCollView.dataSource = self
        userInterestsTagsCollView.register(UINib(nibName: IconTagsCell.identifier,
                                               bundle: nil),
                                         forCellWithReuseIdentifier: IconTagsCell.identifier
        )
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//
//        userInterestsTagsCollView.collectionViewLayout = layout
        
        userInterestsTagsCollView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


// MARK: - Collection view Delegates
extension TextAndTagsTypeCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hobbies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconTagsCell.identifier, for: indexPath) as! IconTagsCell
            
        cell.tagIcon.image = hobbies[indexPath.item].imge
        cell.tagTextLbl.text = hobbies[indexPath.item].text
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        guard let cell = self.collectionView(collectionView, cellForItemAt: indexPath) as? IconTagsCell else {return CGSize(width: 10, height: 10)}
        
        let width = CGSize(width: 50 + ((hobbies[indexPath.item].text ).width(withConstraintedHeight: 18, font: UIFont(name: "Futura-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14))), height: 25)
        
        print("Width: ", width)
        
        return width
        
    }
    
    // 3
    func collectionView(
      _ collectionView: UICollectionView,
      layout collectionViewLayout: UICollectionViewLayout,
      insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 2.0, bottom: 0.0, right: 0.0)
    }
    
    // 4
    func collectionView(
      _ collectionView: UICollectionView,
      layout collectionViewLayout: UICollectionViewLayout,
      minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 6.0
    }
    
    
}
