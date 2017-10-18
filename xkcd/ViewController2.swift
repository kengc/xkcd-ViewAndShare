//
//  ViewController2.swift
//  xkcd
//
//  Created by Kevin Cleathero on 2017-08-15.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

import UIKit
import ImageScrollView
import SideMenu
import RealmSwift

class ViewController2: UIViewController {

    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBOutlet var randomButton: UIButton!
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    @IBOutlet var imageScrollView: ImageScrollView!
    
    var totalComicNum:Int = 0
    var currentComicNum:Int = 1
    var comicObject = ComicModel()
    var loadFromDB = false
    
    override func viewDidAppear(_ animated: Bool) {
        if !loadFromDB{
            getComic()
        }
        loadFromDB = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //getComic()
        
        //randomButton.frame.size.width = 65.0
        
        titleLabel.lineBreakMode = .byWordWrapping;
        titleLabel.numberOfLines = 0;
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
     
        setupSideMenu()
        setDefaults()

        //setup observer for this class
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController2.SaveFavoriteComicNotification(notification:)), name: Notification.Name("SaveComicNotification"), object: nil)
    
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController2.ShowFavoriteComicNotification(notification:)), name: Notification.Name("ShowFavoriteComicNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController2.SetLoadFromDBNotification(notification:)), name: Notification.Name("SetLoadFromDBNotification"), object: nil)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    
    func setupSideMenu() {
        // Define the menus
        SideMenuManager.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController

        SideMenuManager.menuAddPanGestureToPresent(toView: self.view)
        
        // Set up a cool background image for demo purposes
        SideMenuManager.menuAnimationBackgroundColor = UIColor(patternImage: UIImage(named: "grey3")!)


        
     
        print("menuAnimationFadeStrength", SideMenuManager.menuAnimationFadeStrength)
        
   
        print("menuShadowOpacity", SideMenuManager.menuShadowOpacity)
        
       
        print("menuAnimationTransformScaleFactor", SideMenuManager.menuAnimationTransformScaleFactor)
        

        print("menuWidth", SideMenuManager.menuWidth)
        
     
        print("menuFadeStatusBar", SideMenuManager.menuFadeStatusBar)
        
        
    }
    
    func setDefaults() {
        //let modes:[SideMenuManager.MenuPresentMode] = [.menuSlideIn, .viewSlideOut, .viewSlideInOut, .menuDissolveIn]
        SideMenuManager.menuPresentMode = .viewSlideInOut
        SideMenuManager.menuBlurEffectStyle = .light
    }

    
    func getComic(){
        
        if CheckNetworkStatus(){
        
            APIDataHelper.fetchComic(comicNum: 0)  { (comic, error) in
            
                if let error = error {
                    self.displayAlert(error: error)
                } else {
                
                    self.totalComicNum = comic.comicNum
                    self.SetViewWithAPIImage(comic:comic)
                }
            }
        } //if
        else {
            self.SetDefaultImage()
        }
    }
    
    @IBAction func lastAction(_ sender: UIButton) {
        
      if CheckNetworkStatus(){
        APIDataHelper.fetchComic(comicNum: 0) { (comic, error) in
            if let error = error {
                self.displayAlert(error: error)
            } else {
                self.totalComicNum = comic.comicNum
                self.SetViewWithAPIImage(comic:comic)
            }
        }
      } else {
        self.SetDefaultImage()
        }
    }
    
    @IBAction func RandomAction(_ sender: UIButton) {
        //get random number
        if CheckNetworkStatus(){
            if (self.totalComicNum < 1){
                getComic()
            }
            else {
                let randomComicNum = ComicHelper.randomNumber(inRange: 1...self.totalComicNum)
                FetchComic(comicID: randomComicNum)
            }
        } else {
            self.SetDefaultImage()
        }
    }
    
    
    @IBAction func NextAction(_ sender: UIButton) {
        
        if CheckNetworkStatus(){
            
            if totalComicNum < 2 {
                getComic()
            } else if currentComicNum != totalComicNum {
                FetchComic(comicID: currentComicNum + 1)
            }
        } else {
            self.SetDefaultImage()
        }
    }
    
    
    @IBAction func PrevAction(_ sender: UIButton) {
      
        if CheckNetworkStatus(){
            if currentComicNum > 1 {
                FetchComic(comicID: currentComicNum - 1)
            } else {
                getComic()
            }
        } else {
            self.SetDefaultImage()
        }
    }
    
    @IBAction func firstAction(_ sender: UIButton) {
       if CheckNetworkStatus(){
            FetchComic(comicID: 1)
        } else {
            self.SetDefaultImage()
        }
    }
    
   
    
    func FetchComic(comicID: Int){
        
      if CheckNetworkStatus(){
        APIDataHelper.fetchComic(comicNum: comicID) { (comic, error) in
            if let error = error {
                self.displayAlert(error: error)
            } else {
                self.SetViewWithAPIImage(comic:comic)
            }
        }
      } else {
        self.SetDefaultImage()
        }
    }
    
    
    func displayAlert(error: Error){
        
        let alert = UIAlertController(title: "Error retrieving comic", message: "\(error)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            print("OK")
        })
        
        self.present(alert, animated: true)
    }
    
    
    
    func CheckNetworkStatus() -> Bool {
        
        var available = true
        
        Reachability.isInternetAvailable(webSiteToPing: nil) { (isInternetAvailable) in
            if !(isInternetAvailable) {
            
            //guard isInternetAvailable else {
                // Inform user for example
                //var errorTemp = NSError(domain:"", code:.statusCode, userInfo:nil)
                //"No connectivity available")
                let userInfo: [AnyHashable : Any] =
                    [
                        NSLocalizedDescriptionKey :  NSLocalizedString("No Network Connectivity", value: "No Network Connectivity", comment: "") ,
                        // NSLocalizedFailureReasonErrorKey : NSLocalizedString("Unauthorized", value: "Account not activated", comment: "")
                        //NSLocalizedFailureReasonErrorKey : NSLocalizedString("Unauthorized", value: "Account not activated", comment: "")
                ]
                let err = NSError(domain: "ShiploopHttpResponseErrorDomain", code: 401, userInfo: userInfo)
                print("Error in Post: \(err.localizedDescription)")
                
                self.displayAlert(error: err)
                available = false
            } else{
                available = true
            }
        }
        return available
    }
    
    func SetViewWithAPIImage(comic:ComicModel){
        
        self.spinner.center = (self.imageScrollView.center)
        self.spinner.color = UIColor.black
        self.spinner.startAnimating()
        self.spinner.hidesWhenStopped = true
        self.comicObject = comic
    
            // Do some action if there is Internet
            APIDataHelper.fetchImage(comic: comic) { (image) in
                
                self.imageScrollView.display(image: image)
                self.comicObject.image = image
                self.spinner.stopAnimating()
            }
        
        self.currentComicNum = comic.comicNum
        self.titleLabel.text = comic.shortTitle
    
    }
    
    func SetDefaultImage(){
        let defaultImage = UIImage(named:"noimage.png")
        self.imageScrollView.display(image: defaultImage!)
        self.titleLabel.text = "No Connectivity"
    }
    
    func SetViewWithCacheImage(comic:SaveComicModel){
        
        self.spinner.center = (self.imageScrollView.center)
        self.spinner.color = UIColor.black
        self.spinner.startAnimating()
        self.spinner.hidesWhenStopped = true
        
        self.comicObject.comicLink = comic.comicLink
        self.comicObject.comicNum = comic.comicNum
        self.comicObject.imgURL = comic.imgURL
        self.comicObject.title = comic.title
        
        //let path:String = url.path
        
        guard let path = comic.imgName else {
            assert(false, "Invalid imgPath")
        }
        
        let image = UIImage(contentsOfFile: (path))
        
        guard let img = image else {
            assert(false, "Invalid img")
        }
        
        self.comicObject.image = img
        
        //APIDataHelper.fetchImage(comic: comic) { (image) in
        self.imageScrollView.display(image: img)
        self.spinner.stopAnimating()
         
        self.currentComicNum = comic.comicNum
        self.titleLabel.text = comic.title
        
    }
    
    
    @IBAction func shareAction(_ sender: Any) {
        print("inside saveACion")
        
//        let image = snapshot(view: self.imageScrollView)
//
//        ShareToMedia(image: image)
         ShareToMedia()
    }
    
    
    func snapshot(view :ImageScrollView ) -> (UIImage)
    {

        UIGraphicsBeginImageContextWithOptions(imageScrollView.bounds.size, true, 0);
        
        print("images size is: ", self.comicObject.image.size)

        imageScrollView.drawHierarchy(in: imageScrollView.bounds, afterScreenUpdates: true)
        
        let image :UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image;
    }
    
    
    func SaveImageOffline(saveObject :SaveComicModel) -> Bool {
        //save image file to documents directory
        //save link as part of object
        
        let fileManager = FileManager.default
        do {
            let documentsDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let imageName = UUID().uuidString + ".jpg"

            let fileURL = documentsDirectory.appendingPathComponent(imageName)
            print(fileURL)
            
            if let imageData = UIImageJPEGRepresentation(self.comicObject.image, 0.5) {
                try imageData.write(to: fileURL)
                saveObject.imgName = imageName
                return true
            }
        } catch {
            print(error)
        }
        return false
        
    }
    
    
    func SaveFavoriteComicNotification(notification: Notification){
        print("in the NSNotificatin receiver method")
        
        //NotificationCenter.default.removeObserver(self) //removed the observer
        
        let saveComicObject = SaveComicModel()

        let myPrimaryKey = self.comicObject.imgURL
        
        // Get the default Realm
        let realm = try! Realm()
        
        let specificComic = realm.object(ofType: SaveComicModel.self, forPrimaryKey: myPrimaryKey)
        
        if specificComic != nil {
            //don't add
            let alert = UIAlertController(title: "Did Not Save", message: "Comic already exists", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                print("OK")
            })
            
            self.present(alert, animated: true)
        } else {
            //add our object to the DB
            // Persist data
           if SaveImageOffline(saveObject: saveComicObject){
            
            saveComicObject.comicLink = self.comicObject.comicLink
            saveComicObject.comicNum = self.comicObject.comicNum
            saveComicObject.imgURL = self.comicObject.imgURL
            saveComicObject.title = self.comicObject.shortTitle
            
            try! realm.write {
                //call to save image?
                    realm.add(saveComicObject)
                }
            }
        }
    }
    
    
    
     public func ShareToMedia(){
        
        let myWebsite = NSURL(string:self.comicObject.imgURL)

        let shareItems:Array = [myWebsite as Any]
        
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        
        activityViewController.excludedActivityTypes = []
        
        //if iPhone
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone) {
           self.present(activityViewController, animated: true, completion: nil)
        } else { //if iPad
            // Change Rect to position Popover
            
            let popoverCntlr = UIPopoverController(contentViewController: activityViewController)
            popoverCntlr.present(from: CGRect(x: self.view.frame.size.width/2, y: self.view.frame.size.height/4,width: 0,height: 0), in: self.view, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
            
        }
    }
    
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        self.imageScrollView.recover()
    }
    
    func SetLoadFromDBNotification(notification: Notification){
        loadFromDB = true
    }
    
    func ShowFavoriteComicNotification(notification: Notification){
        
        if let comic = notification.userInfo?["favorite"] as? SaveComicModel {
            
            let fileManager = FileManager.default
            
            do {
            let documentsDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
                
            if let _ = comic.imgName?.isEmpty, !(comic.imgName?.isEmpty)! {
                
                let fileURL = documentsDirectory.appendingPathComponent((comic.imgName)!)

                if let image = UIImage(contentsOfFile: (fileURL.path)){
                
                    self.comicObject.image = image
                    self.imageScrollView.display(image: image)
                    self.comicObject.shortTitle = comic.title
                    self.comicObject.comicNum = comic.comicNum
                    self.comicObject.comicLink = comic.comicLink
                    self.comicObject.imgURL = comic.imgURL
                    self.currentComicNum = comic.comicNum
                    self.titleLabel.text = comic.title
                    loadFromDB = true
                }
                else {
                    //if not then fetch from api
                    FetchComic(comicID: comic.comicNum)
                }
            } else {
                //if not then fetch from api
                FetchComic(comicID: comic.comicNum)
            }
        } catch{
                print(error)
            }
        }
    }
}
