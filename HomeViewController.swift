//
//  HomeViewController.swift
//  TBFS
//
//  Created by Kimberly Seltzer on 9/21/16.
//  Copyright © 2016 The Best Friends Show. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var mostRecentGifImageView: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.clipsToBounds = true
        startButton.layer.cornerRadius = 5
        navigationController?.setNavigationBarHidden(true, animated: false)
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
