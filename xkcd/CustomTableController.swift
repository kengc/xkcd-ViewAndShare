//
//  CustomTableController.swift
//  xkcd
//
//  Created by Kevin Cleathero on 2017-09-25.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

import UIKit
import RealmSwift

class CustomTableController: UITableViewController {
    
    var comicObjects = [SaveComicModel]()
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
      
        PopulateArray()
        
    }

    func PopulateArray(){
        
        comicObjects.removeAll()
        let tempComics = realm.objects(SaveComicModel.self) // retrieves all Dogs from the default Realm
        //print(temp)
        for comic in tempComics{
            comicObjects.append(comic)
        }
        print(comicObjects.count)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.comicObjects.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "comicCell", for: indexPath) as! CustomCellTableViewCell

         //Configure the cell...
        let comicObject = self.comicObjects[indexPath.row]
        print(comicObject)
        print("tit;e: ", comicObject.title)
        cell.cellComicLabel.text = comicObject.title
        
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Did select at: ", indexPath.row)
        
        let comic = comicObjects[indexPath.row]
        let comicDataDict:[String: SaveComicModel] = ["favorite": comic]
    
        //dismiss(animated: true, completion: nil)
   
        self.navigationController?.popViewController(animated: true)
        
        NotificationCenter.default.post(name: Notification.Name("ShowFavoriteComicNotification"), object: nil, userInfo: comicDataDict)
        
  
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            //#1 delete in database
            let removeComic = self.comicObjects[indexPath.row]
            try! realm.write {
                realm.delete(removeComic)
            }
            
            //#2 delete from data array
            self.comicObjects.remove(at: indexPath.row)
            
            //#3 Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
}
