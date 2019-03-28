//
//  ViewController.swift
//  Instafilter
//
//  Created by Michele Galvagno on 28/03/2019.
//  Copyright © 2019 Michele Galvagno. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Outlets and Properties
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var intensity: UISlider!
    
    // MARK: Views management
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: Actions
    @IBAction func changeFilter(_ sender: Any) {
    }
    
    @IBAction func save(_ sender: Any) {
    }
    
    @IBAction func intensityChanged(_ sender: Any) {
    }
}

