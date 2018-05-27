//
//  FlickrTableViewCell.swift
//  FlickrDeloitte
//
//  Created by Marco Prayer on 26/5/18.
//  Copyright © 2018 Marco Prayer. All rights reserved.
//

import UIKit

class FlickrTableViewCell: UITableViewCell {

    @IBOutlet weak var imgOne: UIImageView!
    
    @IBOutlet weak var titleOne: UILabel!
    @IBOutlet weak var imgTwo: UIImageView!
    @IBOutlet weak var titleTwo: UILabel!

    @IBOutlet weak var imgThree: UIImageView!
    
    @IBOutlet weak var titleThree: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //        renderCell()
    }
}
