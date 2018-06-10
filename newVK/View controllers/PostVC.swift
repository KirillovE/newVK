//
//  PostVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 13.05.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit
import Firebase

class PostVC: UIViewController {

    // MARK: - Source data
    
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var bannerView: GADBannerView!
    let postRequest = PostMessage()
    let userDefaults = UserDefaults.standard
    
    // MARK: - View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userDefaults.removeObject(forKey: "address")
        userDefaults.removeObject(forKey: "latitude")
        userDefaults.removeObject(forKey: "longitude")
        
        postText.delegate = self
        postText.text = "Введите текст Вашей публикации"
        postText.textColor = .lightGray
        
        bannerView.adUnitID = "ca-app-pub-3560512891299358/2521878916" // моя реклама
//        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716" // тестовая реклама
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.load(GADRequest())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let address = userDefaults.string(forKey: "address") {
            if postText.text == "Введите текст Вашей публикации" {
                postText.text = nil
                postText.textColor = .black
            }
            postText.text.append(contentsOf: "\n\(address)")
        }
    }
    
    // MARK: - Methods
    
    @IBAction func post(_ sender: UIBarButtonItem) {
        postText.resignFirstResponder()
        guard let text = postText.text else { return }
        postWithoutLocation(textToPost: text)
        if let lat = userDefaults.object(forKey: "latitude") as? Double,
            let long = userDefaults.object(forKey: "longitude") as? Double {            
            postWithLocation(textToPost: text, latitude: lat, longitude: long)
        } else {
            postWithoutLocation(textToPost: text)
        }
    }
    
    private func postWithoutLocation(textToPost text: String) {
        postRequest.makeRequest(textToPost: text) { response in
            if response {
                self.showMessage(title: "Успех", text: "Запись опубликована", buttonText: "Хорошо")
                DispatchQueue.main.async { self.postText.text = "" }
            } else {
                self.showMessage(title: "Ошибка", text: "Что-то пошло не так", buttonText: "Ясно")
            }
        }
    }
    
    private func postWithLocation(textToPost text: String, latitude: Double, longitude: Double) {
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

// MARK: - Extensions

extension PostVC {
    
    private func showMessage(title: String, text: String, buttonText: String) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: buttonText, style: .default, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
    
}

extension PostVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Введите текст Вашей публикации"
            textView.textColor = .lightGray
        }
    }
    
}

extension PostVC: GADBannerViewDelegate {
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print(error.localizedDescription)
    }
    
}
