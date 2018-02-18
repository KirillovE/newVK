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
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if loginText.text == "admin" && passwordText.text == "1234" {
            showAlert(title: "Успех", message: "Вы авторизованы", buttonTitle: "Ура!")
        } else {
            showAlert(title: "Ошибка", message: "Введены неверные данные", buttonTitle: "Ясно")
        }
        //очистим поля ввода
        loginText.text?.removeAll()
        passwordText.text?.removeAll()
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //подписываемся на уведомление о грядущих появлении и исчезновении экранной клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //добавим жест скрытия клавиатуры
        let hideKeayboardGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardHide))
        scrollView.addGestureRecognizer(hideKeayboardGesture)
    }
    
    deinit {
        //отписываемся от всех уведомлений
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardHide() {
        scrollView.endEditing(true)
    }
}

