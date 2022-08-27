//
//  Extensions.swift
//  HomeWork24 (shio andghuladze)
//
//  Created by shio andghuladze on 23.08.22.
//

import Foundation
import UIKit

extension FileManager {
    
    func getAllFiles(dir: String? = nil)-> [String]{
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        if let dir = dir {
            let directory = (path as NSString).appendingPathComponent(dir)
            return (try? contentsOfDirectory(atPath: directory).filter{ !$0.isEmpty }) ?? [String]()
        }
        return (try? contentsOfDirectory(atPath: path).filter{ !$0.isEmpty }) ?? [String]()
    }
    
    func createDirectoryInDocuments(name: String){
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let dir = (path as NSString).appendingPathComponent(name)
        try? createDirectory(atPath: dir, withIntermediateDirectories: true, attributes: nil)
    }
    
    func createTextFileIn(directoryInsideDocuments: String, textFileName: String, text: String){
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let dir = (path as NSString).appendingPathComponent(directoryInsideDocuments)
        let file = (dir as NSString).appendingPathComponent(textFileName)
        let data = Data(text.utf8)
        createFile(atPath: file, contents: data, attributes: nil)
    }
    
    func deleteFile(dir: String){
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let file = (path as NSString).appendingPathComponent(dir)
        try? removeItem(atPath: file)
    }
    
    func getFileContent(directoryInsideDocuments: String, textFileName: String)-> String?{
        let path = urls(for: .documentDirectory, in: .userDomainMask).first
        let dir = path?.appendingPathComponent(directoryInsideDocuments)
        let file = dir?.appendingPathComponent(textFileName)
        if let file = file {
            return try? String(contentsOf: file)
        }
        return nil
    }
    
}

extension UIViewController {
    func showAlertWithOkButton(title: String, body: String){
        let dialogMessage = UIAlertController(title: title, message: body, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default){_ in
            dialogMessage.dismiss(animated: true)
        }
        
        dialogMessage.addAction(ok)

        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func requestAndAddNotification(notification: Notification, time: Double, interval: TimeInterval, repeats: Bool){
        let nc = UNUserNotificationCenter.current()
        nc.requestAuthorization(options: [.alert, .badge]) { granted, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if !granted {
                self.showAlertWithOkButton(title: "Alert", body: "The application does not have permission to show notifications. please change from settings.")
            }else {
                let content = UNMutableNotificationContent()
                content.title = notification.title
                content.body = notification.body
                DispatchQueue.main.async {
                    content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
                }
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time * interval.rawValue, repeats: repeats)
                let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
                nc.add(request)
            }
        }
    }
}
