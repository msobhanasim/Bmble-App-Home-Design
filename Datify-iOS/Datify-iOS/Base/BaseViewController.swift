//
//  BaseViewController.swift
//  A2i
//
//  Created by coding pixel on 16/12/2020.
//

import UIKit
import Foundation
import Photos
import StoreKit
import MessageUI

enum Storyboards : String{
    case Home = "Home"
    case Main = "Main"
    case Podcast = "Podcast"
    case Profile = "Profile"
    case Matches = "Mtches"
    
    func board() -> String {
        return self.rawValue
    }
}


enum ThemeMode: String {
    case light = "light"
    case dark = "dark"
}

var firstAlbumAssets : [PHAsset] = [PHAsset]()
var currentAlbum : PHAssetCollection = PHAssetCollection.init()
var allAlbums : [CustomAlbum] =  [CustomAlbum]()
var fromWalkthroughOrLoginSequesce: Bool = false

func callUnauthenticated(){
    NotificationCenter.default.post(.init(name: Notification.Name(rawValue: "UnAuthenticated")))
}

func removeUnauthenticated(){
    NotificationCenter.default.removeObserver(BaseViewController.self, name: Notification.Name(rawValue: "UnAuthenticated"), object: nil)
}



class BaseViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate {
    
    var sceneDelegate: SceneDelegate {
        get {
            return (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate) ?? SceneDelegate()
        }
    }
    
