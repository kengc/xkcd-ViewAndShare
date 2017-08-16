//
//  ViewController2.swift
//  xkcd
//
//  Created by Kevin Cleathero on 2017-08-15.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

import UIKit
import ImageScrollView

class ViewController2: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    @IBOutlet var imageScrollView: ImageScrollView!
    
    var totalComicNum:Int = 0
    var currentComicNum:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getComic()
        
        titleLabel.lineBreakMode = .byWordWrapping;
        titleLabel.numberOfLines = 0;
        spinner.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
    
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
    
    
    @IBAction func RandomAction(_ sender: UIButton) {
        
        //get random number
        let randomComicNum = ComicHelper.randomNumber(inRange: 1...self.totalComicNum)
        
        APIDataHelper.fetchComic(comicNum: randomComicNum) { (comic, error) in
            if let error = error {
                self.displayAlert(error: error)
            } else {
                self.setViews(comic:comic)
            }
        }
    }
    
    
    @IBAction func NextAction(_ sender: UIButton) {
        
        if currentComicNum != totalComicNum {
            
            APIDataHelper.fetchComic(comicNum: currentComicNum + 1) { (comic, error) in
                if let error = error {
                    self.displayAlert(error: error)
                } else {
                    self.setViews(comic:comic)
                }
            }
        }
    }
    
    
    @IBAction func PrevAction(_ sender: UIButton) {
        
        if currentComicNum != 1 {
            
            APIDataHelper.fetchComic(comicNum: currentComicNum - 1) { (comic, error) in
                if let error = error {
                    self.displayAlert(error: error)
                } else {
                    self.setViews(comic:comic)
                }
            }
        }
    }
    
    @IBAction func firstAction(_ sender: UIButton) {
        APIDataHelper.fetchComic(comicNum: 1) { (comic, error) in
            if let error = error {
                self.displayAlert(error: error)
            } else {
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
        
        APIDataHelper.fetchImage(comic: comic) { (image) in
            
            //self.imageView.image = image
            self.imageScrollView.display(image: image)
            self.spinner.stopAnimating()
        }
        self.currentComicNum = comic.comicNum
        self.titleLabel.text = comic.shortTitle
    
    }
    
    
    @IBAction func shareAction(_ sender: Any) {
        print("inside saveACion")
        
        let image = snapshot(view: self.imageScrollView)
        
       // self.XibQuoteViewDelegate.saveQuote(photo: self.photoObject, quote: self.quoteObject, image: image)
        ShareToMedia(image: image)
    }
    
    
    func snapshot(view :ImageScrollView ) -> (UIImage)
    {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0);
        
        //self.drawHierarchy(in: view.bounds, afterScreenUpdates: true)

        imageScrollView.drawHierarchy(in: imageScrollView.bounds, afterScreenUpdates: true)
        
        let image :UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image;
    }

    func ShareToMedia(image: UIImage){
        
        let myWebsite = NSURL(string:"http://www.google.com/")
        
        //let img: UIImage = images[indexPath.row]
        let img: UIImage = image
        
        let shareItems:Array = [img, myWebsite] as [Any]
        
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        
        activityViewController.excludedActivityTypes = []
        
        self.present(activityViewController, animated: true, completion: nil)

    }
    
}
