//
//  DetailViewController.swift
//  MovieViewer
//
//  Created by Sagar  on 1/31/16.
//  Copyright © 2016 Sagar . All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIScrollViewDelegate{

    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var trailerLabel: UILabel!
    
    var movie: NSDictionary!
    var ranOnce = false
    var metNegativeCondition  = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        scrollView.delegate = self
       trailerLabel.textColor = UIColor(red: 212/255.0, green: 175/255.0, blue: 55/225.0, alpha: 1.0)
        posterImageView.userInteractionEnabled = true
       let title  = movie["title"] as? String
        titleLabel.text = title
        let overview = movie["overview"] as? String
        overviewLabel.text = overview
        overviewLabel.sizeToFit()
        infoView.frame.size.height = overviewLabel.frame.origin.y + overviewLabel.frame.size.height+25
         scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height:infoView.frame.origin.y + infoView.frame.size.height+35)
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        if let posterPath = movie["poster_path"] as? String
        {
            let imageUrl = NSURL(string: baseUrl + posterPath)
            let imageRequest = NSURLRequest(URL:imageUrl!)
            
            posterImageView.setImageWithURLRequest(
                imageRequest,
                placeholderImage:nil,
                success: { (imageRequest, imageResponse, image) -> Void in
                    
                    // imageResponse will be nil if the image is cached
                    if imageResponse != nil {
                        print("Image was NOT cached, fade in image")
                        self.posterImageView.alpha = 0.0
                        self.posterImageView.image = image
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            self.posterImageView.alpha = 1.0
                        })
                    } else {
                        print("Image was cached so just update the image")
                        self.posterImageView.image = image
                    }
                },
                failure: { (imageRequest, imageResponse, error) -> Void in
                    self.posterImageView.image = nil
            })
            
        }
        else{
            posterImageView.image = nil
        }

        
    }
    
    override func viewDidAppear(animated: Bool) {
        ranOnce = false
        print("yippy")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    func scrollViewDidScroll(scrollView: UIScrollView){
        //print("herro")
        print(scrollView.contentOffset.y)
        if scrollView.contentOffset.y < -70{
            metNegativeCondition = true
        }
        if (scrollView.contentOffset.y < 1 && metNegativeCondition){
            //print("hello00")
            metNegativeCondition = false
            self.performSegueWithIdentifier("trailerSegue", sender: nil)
        }
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let trailerViewController = segue.destinationViewController as! TrailerViewController
        trailerViewController.movieID = movie["id"] as! Int
        print(movie["id"] as! Int)
        
    }
    

}
