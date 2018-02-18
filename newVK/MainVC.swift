//
//  MainVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 16.02.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    @IBOutlet weak var loginText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if loginText.text == "admin" && passwordText.text == "1234" {
            print("успешная авторизация")
        } else {
            print("неверные данные для входа")
        }
    }
}

