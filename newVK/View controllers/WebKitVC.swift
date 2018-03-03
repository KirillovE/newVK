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

    @IBOutlet weak var webView: WKWebView!
    var sessionManager: SessionManager?
    let url = "https://oauth.vk.com/authorize"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showVKloginScreen()
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
            print(response.value ?? "No answer")
            self.webView.load(response.request!)
        }
    }
    
}
