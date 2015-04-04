//
//  ImageTableViewCell.swift
//  Smashtag
//
//  Created by Jordan Burgess on 03/04/2015.
//  Copyright (c) 2015 Jordan Burgess. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mediaImageView: UIImageView!
    
    var imageUrl: NSURL? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        
        // Reset any existing information
        
        // Load new information from the tweet
        if let imageUrl = self.imageUrl {
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { () -> Void in
                let imageData = NSData(contentsOfURL: imageUrl)
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    if imageData != nil {
                        self.mediaImageView?.image = UIImage(data: imageData!)
                    }
                }
            }
        }
    }
}
