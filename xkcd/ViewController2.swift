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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getComic()
        
        //randomButton.frame.size.width = 65.0
        
        titleLabel.lineBreakMode = .byWordWrapping;
        titleLabel.numberOfLines = 0;
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
     
        setupSideMenu()
        setDefaults()

        //setup observer for this class
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController2.methodOfReceivedNotification(notification:)), name: Notification.Name("SaveComicNotification"), object: nil)
    
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController2.ShowFavoriteComicNotification(notification:)), name: Notification.Name("ShowFavoriteComicNotification"), object: nil)
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
        SideMenuManager.menuAnimationBackgroundColor = UIColor(patternImage: UIImage(named: "stars")!)


        
     
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
        
        APIDataHelper.fetchComic(comicNum: 0)  { (comic, error) in
            
            if let error = error {
                self.displayAlert(error: error)
            } else {
                
                self.totalComicNum = comic.comicNum
                self.setViews(comic:comic)
            }
        }
    }
    
    @IBAction func lastAction(_ sender: UIButton) {
        APIDataHelper.fetchComic(comicNum: 0) { (comic, error) in
            if let error = error {
                self.displayAlert(error: error)
            } else {
                self.totalComicNum = comic.comicNum
                self.setViews(comic:comic)
            }
        }
    }
    
    @IBAction func RandomAction(_ sender: UIButton) {
        //get random number
        let randomComicNum = ComicHelper.randomNumber(inRange: 1...self.totalComicNum)
        FetchComic(comicID: randomComicNum)
    }
    
    
    @IBAction func NextAction(_ sender: UIButton) {
        
        if currentComicNum != totalComicNum {
            FetchComic(comicID: currentComicNum + 1)
        }
    }
    
    
    @IBAction func PrevAction(_ sender: UIButton) {
        
        if currentComicNum != 1 {
            FetchComic(comicID: currentComicNum - 1)
        }
    }
    
    @IBAction func firstAction(_ sender: UIButton) {
        FetchComic(comicID: 1)
    }
    
   
    
    func FetchComic(comicID: Int){
        APIDataHelper.fetchComic(comicNum: comicID) { (comic, error) in
            if let error = error {
                self.displayAlert(error: error)
            } else {
                self.setViews(comic:comic)
            }
        }
    }
    
    
    func displayAlert(error: Error){
        
        let alert = UIAlertController(title: "Error retrieving comic", message: "\(error)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            print("OK")
        })
        
        self.present(alert, animated: true)
    }
    
    func setViews(comic:ComicModel){
        
        self.spinner.center = (self.imageScrollView.center)
        self.spinner.color = UIColor.black
        self.spinner.startAnimating()
        self.spinner.hidesWhenStopped = true
        self.comicObject = comic
        
        APIDataHelper.fetchImage(comic: comic) { (image) in
            
            self.imageScrollView.display(image: image)
            self.comicObject.image = image
            self.spinner.stopAnimating()
        }
        self.currentComicNum = comic.comicNum
        self.titleLabel.text = comic.shortTitle
    
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
    
    
    func methodOfReceivedNotification(notification: Notification){
        print("in the NSNotificatin receiver method")
        
        //NotificationCenter.default.removeObserver(self) //removed the observer
        
        let saveComicObject = SaveComicModel()
        saveComicObject.comicLink = self.comicObject.comicLink
        saveComicObject.comicNum = self.comicObject.comicNum
        saveComicObject.imgURL = self.comicObject.imgURL
        saveComicObject.title = self.comicObject.shortTitle
        
        
        let myPrimaryKey = saveComicObject.imgURL
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
            // Persist your data easily
            try! realm.write {
                realm.add(saveComicObject)
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
    
    
    func ShowFavoriteComicNotification(notification: Notification){
        if let comic = notification.userInfo?["favorite"] as? SaveComicModel {
                FetchComic(comicID: comic.comicNum)
        }
    }
}
