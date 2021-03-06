//
//  SaveComicModel.swift
//  xkcd
//
//  Created by Kevin Cleathero on 2017-09-26.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

import Foundation
import RealmSwift

class SaveComicModel : Object {
    
    //need 'dynamic' keyword in order to read each property, otherwise will always be nil if read
    dynamic var comicID = UUID().uuidString
    dynamic var comicNum:Int = 0 // "num": 614,
    dynamic var comicLink =  String() //"link": "",
    dynamic var title = String() //"title": "Woodpecker",
    dynamic var imgURL = String()
    dynamic var imgName : String?
    
    override static func primaryKey() -> String? {
        return "imgURL"
    }
    
//    func getImageURL() -> URL? {
//        
//       guard let path = self.imgPath else {
//            return nil
//        }
//        return URL(string: path)
//    }
    
}
