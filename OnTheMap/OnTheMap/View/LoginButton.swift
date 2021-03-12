//
//  LoginButton.swift
//  OnTheMap
//
//  Created by Alexander Brown on 3/9/21.
//

import Foundation
import UIKit

class LoginButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5
        tintColor = UIColor.white
        backgroundColor = UIColor.blue
    }
}
