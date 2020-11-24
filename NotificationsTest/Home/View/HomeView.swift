//
//  HomeView.swift
//  NotificationsTest
//
//  Created sopra on 24/11/20.
//  Copyright © 2020 ÁF. All rights reserved.
//

import UIKit

class HomeView: UIViewController {
    var presenter: HomePresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didTapLocalNotificationButton(_: Any) {
        let alertController = UIAlertController(title: "Local Notification", message: nil, preferredStyle: .actionSheet)
        let setLocalNotificationAction = UIAlertAction(title: "Set", style: .default) { _ in
            LocalNotificationManager.setNotification(5, of: .seconds, repeats: false, title: "Hello", body: "local", userInfo: ["aps": ["hello": "world"]])
        }
        let removeLocalNotificationAction = UIAlertAction(title: "Remove", style: .default) { _ in
            LocalNotificationManager.cancel()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        alertController.addAction(setLocalNotificationAction)
        alertController.addAction(removeLocalNotificationAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension HomeView: HomeViewProtocol {}
