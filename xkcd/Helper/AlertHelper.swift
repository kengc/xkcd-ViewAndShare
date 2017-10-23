//
//  AlertHelper.swift
//  xkcd
//
//  Created by Kevin Cleathero on 2017-10-23.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

import UIKit
import Foundation

public class AlertHelper : UIAlertController {
    
        func displayAlert(fromController controller: UIViewController, error: Error){
    
            let alert = UIAlertController(title: "Error retrieving comic", message: "\(error.localizedDescription)", preferredStyle: .alert)
    
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                print("OK")
            })
            
            controller.present(alert, animated: true, completion: nil)

        }
    
    
    func displayNoSaveAlert(fromController controller: UIViewController, error: Error){
        
        let alert = UIAlertController(title: "Did Not Save", message: "\(error.localizedDescription)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            print("OK")
        })
        
        controller.present(alert, animated: true, completion: nil)
        
    }
}
