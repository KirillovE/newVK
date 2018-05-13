//
//  PostVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 13.05.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

class PostVC: UIViewController {

    @IBOutlet weak var postText: UITextView!
    let postRequest = PostMessage()
    
    @IBAction func post(_ sender: UIBarButtonItem) {
        postText.resignFirstResponder()
        let text = postText.text!
        postRequest.makeRequest(textToPost: text) { response in
            if response {
                self.showMessage(title: "Успех", text: "Запись опубликована", buttonText: "Хорошо")
                DispatchQueue.main.async {
                    self.postText.text = ""
                }
            } else {
                self.showMessage(title: "Ошибка", text: "Что-то пошло не так", buttonText: "Ясно")
            }
        }
    }

}

extension PostVC {
    
    func showMessage(title: String, text: String, buttonText: String) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: buttonText, style: .default, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
    
}
