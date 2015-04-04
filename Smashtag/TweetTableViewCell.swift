//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by Jordan Burgess on 15/03/2015.
//  Copyright (c) 2015 Jordan Burgess. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetUserNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    
    
    let hashtagColor = UIColor.grayColor()
    let urlColor = UIColor(red: 0.24, green: 0.22, blue: 0.94, alpha: 1.0)
    let userMentionsColor = UIColor(red: 0.99, green: 0.76, blue: 0.23, alpha: 0.99)
    
    func updateUI() {
        
        // Reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        
        // Load new information from the tweet
        if let tweet = self.tweet {
            
            println(tweet.userMentions)
            
            var tweetText = tweet.text
            for _ in tweet.media {
                tweetText += " 🍆"
            }
            var attributedText = NSMutableAttributedString(string: tweetText)
            
            func applyColor(keywords : [Tweet.IndexedKeyword], color : UIColor) {
                for keyword in keywords {
                    attributedText.addAttribute(NSForegroundColorAttributeName, value: color, range: keyword.nsrange)
                }
            }
            
            applyColor(tweet.hashtags, hashtagColor)
            applyColor(tweet.urls, urlColor)
            applyColor(tweet.userMentions, userMentionsColor)
        
            tweetTextLabel?.attributedText = attributedText
            
            tweetUserNameLabel?.text = "\(tweet.user.name)"
            tweetScreenNameLabel?.text = "@\(tweet.user.screenName)"
            
            if let profileImageURL = tweet.user.profileImageURL {
                
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { () -> Void in
                    let imageData = NSData(contentsOfURL: profileImageURL)
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        if imageData != nil {
                            self.tweetProfileImageView?.image = UIImage(data: imageData!)
                        }
                    }
                }
            }
            
            let formatter = NSDateFormatter()
            if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            } else {
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            }
            tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
            
        }
    }
}

