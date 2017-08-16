//
//  APIDataHelper.swift
//  xkcd
//
//  Created by Kevin Cleathero on 2017-08-14.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

import UIKit


class APIDataHelper {

    class func fetchComic(comicNum:Int, closure: @escaping (_ comic: ComicModel, _ error: Error?) -> Void ){
        
        //let urlstring = "https://api.forismatic.com/api/1.0/?method=getQuote&lang=en&format=json"
        
        let comicObject = ComicModel()
        
        var urlstring = String()
        
        if comicNum > 0 {
            urlstring = "https://xkcd.com/" + String(comicNum) + "/info.0.json"   //random comic
        }else{
            urlstring = "https://xkcd.com/info.0.json"  //latest comic
        }
        
        //"https://xkcd.com/614/info.0.json"  //specific comic
        
        let url = URL(string: urlstring)!
        
        print(url as Any)
        
        
         let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) -> Void in
            
            
            // convert Data to JSON
            if let jsonUnformatted = try? JSONSerialization.jsonObject(with: data!, options: []) {
                
                
                //value is AnyObject (can be either a dictionary, array, string or a number)
                let json = jsonUnformatted as? [String: AnyObject]

                //  It works perfectly well ! If I understood well OperationQueue is waiting for the request to be done before to perform perform the Sergue
                //  yes ! operation remains in that queue until it is explicitly canceled or finishes executing its task –
                
                OperationQueue.main.addOperation {
                    
                    if let imageURL = json?["img"] as? String {
                        comicObject.imgURL = imageURL
                    }

                    if let comicLink = json?["link"] as? String {
                        comicObject.comicLink = comicLink
                    }
                    
                    if let year = json?["year"] as? String {
                        comicObject.year = year
                    }
                    
                    if let comicNum = json?["num"] as? Int {
                        comicObject.comicNum = comicNum
                    }
                    
                    if let shortTitle = json?["safe_title"] as? String {
                        comicObject.shortTitle = shortTitle
                    }
                    
                    closure(comicObject, nil)
                }
            }
                
            else{
                print("error with response data")
                let co = ComicModel()
                closure(co, error!)
            }
            
        })
        // this is called to start (or restart, if needed) our task
        task.resume()
        
        print ("outside dataTaskWithURL")
        
    }
    
    class func fetchImage(comic:ComicModel, closure: @escaping (_ image: UIImage) -> Void ){
        
        //let urlstring = "https://lorempixel.com/400/200/"
        
        if comic.imgURL.isEmpty {
            let img = UIImage()
            closure(img)
            
        } else {
        
        let urlstring = comic.imgURL //woodpecker.png"
        
        let url = URL(string: urlstring)!
        
        print(url as Any)
        
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) -> Void in
            
            OperationQueue.main.addOperation {
             
                if let imageData = data as NSData? {
                    let image = UIImage(data: imageData as Data)
                    closure(image!)
                }
                
            }
            
        })
        // this is called to start (or restart, if needed) our task
        task.resume()
        
        print ("outside dataTaskWithURL")
        
        }
    } //else
}
