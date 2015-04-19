//
//  ModuleCellTypes.swift
//  About Cal
//
//  Created by Cal on 4/18/15.
//  Copyright (c) 2015 Cal Stephens. All rights reserved.
//

import UIKit

class ImageCell : ModuleCell {
    
    @IBOutlet weak var image: UIImageView!
    
    override func moduleType() -> ModuleType {
        return .Text
    }
    
    override func displayWithData(data: String) {
        image.image = UIImage(named: data)
    }
    
}