//
//  MainVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 16.02.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var loginText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - ViewConroller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let hideKeayboardGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardHide))
        scrollView.addGestureRecognizer(hideKeayboardGesture)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - other methods
    @IBAction func loginPressed(_ sender: UIButton) {
        if loginText.text == "admin" && passwordText.text == "1234" {
            performSegue(withIdentifier: "loginSegue", sender: self)
//            showAlert(title: "Успех", message: "Вы авторизованы", buttonTitle: "Ура!")
//            loginText.text?.removeAll()
//            passwordText.text?.removeAll()
        } else {
            showAlert(title: "Ошибка", message: "Введены неверные данные", buttonTitle: "Ясно")
        }
        
        keyboardHide()
    }
    
    ///показывает красивое сообщение
    func showAlert(title: String, message: String, buttonTitle: String) {
        //создадим контроллер
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //создадим кнопку
        let alertAction = UIAlertAction(title: buttonTitle, style: .cancel, handler: nil)
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

    
    @objc func keyboardHide() {
        scrollView.endEditing(true)
    }
}

