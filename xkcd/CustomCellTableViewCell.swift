//
//  CustomCellTableViewCell.swift
//  xkcd
//
//  Created by Kevin Cleathero on 2017-09-25.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

import UIKit

class CustomCellTableViewCell: UITableViewCell {

    @IBOutlet var cellComicLabel: UILabel!
    @IBOutlet var customCell: CustomCellTableViewCell!


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
