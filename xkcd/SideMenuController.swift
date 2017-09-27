//
//  SideMenuController.swift
//  xkcd
//
//  Created by Kevin Cleathero on 2017-09-26.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

import UIKit

protocol MenuShareDelegate: class {
    func ShareToMedia()
}

class SideMenuController: UITableViewController {

    weak var delegate:MenuShareDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("SideMenu Appearing!")
        
        // this will be non-nil if a blur effect is applied
//        guard tableView.backgroundView == nil else {
//            return
//        }
        
        // Set up a cool background image for demo purposes
//        let imageView = UIImageView(image: UIImage(named: "background"))
//        imageView.contentMode = .scaleAspectFit
//        imageView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
//        tableView.backgroundView = imageView
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            //send out NSNotification to save current comic
            //ViewController2 will receive this notification and save
            //close this menu
            //display saved message or no saved message
            
            NotificationCenter.default.post(name: Notification.Name("SaveComicNotification"), object: nil)
            
            self.dismiss(animated: true, completion: nil)
        
//
//            NotificationCenter.default.post(name: Notification.Name("dismissXib"), object: nil)
//
//            let nc = NotificationCenter.default // Note that default is now a property, not a method call
//
//
//            nc.addObserver(forName:Notification.Name(rawValue:"SaveComicNotification"), object: nil, queue: nil, using: )
////            nc.addObserver(forName:Notification.Name(rawValue:"SaveComicNotification"),
//                           object:nil, queue:nil)
        }
        if indexPath.row == 1 {
            //delegate?.ShareToMedia()
            //this could also be a notification to retrieve
            //in viewcontroller2 it can instantiate an instance of the saved screen
            //saved screen can pass back, via delegation, the comic user wishes to load
            
            performSegue(withIdentifier: "ShowSavedSegue", sender: nil)
        }
    }
  
   
  
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        //let nextViewController = FavoritesScreen
        
        let viewController:
            UIViewController = UIStoryboard(
                name: "Main", bundle: nil
                ).instantiateViewController(withIdentifier: "FavoritesScreen") as UIViewController
        // .instantiatViewControllerWithIdentifier() returns AnyObject!
        // this must be downcast to utilize i
        
        //self.present(viewController, animated: false, completion: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
