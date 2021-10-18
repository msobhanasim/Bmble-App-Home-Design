//
//  HomeVC.swift
//  Datify-iOS
//
//  Created by Sobhan Asim on 06/10/2021.
//

import UIKit

class HomeVC: BaseViewController {
    
    
    static let identifier = "HomeVC"
    
    var homeViewModel: HomeViewModel = HomeViewModel()
    
    @IBOutlet weak var cardsParentView: UIView!
    
    @IBOutlet weak var likedIcon: UIImageView!
    @IBOutlet weak var unlikedIcon: UIImageView!
    
    @IBOutlet weak var unlikedIconMidConstraint: NSLayoutConstraint! // -300 for hide/ 0 for middle screen
    @IBOutlet weak var likedIconMidConstraint: NSLayoutConstraint! // 300 for hide/ 0 for middle screen
    
    /// `Scroll View indicator view top Constraint`
    @IBOutlet weak var scrollViewIndicatorViewTopCons: NSLayoutConstraint!
    @IBOutlet weak var scrollViewIndicatorContainerView: UIView!
    @IBOutlet weak var scrollViewIndicatorView: UIView!
    
    /// `No Data View Outlets`
    @IBOutlet weak var noDataView           : UIView!
    @IBOutlet weak var noDataViewImage      : UIImageView!
    @IBOutlet weak var noDataViewTitle      : UILabel!
    @IBOutlet weak var noDataViewDescription: UILabel!
    @IBOutlet weak var noDataViewBtn        : UIButton!
    
    let cardStack = SwipeCardStack()
    
    var min = -301
    var max = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func setViews() {
        cardStack.delegate = self
        cardStack.dataSource = self
        scrollViewIndicatorViewTopCons.constant = 0
        cardsParentView.addSubview(cardStack)
        
        cardStack.anchor(top: cardsParentView.safeAreaLayoutGuide.topAnchor,
                         left: cardsParentView.safeAreaLayoutGuide.leftAnchor,
                         bottom: cardsParentView.safeAreaLayoutGuide.bottomAnchor,
                         right: cardsParentView.safeAreaLayoutGuide.rightAnchor,
                         paddingTop: 20,
                         paddingLeft: 5,
                         paddingBottom: 12,
                         paddingRight: 5)
        
        
    }
    
    func getData() {
        
        homeViewModel.getUsersList { users, err in
            if let error = err {
                self.showCustomAlert(title: "Error", message: error.localizedDescription, btnString: "Ok")
            } else {
                
                self.homeViewModel = HomeViewModel(user: users)
                self.cardStack.reloadData()
                
            }
        }

    }
    
    @IBAction func onClickReload(_ sender: Any) {
        self.cardStack.reloadData()
    }
    
}

//MARK:- api calling and management
extension HomeVC {
    func likeDislikeUser (userId : Int , isLike : Bool, index: Int = 0) {
        
    }
}

//MARK:- SWIPING CARDS
extension HomeVC : SwipeCardStackDelegate , SwipeCardStackDataSource {
    
    func cardInStackDidBeginSwipe(_ cardStack: SwipeCardStack, _ card: SwipeCard, _ recognizer: UIPanGestureRecognizer) {
        print("Card Swipe Begin")
        resetActionIcons()
        
    }
    
    func resetActionIcons(){
        self.likedIconMidConstraint.constant = 300
        self.unlikedIconMidConstraint.constant = -300
        max = 0
        min = -301
        self.animateLittle()
    }
    
    func cardInStackDidContinueSwipe(_ cardStack: SwipeCardStack, _ card: SwipeCard, _ recognizer: UIPanGestureRecognizer) {
        
        //        print("Card Swipe Continued")
        
        print(recognizer.translation(in: card).x)
        
        let horizontalPoint = (recognizer.translation(in: card)).x
        
        if (horizontalPoint < 0) {
            // Going Left
            print("unlikedIconMidConstraint.constant: ", unlikedIconMidConstraint.constant)
            if (min < Int(horizontalPoint)) {
                if unlikedIconMidConstraint.constant >= -300 {
                    unlikedIconMidConstraint.constant -= 5
                    print("Within Inner Range Left")
                } else {
                    unlikedIconMidConstraint.constant = 0
                }
                
            } else if (min > Int(horizontalPoint)) {
                if  unlikedIconMidConstraint.constant <= 0 {
                    unlikedIconMidConstraint.constant += 5
                    print("Within Inner Range -Left")
                } else {
                    unlikedIconMidConstraint.constant = 0
                }
                
            }
            
            min = Int(horizontalPoint)
            
        } else if horizontalPoint > 0 {
            // Going Right
            print("likedIconMidConstraint.constant: ", likedIconMidConstraint.constant)
            if (max > Int(horizontalPoint)) {
                if likedIconMidConstraint.constant <= 300 {
                    likedIconMidConstraint.constant += 5
                    print("Within Inner Range Right")
                } else {
                    likedIconMidConstraint.constant = 0
                }
                
            } else if (max < Int(horizontalPoint)) {
                if  likedIconMidConstraint.constant >= 0 {
                    likedIconMidConstraint.constant -= 5
                    print("Within Inner Range +Right")
                } else {
                    likedIconMidConstraint.constant = 0
                }
            }
            
            max = Int(horizontalPoint)
            
        }
        
    }
    
