//
//  ViewController.swift
//  xkcd
//
//  Created by Kevin Cleathero on 2017-08-14.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    var totalComicNum:Int = 0
    var currentComicNum:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getComic()
        //setupScroll()
        
        titleLabel.lineBreakMode = .byWordWrapping;
        titleLabel.numberOfLines = 0;
        
    }
    
//    func setupScroll(){
//        let vWidth = self.view.frame.width
//        let vHeight = self.view.frame.height
//        
//        let scrollImg: UIScrollView = UIScrollView()
//        scrollImg.delegate = self
//        //scrollImg.frame = CGRectMake(0, 0, vWidth, vHeight)
//        scrollImg.frame = CGRect(x: 0, y: 0, width: vWidth, height: vHeight)
//        scrollImg.backgroundColor = UIColor(red: 90, green: 90, blue: 90, alpha: 0.90)
//        scrollImg.alwaysBounceVertical = false
//        scrollImg.alwaysBounceHorizontal = false
//        scrollImg.showsVerticalScrollIndicator = true
//        scrollImg.flashScrollIndicators()
//        
//        scrollImg.minimumZoomScale = 1.0
//        scrollImg.maximumZoomScale = 10.0
//        
//        //defaultView!.addSubview(scrollImg)
//        self.view.addSubview(scrollImg)
//        
//        imageView!.layer.cornerRadius = 11.0
//        imageView!.clipsToBounds = false
//        scrollImg.addSubview(imageView!)
//    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
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
        
        self.spinner.center = (self.imageView.center)
        self.spinner.color = UIColor.black
        self.spinner.startAnimating()
        self.spinner.hidesWhenStopped = true
        
        APIDataHelper.fetchImage(comic: comic) { (image) in
            self.imageView.image = image
            self.spinner.stopAnimating()
        }
        self.currentComicNum = comic.comicNum
        self.titleLabel.text = comic.shortTitle
    }
  
}

