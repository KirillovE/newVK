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
        loginButton.layer.cornerRadius = 5
    }

}