    func cardInStackDidFinishSwipeAnimation(_ cardStack: SwipeCardStack, _ card: SwipeCard, _ recognizer: UIPanGestureRecognizer) {
        //        print("Card Swipe Finished")
        resetActionIcons()
    }
    
    func cardInStackDidCancelSwipe(_ cardStack: SwipeCardStack, _ card: SwipeCard, _ recognizer: UIPanGestureRecognizer) {
        //        print("Card Swipe Cancelled")
        resetActionIcons()
    }
    
    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
        let card = SwipeCard()
        
        card.footerHeight = 80
        card.swipeDirections = [.left, .right]
        
        for direction in card.swipeDirections {
            card.setOverlay(ShuffleCardOverlay(direction: direction), forDirection: direction)
        }
        
        let contentView = ShuffleCardContentView(withImageUrl: "", placeHolder: #imageLiteral(resourceName: "star"), verified: false)
        contentView.delegate = self
        
        card.content = contentView
        
        return card
        
    }
    
    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        if homeViewModel.getNumberOfUsers() > 0{
            noDataView.isHidden = true
        } else {
            noDataView.isHidden = false
        }
        
        return homeViewModel.getNumberOfUsers()
    }
    
    func didSwipeAllCards(_ cardStack: SwipeCardStack) {

        noDataView.isHidden = false
        
        
        // show matches no data view
        
        noDataViewImage.image = #imageLiteral(resourceName: "NoMoreProfiles")
        noDataViewTitle.text = "No more profiles"
        noDataViewDescription.text = "You have swipped all the profiles. No more profiles to show."
        noDataViewBtn.setTitle("Load More", for: .normal)
        
        
        
        resetActionIcons()
    }
    
    func cardStack(_ cardStack: SwipeCardStack, didUndoCardAt index: Int, from direction: SwipeDirection) {
        noDataView.isHidden = true
        print("Undo \(direction) swipe on \(homeViewModel.getUserItemAtIndexPath(indexPath: IndexPath(item: index, section: 0)).userFirstName ?? "")")
    }
    
    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
            switch direction {
            
            case .left:
                print("left")
                
                
            case .right:
                
                print("right")
                
            case .up:
                print("up")
                
            case .down:
                print("down")
                
            }
            
            print("Swiped \(direction) on \(homeViewModel.getUserItemAtIndexPath(indexPath: IndexPath(item: index, section: 0)).userFirstName ?? "")")
        
    }
    
    func cardStack(_ cardStack: SwipeCardStack, didSelectCardAt index: Int) {
        print("Card tapped")
    }
    
}

//MARK:- ShuffleCardContentView's TableView Scroll Delegate
extension HomeVC : ShuffleCardContentViewDelegate {
    
    func contentScrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollPercent = (scrollView.contentOffset.y / scrollView.contentSize.height)
        
        let indicatorViewHeight = scrollViewIndicatorView.frame.height
        let indicatorContainerViewHeight = scrollViewIndicatorContainerView.frame.height
        
        let substractiveFactor = (indicatorViewHeight / indicatorContainerViewHeight) * indicatorViewHeight
        
        let totalHeightWithAdjustedConstraints = indicatorContainerViewHeight - substractiveFactor
        
        
        scrollViewIndicatorViewTopCons.constant = (scrollPercent * totalHeightWithAdjustedConstraints)
        
        print("scrollViewIndicatorViewTopCons.constant = (scrollPercent * totalHeightWithAdjustedConstraints) >>>", (scrollPercent * totalHeightWithAdjustedConstraints))

    }
    
}



/*
 
 //Scroll view delegate method
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0{
            //scrolling down
            self.tabBarController?.setTabBarVisible(visible: false, duration: 0.3, animated: true, tableView: tableView)
        }
        else{
            //scrolling up
            self.tabBarController?.setTabBarVisible(visible: true, duration: 0.3, animated: true, tableView: tableView)
        }
    }




 func setTabBarVisible(visible:Bool, duration: TimeInterval, animated:Bool,tableView:UITableView) {
    if (tabBarIsVisible() == visible) { return }
    let frame = self.tabBar.frame
    let height = frame.size.height
    let offsetY = (visible ? -height : height)
    let heightToAdjusted = visible ? 0:22
    // animation
    if #available(iOS 10.0, *) {
        UIViewPropertyAnimator(duration: duration, curve: .linear) {
            self.tabBar.frame = CGRect(x: 0, y: self.view.frame.height+offsetY, width: self.view.frame.width, height: height)

            tableView.frame = CGRect(x: tableView.frame.origin.x, y:  tableView.frame.origin.y, width:  tableView.bounds.width, height:  tableView.bounds.height+offsetY)

            self.view.setNeedsDisplay()
            self.view.layoutIfNeeded()
            }.startAnimation()
    } else {
        // Fallback on earlier versions
    }
}
 
 */
