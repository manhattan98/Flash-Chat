//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayTitleAnimatedCurrentText(timeInterval: 0.1)
    }
    
    func displayTitleAnimatedCurrentText(timeInterval: Double) {
        displayTitleAnimated(text: titleLabel.text!, timeInterval: timeInterval)
    }
    
    func displayTitleAnimated(text: String, timeInterval: Double) {
        var interval = timeInterval
        text.forEach { (char) in Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { _ in self.titleLabel.text?.append(char) }
            interval += timeInterval }
        titleLabel.text = ""
    }
    

}
