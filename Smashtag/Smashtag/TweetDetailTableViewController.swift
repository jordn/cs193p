//
//  TweetDetailTableViewController.swift
//  Smashtag
//
//  Created by Jordan Burgess on 18/03/2015.
//  Copyright (c) 2015 Jordan Burgess. All rights reserved.
//

import UIKit

class TweetDetailTableViewController: UITableViewController {

    
    private enum TweetSections: Int, Printable {
        case media, urls, hashtags, userMentions
        
        var description: String {
            get {
                switch self {
                case .media:
                    return "Media"
                case .urls:
                    return "Urls"
                case .hashtags:
                    return "Hashtags"
                case .userMentions:
                    return "User Mentions"
                }
            }
        }
    }
    
    var tweet: Tweet? {
        didSet {
            displayTweet()
        }
    }
    
    
    func displayTweet() {
        println("\(tweet)");
    }
    
    // sections: images, urls, hashtags, users
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections if they exist
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if let tweet = self.tweet {
            switch section {
                case 0:
                    return tweet.media.count ?? 0
                case 1:
                    return tweet.urls.count ?? 0
                case 2:
                    return tweet.hashtags.count ?? 0
                case 3:
                    return tweet.userMentions.count ?? 0
                default:
                    return 0
            }
        }
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var text = ""
        
        if let tweet = self.tweet {
            if indexPath.section == 0 {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("image", forIndexPath: indexPath) as UITableViewCell
                if let imageUrl = tweet.media[indexPath.item].url {
                    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { () -> Void in
                        let imageData = NSData(contentsOfURL: imageUrl)
                        dispatch_async(dispatch_get_main_queue()) { () -> Void in
                            if imageData != nil {
                                cell.imageView?.image = UIImage(data: imageData!)
                            }
                        }
                    }
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("text", forIndexPath: indexPath) as UITableViewCell
                switch indexPath.section {
                case 1:
                    text = "\(tweet.urls[indexPath.item].keyword)"
                case 2:
                    text = "\(tweet.hashtags[indexPath.item].keyword)"
                case 3:
                    text = "\(tweet.userMentions[indexPath.item].keyword)"
                default:
                    break
                }
            cell.textLabel?.text = text
            return cell
            }
        }
        var cell = tableView.dequeueReusableCellWithIdentifier("text", forIndexPath: indexPath) as UITableViewCell
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return CGFloat(200)
        } else {
            return UITableViewAutomaticDimension
        }
    }

    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    
        return "\(TweetSections(rawValue: section)!)"
        
//        if let tweet = self.tweet {
//            switch section {
//            case 0:
//                if (tweet.media.count > 0) {
//                    return "Media"
//                }
//            case 1:
//                if (tweet.urls.count > 0) {
//                    return "URLs"
//                }
//            case 2:
//                if (tweet.hashtags.count > 0) {
//                    return "#Hashtags"
//                }
//            case 3:
//                if (tweet.userMentions.count > 0) {
//                    return "User mentions"
//                }
//            default:
//                break
//            }
//        }
//        return nil
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