    var allowGestureNavigationBack: Bool = true {
        didSet(didAlloewd){
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = didAlloewd
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        removeUnauthenticated()
    }
    
    
    func openBrowser(withUrl url: String){
        guard let url = URL(string: url) else { return }
        UIApplication.shared.open(url)
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if let subLayers = self.view.layer.sublayers {
            for (index, subLayer) in subLayers.enumerated() {
                if subLayer is CAGradientLayer {
                    self.view.layer.sublayers?.remove(at: index)
                }
            }
        }
    }
    
    var customWindow : UIWindow {
        return UIApplication.shared.windows.first!
    }
    
    var hasTopNotch: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
    
    func presentImagePicker(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        vc.mediaTypes = ["public.image"]
        self.present(vc, animated: true)
    }
    
    func ShowPopup() {
        
    }
    
    
    func sendEmail(usingEmail recipientEmail: String, subjectLine subject: String, BodyText body: String) {
        
        // Show default mail composer
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([recipientEmail])
            mail.setSubject(subject)
            mail.setMessageBody(body, isHTML: false)
            
            present(mail, animated: true)
            
            // Show third party email composer if default Mail app is not present
        } else if let emailUrl = createEmailUrl(to: recipientEmail, subject: subject, body: body) {
            UIApplication.shared.open(emailUrl)
        }
    }
    
    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
        
        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }
        
        return defaultUrl
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func fetchImagesFromGallery(collection: PHAssetCollection? , completion : @escaping (([PHAsset])->Void)) {
        DispatchQueue.main.async {
            var assets : [PHAsset] = [PHAsset]()
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",ascending: false)]
            
            //MARK:- FOR IMAGES AND VIDEOS
            fetchOptions.predicate = NSPredicate(format: "mediaType = %d || mediaType = %d",  PHAssetMediaType.image.rawValue)
            if let collection = collection {
                let assestsRec = PHAsset.fetchAssets(in: collection, options: fetchOptions)
                for index in 0..<assestsRec.count {
                    if  (assestsRec[index].mediaType == .image &&  assestsRec[index].sourceType == .typeUserLibrary ){
                        assets.append(assestsRec[index])
                    }
                    
                }
                
            } else {
                let assestsRec = PHAsset.fetchAssets(with: fetchOptions)
                for index in 0..<assestsRec.count {
                    assets.append(assestsRec[index])
                }
                
            }
            
            completion(assets)
            
        }
    }
    
    func fetchImagesFromGalleryBase(collection: PHAssetCollection? , complition : @escaping([PHAsset])-> Void) {
        var arrayOfPHAsset  = [PHAsset]()
        DispatchQueue.main.async {
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",ascending: false)]
            fetchOptions.predicate = NSPredicate(format: "mediaType = %d",  PHAssetMediaType.image.rawValue)
            
            if let collection = collection {
                let assestsRec = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                for index in 0..<assestsRec.count {
                    if (assestsRec[index].mediaType == .image &&  assestsRec[index].sourceType == .typeUserLibrary) {
                        arrayOfPHAsset.append(assestsRec[index])
                    }
                }
            } else {
                let assestsRec = PHAsset.fetchAssets(with: fetchOptions)
                for index in 0..<assestsRec.count {
                    arrayOfPHAsset.append(assestsRec[index])
                }
            }
            
            complition(arrayOfPHAsset)
        }
    }
    
    func loadFirstAlbum (albums : [CustomAlbum], complition : @escaping([CustomAlbum],PHAssetCollection)-> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            var settled = false
            
            for i in albums {
                
                if i.album.localizedTitle ?? "" == "Recents" {
                    settled = true
                    complition(albums,i.album)
                }
            }
            if !settled && albums.count > 0 {
                complition(albums,(albums.first?.album)!)
            }
            
        }
    }
    
    func topMostController() -> UIViewController {
        var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        
        while (topController.presentedViewController != nil) {
            topController = topController.presentedViewController!
            
        }
        
        return topController
    }
    
    func CollectionviewNoDataAvailabl(collection_view : UICollectionView , text : String , color:UIColor = UIColor.darkGray ) {
        let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: collection_view.bounds.size.width, height: collection_view.bounds.size.height))
        noDataLabel.font = UIFont(name: "SofiaProLight", size: 15)
        noDataLabel.text          = text + "   "
        noDataLabel.textColor     = color
        noDataLabel.textAlignment = .center
        noDataLabel.backgroundColor = .clear
        collection_view.backgroundView  = noDataLabel
    }
    
    func TableViewRemoveNoDataLable(tableview : UITableView ) {
        tableview.backgroundView  = nil
    } 
    
    func CollectionViewRemoveNoDataLable(collection_view : UICollectionView ) {
        collection_view.backgroundView  = nil
    }
    
    func TableViewNoDataAvailabl(tableview : UITableView , text : String, textColor: UIColor = UIColor.darkGray) {
        
        let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableview.bounds.size.width, height: tableview.bounds.size.height))
        noDataLabel.font = UIFont(name: "SofiaProLight", size: 15)
        noDataLabel.text          = text + "   "
        noDataLabel.textColor     = textColor
        noDataLabel.textAlignment = .center
        tableview.backgroundView  = noDataLabel
        tableview.separatorStyle  = .none
    }
    
    func shareToOtherApp(text : String , image : UIImage , isActualImage : Bool = false) {
        
        // set up activity view controller
        var list : [Any] = []
        if text != ""{
            list.append(text)
        }
        if isActualImage {
            list.append(image)
        }
        let activityViewController = UIActivityViewController(activityItems: list, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func checkPhotoLibraryPermission(completion: @escaping ((Bool)->Void)) {
        
        DispatchQueue.main.async {
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .denied, .restricted:
                completion(false)
                break
                
            case .authorized, .limited:
                completion(true)
                break
            //handle denied status
            case .notDetermined:
                // ask for permissions
                PHPhotoLibrary.requestAuthorization { status in
                    switch status {
                    case .denied, .restricted:
                        completion(false)
                        break
                        
                    case .authorized, .limited:
                        completion(true)
                        break
                    case .notDetermined:
                        // won't happen but still
                        completion(false)
                        break
                        
                    @unknown default:
                        completion(false)
                        break
                    }
                }
            @unknown default:
                completion(false)
                break
            }
        }
        
        
    }
    
    func openVc (vc : UIViewController) {
        if self.navigationController  != nil{
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            self.present(vc, animated : true)
        }
    }
    
    func back() {
        if let nev = self.navigationController {
            nev.popViewController(animated: true)
        } else {
            self.dismiss(animated: true) {}
        }
    }
    
    func launchOrder() {
        self.tabBarController?.selectedIndex = 1
        
    }
    
    func onTapMension(text: String) {
        print(text)
        
    }
    
    func showCustomAlertWithCancel(title:String, message:String, btnString: String, handlers: ((UIAlertAction) -> Void)? = nil){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: btnString, style: .default, handler: handlers))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showCustomAlertWithCancelAndTwoActions(title:String, message:String, btn1Title: String, btn1Style: UIAlertAction.Style = .default, btn2Title: String, btn2Style: UIAlertAction.Style = .default, handler1: ((UIAlertAction) -> Void)? = nil, handler2: ((UIAlertAction) -> Void)? = nil, presentationCompletion completion:(() -> Void)? = nil ){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: btn1Title, style: .default, handler: handler1))
        alertController.addAction(UIAlertAction(title: btn2Title, style: .default, handler: handler2))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: completion)
    }
    
    func showCustomAlertWithDeleteActionAndCancel(title:String, message:String, deleteActionHandler: ((UIAlertAction) -> Void)? = nil, cancelActionHandler: ((UIAlertAction) -> Void)? = nil, presentationCompletion completion:(() -> Void)? = nil ){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: deleteActionHandler))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: cancelActionHandler))
        self.present(alertController, animated: true, completion: completion)
    }
    
    func daysToMonths(from days: Int = 0) -> String{
        var formattedString = ""
        
        var months = Int(days / 30)
        
        return months > 1 ? (String(months) + " Months") : (String(months) + " Month")
    }
    
    func animateLittle(seconds : Double = 0.2){
        UIView.animate(withDuration: seconds) {
            self.view.layoutIfNeeded()
        }
    }
    
    func animateLittle(completion : @escaping (()->Void)){
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
            self.delay(0.1) {
                completion()
            }
        }
    }
    
    func Goback() {
        if let nev = self.navigationController{
            
            nev.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func createThumbnailOfVideoFromRemoteUrl(url: String) -> UIImage? {
        let asset = AVAsset(url: URL(string: url)!)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        //Can set this to improve performance if target size is known before hand
        //assetImgGenerate.maximumSize = CGSize(width,height)
        let time = CMTimeMakeWithSeconds(1.0, preferredTimescale: 600)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        } catch {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
    
}

extension BaseViewController {
    func ShowErrorAlert(message : String , AlertTitle : String ) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            self.simpleCustomeAlert(title: AlertTitle, discription: message)
        })
    }
    
    @objc func simpleCustomeAlert(title : String , discription : String) {
        SweetAlert().closeAlert(0)
        _ = SweetAlert().showAlert(title, subTitle: discription, style: AlertStyle.none)
    }
    
    @objc func ShowSuccessAlert(title:String,message : String , completion: @escaping () -> () ) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            self.oneBtnCustomeAlert(title: title, discription: message) { (isComp, btn) in
                completion()
            }
        })
    }
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) -> String {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        var addressString : String = ""
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
                                        if (error != nil)
                                        {
                                            print("reverse geodcode fail: \(error!.localizedDescription)")
                                        }
                                        
                                        if let pms = placemarks {
                                            
                                            let pm = pms as [CLPlacemark]
                                            
                                            if pm.count > 0 {
                                                let pm = pms[0]
                                                print(pm.country)
                                                print(pm.locality)
                                                print(pm.subLocality)
                                                print(pm.thoroughfare)
                                                print(pm.postalCode)
                                                print(pm.subThoroughfare)
                                                
                                                if pm.subLocality != nil {
                                                    addressString = addressString + pm.subLocality! + ", "
                                                }
                                                if pm.thoroughfare != nil {
                                                    addressString = addressString + pm.thoroughfare! + ", "
                                                }
                                                if pm.locality != nil {
                                                    addressString = addressString + pm.locality! + ", "
                                                }
                                                if pm.country != nil {
                                                    addressString = addressString + pm.country! + ", "
                                                }
                                                if pm.postalCode != nil {
                                                    addressString = addressString + pm.postalCode! + " "
                                                }
                                                
                                                
                                                print(addressString)
                                            }
                                        }
                                        
                                    })
        return addressString
        
    }
    
    
    @objc func oneBtnCustomeAlert(title : String , discription : String  , btnTitle : String = "OK" ,complition : @escaping(Bool,Int) -> Void) {
        SweetAlert().showAlert(title, subTitle: discription, style: AlertStyle.none, buttonTitle:"", buttonColor:UIColor.colorFromRGB(0xD0D0D0) , otherButtonTitle:  btnTitle, otherButtonColor: UIColor.colorFromRGB(0x2e84a5)) { (isOtherButton) -> Void in
            if isOtherButton == true {
                complition(true,1)
            }  else {
                complition(false,2)
            }
        }
    }
    
    @objc func confirmationCustomeAlert(title : String , discription : String , btnColor1: UIColor = UIColor.colorFromRGB(0x2e84a5), btnColor2: UIColor = UIColor.colorFromRGB(0xD0D0D0), btnTitle1 : String = "YES" , btnTitle2 : String = "NO" ,complition : @escaping(Bool,Int) -> Void) {
        SweetAlert().showAlert(title, subTitle: discription, style: AlertStyle.none, buttonTitle:btnTitle2, buttonColor:btnColor2 , otherButtonTitle:  btnTitle1, otherButtonColor: btnColor1) { (isOtherButton) -> Void in
            if isOtherButton == true {
                complition(false,2)
            }  else {
                complition(true,1)
            }
        }
    }
    
    //MARK: Delay
    func delay(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
}

