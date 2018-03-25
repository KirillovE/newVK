//
//  NewsVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 25.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

class NewsVC: UITableViewController {

    // MARK: - Demo data
    
    struct News {
        let avatar: UIImage
        let name, text: String
        let views, reposts, comments, likes: Int
    }
    
    let blockTelegram = News(avatar: #imageLiteral(resourceName: "цитаты"),
                             name: "IT новости",
                             text: "Роскомнадзор обязал Telegram в течение 15 дней передать ключи для шифрования переписок. Если требование не будет исполнено, ведомство может начать блокировку мессенджера на территории РФ",
                             views: 500,
                             reposts: 10,
                             comments: 333,
                             likes: 0)
    let answerOfTelegram = News(avatar: #imageLiteral(resourceName: "цитаты"),
                                name: "IT новости",
                                text: "Telegram оспорил в ЕСПЧ штраф за отказ раскрыть ФСБ ключи шифрования. Компания Telegram Messenger направила в Европейский суд по правам человека (ЕСПЧ) жалобу на решение Мещанского суда, оштрафовавшего ее на 800 000 руб. за отказ предоставить ФСБ ключи шифрования сообщений пользователей",
                                views: 670,
                                reposts: 15,
                                comments: 572,
                                likes: 1_000)
    var newsFeed = [News]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsFeed = [blockTelegram, answerOfTelegram]
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsFeed.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsCell

        cell.configure(for: newsFeed[indexPath.row])

        return cell
    }

}
