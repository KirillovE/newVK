//
//  WebKitVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 03.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import WebKit
import Alamofire

class WebKitVC: UIViewController {
    // MARK: - Source data
    
    @IBOutlet weak var webView: WKWebView!
    var sessionManager: SessionManager?
    let url = "https://oauth.vk.com/authorize"
    var token: String! = nil
    var user: String! = nil
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showVKloginScreen()
        webView.navigationDelegate = self
    }
    
    func showVKloginScreen() {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        sessionManager = SessionManager(configuration: config)
        let parameters: Parameters = ["client_id": 6356387,
                                      "display": "mobile",
                                      "redirect_uri": "https://oauth.vk.com/blank.html",
                                      "scope": "262150",
                                      "response_type": "token",
                                      "v": 5.73]
        
        sessionManager?.request(url, parameters: parameters).responseJSON {response in
            self.webView.load(response.request!)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showLoginScreen"?:
            if let loginScreen = segue.destination as? VKloginVC {
                loginScreen.authorizationFailureLabel.isHidden = false
            }
        case "startWork"?:
            if let apiMethods = segue.destination as? APImethodsVC {
                apiMethods.accessToken = token
                apiMethods.userID = user
            }
        default:
            break
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
        
        token = params["access_token"]
        user = params["user_id"]
        decisionHandler(.allow)
        
        if token != nil {
            performSegue(withIdentifier: "startWork", sender: self)
        } else {
            performSegue(withIdentifier: "showLoginScreen", sender: self)
        }
    }
}
