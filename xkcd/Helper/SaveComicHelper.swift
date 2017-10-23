//
//  SaveComicHelper.swift
//  xkcd
//
//  Created by Kevin Cleathero on 2017-10-23.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

import Foundation
import RealmSwift

class SaveComicHelper {
    
    
   class func SaveFavoriteComicNotification(fromController controller: UIViewController, comicObject: ComicModel){
        print("in the NSNotificatin receiver method")
      let alertHelper = AlertHelper()
        //NotificationCenter.default.removeObserver(self) //removed the observer
        
        let saveComicObject = SaveComicModel()
        
        if (comicObject.imgURL.isEmpty){
            
            let userInfo: [AnyHashable : Any] =
                [
                    NSLocalizedDescriptionKey :  NSLocalizedString("Invalid Comic", value: "Invalid Comic", comment: "") ,
                    ]
            let error = NSError(domain: "", code: 401, userInfo: userInfo)
            
            alertHelper.displayNoSaveAlert(fromController: controller, error: error)
        } else
        {
            
            // Get the default Realm
            let realm = try! Realm()
            
            let specificComic = realm.object(ofType: SaveComicModel.self, forPrimaryKey: comicObject.imgURL)
            
            if specificComic != nil {
                //don't add
                
                let userInfo: [AnyHashable : Any] =
                    [
                        NSLocalizedDescriptionKey :  NSLocalizedString("Comic already exists", value: "Comic already exists", comment: "") ,
                        ]
                let error = NSError(domain: "", code: 401, userInfo: userInfo)
                
                alertHelper.displayNoSaveAlert(fromController: controller, error: error)
                
            } else {
                //add our object to the DB
                // Persist data
   
                if SaveImageOffline(saveObject: saveComicObject, comicObject: comicObject){
                    
                    saveComicObject.comicLink = comicObject.comicLink
                    saveComicObject.comicNum = comicObject.comicNum
                    saveComicObject.imgURL = comicObject.imgURL
                    saveComicObject.title = comicObject.shortTitle
                    
                    try! realm.write {
                        //call to save image?
                        realm.add(saveComicObject)
                    }
                }
            }
        }
    }
    
   class func SaveImageOffline(saveObject :SaveComicModel, comicObject: ComicModel) -> Bool {
        //save image file to documents directory
        //save link as part of object
        
        let fileManager = FileManager.default
        do {
            let documentsDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let imageName = UUID().uuidString + ".jpg"
            
            let fileURL = documentsDirectory.appendingPathComponent(imageName)
            print(fileURL)
            
            if let imageData = UIImageJPEGRepresentation(comicObject.image, 0.5) {
                try imageData.write(to: fileURL)
                saveObject.imgName = imageName
                return true
            }
        } catch {
            print(error)
        }
        return false
        
    }
    
    class func ShareToMedia(fromController controller: UIViewController, comicObject: ComicModel){
        
        let myWebsite = NSURL(string: comicObject.imgURL)
        
        let shareItems:Array = [myWebsite as Any]
        
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        
        activityViewController.excludedActivityTypes = []
        
        //if iPhone
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone) {
            controller.present(activityViewController, animated: true, completion: nil)
        } else { //if iPad
            // Change Rect to position Popover
            
            let popoverCntlr = UIPopoverController(contentViewController: activityViewController)
            popoverCntlr.present(from: CGRect(x: controller.view.frame.size.width/2, y: controller.view.frame.size.height/4,width: 0,height: 0), in: controller.view, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
            
        }
    }
    
    
    class func ShowFavoriteComicNotification(comicObject: ComicModel, comicSaveObject: SaveComicModel) -> Bool {
        
       // if let comic = notification.userInfo?["favorite"] as? SaveComicModel {
            
            let fileManager = FileManager.default
            
            do {
                let documentsDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
                
                if let _ = comicSaveObject.imgName?.isEmpty, !(comicSaveObject.imgName?.isEmpty)! {
                    
                    let fileURL = documentsDirectory.appendingPathComponent((comicSaveObject.imgName)!)
                    
                    if let image = UIImage(contentsOfFile: (fileURL.path)){
                        
                        comicObject.image = image
                        //self.imageScrollView.display(image: image)
                        comicObject.shortTitle = comicSaveObject.title
                        comicObject.comicNum = comicSaveObject.comicNum
                        comicObject.comicLink = comicSaveObject.comicLink
                        comicObject.imgURL = comicSaveObject.imgURL
                        //self.currentComicNum = comicSaveObject.comicNum
                        //self.titleLabel.text = comicSaveObject.title
                        return true
                        //loadFromDB = true
                    }
                    else {
                        //if not then fetch from api
                        //controller.FetchComic(comicID: comicObject.comicNum)
                        return false
                    }
                } else {
                    //if not then fetch from api
                    //controller.FetchComic(comicID: comicObject.comicNum)
                    return false
                }
            } catch{
                print(error)
            }
        return true
       // }
    }
//    func snapshot(view :ImageScrollView ) -> (UIImage)
//    {
//        
//        UIGraphicsBeginImageContextWithOptions(imageScrollView.bounds.size, true, 0);
//        
//        print("images size is: ", self.comicObject.image.size)
//        
//        imageScrollView.drawHierarchy(in: imageScrollView.bounds, afterScreenUpdates: true)
//        
//        let image :UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//        
//        return image;
//    }
}
