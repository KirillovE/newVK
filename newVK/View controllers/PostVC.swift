//
//  PostVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 13.05.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

class PostVC: UIViewController {

    // MARK: - Source data
    
    @IBOutlet weak var postText: UITextView!
    let postRequest = PostMessage()
    let userDefaults = UserDefaults.standard
    
    // MARK: - View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDefaults.removeObject(forKey: "address")
        userDefaults.removeObject(forKey: "latitude")
        userDefaults.removeObject(forKey: "longitude")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let address = userDefaults.string(forKey: "address") {
            postText.text.append(contentsOf: "\n\(address)")
        }
    }
    
    // MARK: - Methods
    
    @IBAction func post(_ sender: UIBarButtonItem) {
        postText.resignFirstResponder()
        guard let text = postText.text else { return }
        postWithoutLocation(textToPost: text)
        if let _ = userDefaults.object(forKey: "latitude"),
            let _ = userDefaults.object(forKey: "longitude") {
            let lat = userDefaults.double(forKey: "latitude")
            let long = userDefaults.double(forKey: "longitude")
            postWithLocation(textToPost: text, latitude: lat, longitude: long)
        } else {
            postWithoutLocation(textToPost: text)
        }
    }
    
    func postWithoutLocation(textToPost text: String) {
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
    
    func postWithLocation(textToPost text: String, latitude: Double, longitude: Double) {
        postRequest.makeRequest(textToPost: text, latitude: latitude, longitude: longitude) { response in
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

// MARK: -

extension PostVC {
    
    func showMessage(title: String, text: String, buttonText: String) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: buttonText, style: .default, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
    
}
