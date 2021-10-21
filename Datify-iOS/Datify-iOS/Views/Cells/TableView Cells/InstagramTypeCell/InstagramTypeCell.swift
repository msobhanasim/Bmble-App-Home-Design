//
//  InstagramTypeCell.swift
//  Datify-iOS
//
//  Created by Sobhan Asim on 06/10/2021.
//

import UIKit

class InstagramTypeCell: UITableViewCell {

    static let identifier = "InstagramTypeCell"
    
    @IBOutlet weak var instagramCollectionView: UICollectionView!
    @IBOutlet weak var instagramCollectionViewHeightConstraint: NSLayoutConstraint!
    
    var instagramPhotos: [String] = []
    var width: CGFloat = 0.0
    
    private let sectionInsets = UIEdgeInsets(
      top: 2,
      left: 2,
      bottom: 2,
      right: 2)
    private let itemsPerRow: CGFloat = 3
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpCollectionView()
        
    }
    
     func setUpCollectionView(){
        instagramPhotos = [
            "andrew",
            "bailey",
            "daiane",
            "andrew",
            "bailey",
            "daiane",
            "andrew",
            "bailey",
            "daiane"

        ]

        instagramCollectionView.delegate = self
        instagramCollectionView.dataSource = self
        instagramCollectionView.register(UINib(nibName: InstagramCell.identifier,
                                               bundle: nil),
                                         forCellWithReuseIdentifier: InstagramCell.identifier
        )

//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//
//        instagramCollectionView.collectionViewLayout = layout

        instagramCollectionView.reloadData()
        configureHeight()
    }
    
    
    func configureHeight(){
        
        if bounds.size != instagramCollectionView.collectionViewLayout.collectionViewContentSize {
            instagramCollectionView.invalidateIntrinsicContentSize()
            instagramCollectionView.collectionViewLayout.invalidateLayout()
        }
        
        instagramCollectionViewHeightConstraint.constant = instagramCollectionView.collectionViewLayout.collectionViewContentSize.height
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


// MARK: - Collection view Delegates
extension InstagramTypeCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return instagramPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Card Selected at \(indexPath.item + 1)")
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InstagramCell.identifier, for: indexPath) as! InstagramCell

        cell.instaProfileImageView.image = UIImage(named: instagramPhotos[indexPath.item])
        cell.instaProfileImageView.contentMode = .scaleAspectFill

        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
      ) -> CGSize {
        // 2
        let paddingSpace = sectionInsets.left * (itemsPerRow)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
      }
      
      // 3
      func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
      ) -> UIEdgeInsets {
        return sectionInsets
      }
      
      // 4
      func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
      ) -> CGFloat {
        return sectionInsets.left
      }
}
