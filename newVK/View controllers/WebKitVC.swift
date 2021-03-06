//
//  WebKitVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 03.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import WebKit
import Alamofire
import SwiftKeychainWrapper

class WebKitVC: UIViewController {
    
    // MARK: - Source data
    
    @IBOutlet weak var webView: WKWebView!
    var sessionManager: SessionManager?
    let url = "https://oauth.vk.com/authorize"
    let apiVersion = 5.76
    let clientID = 6356387
    let userDefaults = UserDefaults(suiteName: "group.newVK")
    let scope = "offline, photos, groups, wall, friends, messages"
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showVKloginScreen()
        webView.navigationDelegate = self
    }
    
    private func showVKloginScreen() {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        sessionManager = SessionManager(configuration: config)
        let parameters: Parameters = ["client_id": clientID,
                                      "display": "mobile",
                                      "redirect_uri": "https://oauth.vk.com/blank.html",
                                      "scope": scope,
                                      "response_type": "token",
                                      "v": apiVersion]
        
        sessionManager?.request(url, parameters: parameters).responseJSON {response in
            self.webView.load(response.request!)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let loginScreen = segue.destination as? VKloginVC {
            loginScreen.authorizationFailureLabel.isHidden = false
        }
    }
    
}

// MARK: - Extensions

extension WebKitVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url,
            url.path == "/blank.html",
            let fragment = url.fragment else {
                decisionHandler(.allow)
                return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        if params["access_token"] != nil {
            userDefaults?.set(true, forKey: "isAuthorized")
            userDefaults?.set(params["user_id"], forKey: "user_id")
            userDefaults?.set(apiVersion, forKey: "v")
            userDefaults?.set("https://api.vk.com/method/", forKey: "apiURL")
            let sharedWrapper = KeychainWrapper(serviceName: "sharedGroup", accessGroup: "group.newVK")
            sharedWrapper.set(params["access_token"]!, forKey: "access_token")
            
            let firebase = WorkWithFirebase()
            firebase.saveIndexOfUser(authorizedUser: params["user_id"])
        } else {
            userDefaults?.set(false, forKey: "isAuthorized")
        }
        
        decisionHandler(.allow)
        
        if let isAuthirized = userDefaults?.bool(forKey: "isAuthorized"), isAuthirized {
            performSegue(withIdentifier: "startWork", sender: self)
        } else {
            performSegue(withIdentifier: "showLoginScreen", sender: self)
        }
    }
    
}
