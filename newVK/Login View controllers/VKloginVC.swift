//
//  VKloginVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 03.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

class VKloginVC: UIViewController {

    @IBOutlet weak var authorizationFailureLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func athorizationFailure(segue: UIStoryboardSegue) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults = UserDefaults.standard
        let isAthorized = userDefaults.bool(forKey: "isAuthorized")
        if isAthorized {
            performSegue(withIdentifier: "quickStart", sender: self)
        }
        
        loginButton.layer.cornerRadius = 5
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        let userDefaults = UserDefaults.standard
        let isAthorized = userDefaults.bool(forKey: "isAuthorized")
        if isAthorized {
            performSegue(withIdentifier: "quickStart", sender: self)
        }
    }
}
