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



@objc public protocol ShuffleCardContentViewDelegate: AnyObject{
    
    @objc
    optional func contentScrollViewDidScroll(_ scrollView: UIScrollView)
    
}


class ShuffleCardContentView: UIView {
    
    weak var delegate: ShuffleCardContentViewDelegate?
    
    private var isVerified : Bool = false
    private var verifiedImage  : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let backgroundView: UIView = {
        let background = UIView()
        background.clipsToBounds = false
//        background.layer.cornerRadius = 18
        return background
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.contentMode = .scaleAspectFill
        tableView.delaysContentTouches = false
        return tableView
    }()
    
    init(withImage image: UIImage? , verified : Bool) {
        super.init(frame: .zero)
//        imageView.image = image
        self.isVerified = verified
        
        if isVerified {
            verifiedImage.image = #imageLiteral(resourceName: "favourite")
            verifiedImage.frame = CGRect(x: 12, y: 12, width: 30, height: 30    )
            addSubview(verifiedImage)
        } else {
            
            verifiedImage.frame = CGRect(x: 0, y: 0, width: 0, height: 0    )
            verifiedImage.removeFromSuperview()
        }
        
        initialize()
    }
    
    init(withImageUrl imageUrl: String , placeHolder : UIImage , verified : Bool) {
        super.init(frame: .zero)
        self.isVerified = verified
        
        if isVerified {
            verifiedImage.image = #imageLiteral(resourceName: "favourite")
            verifiedImage.frame = CGRect(x: 12, y: 12, width: 30, height: 30    )
            addSubview(verifiedImage)
        } else {
            
            verifiedImage.frame = CGRect(x: 0, y: 0, width: 0, height: 0    )
            verifiedImage.removeFromSuperview()
        }
        
        self.initialize()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    private func initialize() {
        addSubview(backgroundView)
        backgroundView.anchorToSuperview()
        setupTableView()
//        applyShadow(radius: 8, opacity: 0.2, offset: CGSize(width: 0, height: 2))
        
        if isVerified {
            verifiedImage.image = #imageLiteral(resourceName: "favourite")
            verifiedImage.frame = CGRect(x: 12, y: 12, width: 30, height: 30    )
            addSubview(verifiedImage)
        } else {
            
            verifiedImage.frame = CGRect(x: 0, y: 0, width: 0, height: 0    )
            verifiedImage.removeFromSuperview()
        }
    }
    
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        backgroundView.addSubview(tableView)
        
        tableView.anchorToSuperview()
        
        tableView.separatorStyle = .none
        
        tableView.register(UINib(nibName: HeaderTypeCell.identifier,
                                 bundle: nil),
                           forCellReuseIdentifier: HeaderTypeCell.identifier
        )
        
        tableView.register(UINib(nibName: FooterTypeCell.identifier,
                                 bundle: nil),
                           forCellReuseIdentifier: FooterTypeCell.identifier
        )
        
        tableView.register(UINib(nibName: InstagramTypeCell.identifier,
                                 bundle: nil),
                           forCellReuseIdentifier: InstagramTypeCell.identifier
        )
        
        tableView.register(UINib(nibName: TextAndTagsTypeCell.identifier,
                                 bundle: nil),
                           forCellReuseIdentifier: TextAndTagsTypeCell.identifier
        )
        
        tableView.register(UINib(nibName: SimpleImageTypeCell.identifier,
                                 bundle: nil),
                           forCellReuseIdentifier: SimpleImageTypeCell.identifier
        )
        
        tableView.bouncesZoom = false
        tableView.showsVerticalScrollIndicator = false
        tableView.bounces = false
        
        tableView.reloadData()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
}

extension ShuffleCardContentView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return self.bounds.height
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return 7
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let tableViewCell = tableView.dequeueReusableCell(withIdentifier: HeaderTypeCell.identifier, for: indexPath) as! HeaderTypeCell
            HeaderTypeCell.index += 1
            tableViewCell.userProfileTagsCollView.reloadData()
            return tableViewCell
            
        case 1:
            switch indexPath.row {
            case 0:
                let tableViewCell = tableView.dequeueReusableCell(withIdentifier: TextAndTagsTypeCell.identifier, for: indexPath) as! TextAndTagsTypeCell
//                tableViewCell.setUpCollectionView()
                return tableViewCell
                
            case 1:
                let tableViewCell = tableView.dequeueReusableCell(withIdentifier: SimpleImageTypeCell.identifier, for: indexPath) as! SimpleImageTypeCell
                tableViewCell.calculateAndUpdateCellHeight(forGivenWidth: self.bounds.width)
                return tableViewCell
                
            case 2:
                let tableViewCell = tableView.dequeueReusableCell(withIdentifier: SimpleImageTypeCell.identifier, for: indexPath) as! SimpleImageTypeCell
                tableViewCell.calculateAndUpdateCellHeight(forGivenWidth: self.bounds.width)
                return tableViewCell
                
            case 3:
                let tableViewCell = tableView.dequeueReusableCell(withIdentifier: SimpleImageTypeCell.identifier, for: indexPath) as! SimpleImageTypeCell
                tableViewCell.calculateAndUpdateCellHeight(forGivenWidth: self.bounds.width)
                return tableViewCell
                
            case 4:
                let tableViewCell = tableView.dequeueReusableCell(withIdentifier: TextAndTagsTypeCell.identifier, for: indexPath) as! TextAndTagsTypeCell
//                tableViewCell.setUpCollectionView()
                return tableViewCell
                
            case 5:
                let tableViewCell = tableView.dequeueReusableCell(withIdentifier: SimpleImageTypeCell.identifier, for: indexPath) as! SimpleImageTypeCell
                tableViewCell.calculateAndUpdateCellHeight(forGivenWidth: self.bounds.width)
                return tableViewCell
                
            case 6:
                let tableViewCell = tableView.dequeueReusableCell(withIdentifier: InstagramTypeCell.identifier, for: indexPath) as! InstagramTypeCell
                tableViewCell.width = self.bounds.width
                return tableViewCell
                
            default:
                let tableViewCell = tableView.dequeueReusableCell(withIdentifier: HeaderTypeCell.identifier, for: indexPath) as! HeaderTypeCell
                return tableViewCell
                
            }
            
        case 2:
            let tableViewCell = tableView.dequeueReusableCell(withIdentifier: FooterTypeCell.identifier, for: indexPath) as! FooterTypeCell
            return tableViewCell
            
        default:
            return UITableViewCell()
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.contentScrollViewDidScroll?(scrollView)
    }
    
    
}
