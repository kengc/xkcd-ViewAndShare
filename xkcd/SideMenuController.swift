//
//  SideMenuController.swift
//  xkcd
//
//  Created by Kevin Cleathero on 2017-09-26.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

import UIKit

protocol MenuShareDelegate: class {
    func ShowFavorites()
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

    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: Notification.Name("SaveComicNotification"), object: nil)
        }
        if indexPath.row == 1 {
            self.dismiss(animated: true, completion: nil)
            performSegue(withIdentifier: "ShowSavedSegue", sender: nil)
        }
//        if indexPath.row == 2 {
//           self.dismiss(animated: true, completion: nil)
//            NotificationCenter.default.post(name: Notification.Name("SetComicWallpaperNotification"), object: nil)
//        }
    }
  
   
    override func performSegue(withIdentifier identifier: String, sender: Any?) {        
        let viewController:
            UIViewController = UIStoryboard(
                name: "Main", bundle: nil
                ).instantiateViewController(withIdentifier: "FavoritesScreen") as UIViewController

        self.navigationController?.pushViewController(viewController, animated: true)
    }
 
}
