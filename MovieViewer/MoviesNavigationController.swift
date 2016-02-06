//
//  MoviesNavigationController.swift
//  MovieViewer
//
//  Created by Sagar  on 2/5/16.
//  Copyright © 2016 Sagar . All rights reserved.
//

import UIKit

class MoviesNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 212/255.0, green: 175/255.0, blue: 55/225.0, alpha: 1.0)]
        
        self.navigationBar.tintColor = UIColor(red: 212/255.0, green: 175/255.0, blue: 55/225.0, alpha: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