extension UIViewController {
    func getVC(storyboard : Storyboards, vcIdentifier : String) -> UIViewController {
        
        return UIStoryboard(name: storyboard.board(), bundle: nil).instantiateViewController(withIdentifier: vcIdentifier)
    }
    
}

extension DispatchQueue {
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
    
}

extension BaseViewController {
    var isDarkMode: Bool {
        if #available(iOS 13.0, *) {
            return self.traitCollection.userInterfaceStyle == .dark
        }
        else {
            return false
        }
    }
}

extension UITableViewCell {
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

extension UIViewController {
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

struct PaypalPaymentDetail{
    var transactionNonce: String?
    var email: String?
    var firstName: String?
    var lastName: String?
    var phone: String?
    var billingAddress: String?
    var shippingAddress: String?
}

extension UIViewController{
    var screenWidth:CGFloat {
        get {
            return UIScreen.main.bounds.width
        }
    }
    
    var screenHeight:CGFloat {
        get {
            return UIScreen.main.bounds.height
        }
    }
    
}
class CustomAlbum {
    var coverimage = UIImage()
    var album = PHAssetCollection()
}


extension BaseViewController {
    
    func alertWithTitle(_ title: String, message: String) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alert
    }
    
    func showAlert(_ alert: UIAlertController) {
        guard self.presentedViewController != nil else {
            self.present(alert, animated: true, completion: nil)
            return
        }
    }

}

extension UITableViewCell{
    func animateLittle(seconds : Double = 0.2){
        UIView.animate(withDuration: seconds) {
            self.contentView.layoutIfNeeded()
        }
    }
    
    func animateLittle(completion : @escaping (()->Void)){
        UIView.animate(withDuration: 0.2) {
            self.contentView.layoutIfNeeded()
            self.delay(0.1) {
                completion()
            }
        }
    }
    
    func delay(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
}
