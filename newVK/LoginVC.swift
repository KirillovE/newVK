//
//  LoginVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 16.02.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var loginText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - ViewConroller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let hideKeayboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(hideKeayboardGesture)
        
        loginButton.layer.cornerRadius = 5.0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - other methods
    @IBAction func loginPressed(_ sender: UIButton) {
        if loginText.text == "admin" && passwordText.text == "1234" {
            performSegue(withIdentifier: "loginSegue", sender: self)
        } else {
            showErrorAlert()
        }
    }
    
    ///показывает красивое сообщение
    func showErrorAlert() {
        //создадим контроллер
        let alert = UIAlertController(title: "Ошибка", message: "Введены неверные данные", preferredStyle: .alert)
        //создадим кнопку
        let alertAction = UIAlertAction(title: "Ясно", style: .cancel)
        //добавим кнопку
        alert.addAction(alertAction)
        //покажем контроллер
        present(alert, animated: true, completion: nil)
    }
    
    @objc func keyboardShown(notification: NSNotification) {
        let userInfo = notification.userInfo! as NSDictionary
        let height = (userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.height
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, height, 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardHidden() {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }

    
    @objc func hideKeyboard() {
        scrollView.endEditing(true)
    }
}

