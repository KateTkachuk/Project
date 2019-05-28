//
//  ContactImageView.swift
//  EasyBook
//
//  Created by Maxim Galayko on 3/27/16.
//  Copyright © 2016 Maxim Galayko. All rights reserved.
//

import UIKit

class ContactImageView: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = bounds.size.width / 2
        backgroundColor = UIColor(red: 182.0 / 255.0, green: 182.0 / 255.0, blue: 182.0 / 255.0, alpha: 1)
        clipsToBounds = true
    }

}
