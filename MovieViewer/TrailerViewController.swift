//
//  TrailerViewController.swift
//  MovieViewer
//
//  Created by Sagar  on 2/4/16.
//  Copyright © 2016 Sagar . All rights reserved.
//

import UIKit
import MBProgressHUD
class TrailerViewController: UIViewController {

    @IBOutlet weak var trailerVideo: UIWebView!
    @IBOutlet weak var exitButton: UIButton!
  
    var movieID = 0
    let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    var endpoint = ""
    var trailerInfo: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
// Do any additional setup after loading the view.
        trailerVideo.hidden = true
        endpoint = String(movieID)
        exitButton.setTitleColor(UIColor(red: 212/255.0, green: 175/255.0, blue: 55/225.0, alpha: 1.0), forState: UIControlState.Normal)
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)/videos?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                             self.trailerInfo = responseDictionary["results"] as? [NSDictionary]
                            print(responseDictionary)
    
                    }
                }
      
        
            if let youtubeURLextention = self.trailerInfo?.first?["key"] as? String {
                print(youtubeURLextention)
                let youtubeURL  = NSURL(string: "https://www.youtube.com/embed/\(youtubeURLextention)")
                let URLrequest = NSURLRequest(URL: youtubeURL!)
                self.trailerVideo.loadRequest(URLrequest)
                if !self.trailerVideo.loading{
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    self.trailerVideo.hidden = false

                }
                }
            else{
                    self.dismissViewControllerAnimated(true, completion: {})
                }
        })
        task.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func exitTrailer(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
