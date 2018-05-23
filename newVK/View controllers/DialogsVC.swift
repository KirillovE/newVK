//
//  DialogsVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 23.05.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

class DialogsVC: UITableViewController {
    
    let dialogsRequest = DialogsRequest()

    override func viewDidLoad() {
        super.viewDidLoad()
        dialogsRequest.makeRequest { dialogs in
            dialogs.forEach { print($0.body) }
        }
    }
    
}
