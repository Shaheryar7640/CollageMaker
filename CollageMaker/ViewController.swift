//
//  ViewController.swift
//  CollageMaker
//
//  Created by Shaheryar Malik on 29/07/2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
           
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Create the collage view and add it to the main view
        let collageView = CollageView(frame: CGRect(x: 10, y: 100, width: view.bounds.width - 20, height: view.bounds.width - 20))
               collageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
               view.addSubview(collageView)
   
    }


}

