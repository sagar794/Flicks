//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by Sagar  on 1/24/16.
//  Copyright © 2016 Sagar . All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
   
    @IBOutlet var tapViewAction: UITapGestureRecognizer!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var networkErrorButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchLabel: UILabel!
    
    var filteredMovies:[NSDictionary]?
    var movies: [NSDictionary]?
    let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    var endpoint = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchLabel.hidden = true
        searchLabel.textColor = UIColor(red: 212/255.0, green: 175/255.0, blue: 55/225.0, alpha: 1.0)
        networkErrorButton.hidden = true;
        searchBar.delegate = self
        searchBar.tintColor = UIColor(red: 212/255.0, green: 175/255.0, blue: 55/225.0, alpha: 1.0)
        collectionView.dataSource = self
        collectionView.delegate = self
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
       let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        collectionView.insertSubview(refreshControl, atIndex: 0)
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
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
                    self.networkErrorButton.hidden = true
                     self.collectionView.center.y = 341-28
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            //print("response: \(responseDictionary)")
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            self.filteredMovies = self.movies
                            self.collectionView.reloadData()
                             MBProgressHUD.hideHUDForView(self.view, animated: true)
                    }
                } else {
                    self.searchBar.userInteractionEnabled = false
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    self.networkErrorButton.hidden = false
                    self.collectionView.center.y = 371-28
                }
        })
        task.resume()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
    
        if let filteredMovies = filteredMovies {
            return filteredMovies.count
        } else {
            return 0
        }
        
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
    
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PosterCell", forIndexPath: indexPath) as! PosterCell
        let movie = filteredMovies![indexPath.row]
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        if let posterPath = movie["poster_path"] as? String {
           let imageUrl = NSURL(string: baseUrl + posterPath)
            let imageRequest = NSURLRequest(URL:imageUrl!)
            cell.posterImage.setImageWithURLRequest(imageRequest,placeholderImage:nil,
                success: { (imageRequest, imageResponse, image) -> Void in
                    // imageResponse will be nil if the image is cached
                    if imageResponse != nil {
                        //print("Image was NOT cached, fade in image")
                        cell.posterImage.alpha = 0.0
                        cell.posterImage.image = image
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            cell.posterImage.alpha = 1.0
                        })
                    } else {
                        //print("Image was cached so just update the image")
                        cell.posterImage.image = image
                    }
                },
                failure: { (imageRequest, imageResponse, error) -> Void in
                    cell.posterImage.image = nil
            })
            
        } else {
            cell.posterImage.image = nil
        }
      
        return cell
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    self.networkErrorButton.hidden = true;
                    self.collectionView.center.y = 341-28
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            //print("response: \(responseDictionary)")
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            self.collectionView.reloadData()
                            refreshControl.endRefreshing()
                    }
                } else {
                    refreshControl.endRefreshing()
                    self.networkErrorButton.hidden = false;
                    self.collectionView.center.y = 371-28
                }
        })
        task.resume()
    }
    
    @IBAction func resolveNetwork(sender: AnyObject) {
        
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
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
                    self.networkErrorButton.hidden = true
                    self.collectionView.center.y = 341-28
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                           // print("response: \(responseDictionary)")
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            self.filteredMovies = self.movies
                            self.collectionView.reloadData()
                            MBProgressHUD.hideHUDForView(self.view, animated: true)
                            self.searchBar.userInteractionEnabled = true
                    }
                } else {
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    self.networkErrorButton.hidden = false;
                    self.collectionView.center.y = 371-28
                }
            })
        task.resume()

    }
    
       func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        if(filteredMovies!.first == nil){
            collectionView.center.y  = 371 - 28
            searchLabel.hidden = false
        } else {
            collectionView.center.y = 341 - 28
            searchLabel.hidden = true
        }

        if searchText.isEmpty {
            collectionView.center.y = 341 - 28
            searchLabel.hidden = true
            filteredMovies = movies
        } else {
            print(filteredMovies!.first)
                        // The user has entered text into the search box
            // Use the filter method to iterate over all items in the data array
            // For each item, return true if the item should be included and false if the
            // item should NOT be included
            filteredMovies = movies!.filter({ (dataItem:NSDictionary) -> Bool in
                // If dataItem matches the searchText, return true to include it
                if ((dataItem["title"] as! String).rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil) {
                    return true
                } else{
                    return false
                }
            })
        }
                collectionView.reloadData()
    }

    
func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
    searchBar.showsCancelButton = true
    
}
    

func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    filteredMovies = movies
    collectionView.reloadData()
    searchBar.showsCancelButton = false
    searchBar.text = ""
    searchBar.resignFirstResponder()
    
}

override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let cell = sender as! UICollectionViewCell
        let indexpath =  collectionView.indexPathForCell(cell)
        let movie = filteredMovies![indexpath!.row]
        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.movie = movie
    }
    
func collectionView(collectionView: UICollectionView , didHighlightItemAtIndexPath indexPath: NSIndexPath){
        let cell  = collectionView.cellForItemAtIndexPath(indexPath) as! PosterCell
        cell.backgroundColor = UIColor(red: 212/255.0, green: 175/255.0, blue: 55/225.0, alpha: 1.0)
        cell.posterImage.alpha = 0.8
    }
func collectionView(collectionView: UICollectionView , didUnhighlightItemAtIndexPath indexPath: NSIndexPath){
        let cell  = collectionView.cellForItemAtIndexPath(indexPath) as! PosterCell
        cell.backgroundColor = UIColor.blackColor()
        cell.posterImage.alpha = 1
        }
  

}   /*end of class brace*/
