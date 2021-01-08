//
//  ViewController.swift
//  LocalNotifications
//
//  Created by Tal talspektor on 08/01/2021.
//
import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "register",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(rgisterLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(scheduleLocal))
    }

    @objc func rgisterLocal() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay!")
            } else {
                print("D'oh!")
            }
        }
    }
    
    @objc func scheduleLocal() {
        registerCateguries()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Late wakw up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizbuzz"]
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5,
                                                        repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: trigger)
        center.add(request)
    }
    
    func registerCateguries() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show",
                                        title: "Tell me more...",
                                        options: .foreground)
        let categury = UNNotificationCategory(identifier: "alarm",
                                              actions: [show],
                                              intentIdentifiers: [],
                                              options: [])
        
        center.setNotificationCategories([categury])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data recived: \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // the user swiped to unloch
                print("Default identifier")
            case "show":
                print("Swow more information...")
            default:
                break
            }
        }
        
        completionHandler()
    }
}

