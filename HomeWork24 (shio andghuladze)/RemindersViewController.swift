//
//  RemindersViewController.swift
//  HomeWork24 (shio andghuladze)
//
//  Created by shio andghuladze on 23.08.22.
//

import UIKit

class RemindersViewController: UIViewController {
    @IBOutlet weak var remindersTableView: UITableView!
    var reminders: [String] = []
    var dirName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        if let dirName = dirName {
            reminders = FileManager.default.getAllFiles(dir: dirName)
        }
    }
    
    private func resetReminders(){
        if let dirName = dirName {
            reminders = FileManager.default.getAllFiles(dir: dirName)
            remindersTableView.reloadData()
        }
    }
    
    private func setUpTableView(){
        remindersTableView.register(UINib(nibName: "TableViewItemCell", bundle: nil), forCellReuseIdentifier: "TableViewItemCell")
        remindersTableView.delegate = self
        remindersTableView.dataSource = self
    }
    
    @IBAction func createReminder(_ sender: Any) {
        guard let dirName = dirName else {
            return
        }
        
        let ac = UIAlertController(title: "Reminder", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
            let nameTf = ac.textFields![0]
            let textTf = ac.textFields![1]
            nameTf.placeholder = "Name"
            textTf.placeholder = "Text"
            let name = nameTf.text ?? ""
            let text = textTf.text ?? ""
            if !name.isEmpty && !text.isEmpty{
                FileManager.default.createTextFileIn(directoryInsideDocuments: dirName, textFileName: name, text: text)
                ac.dismiss(animated: true)
                self.resetReminders()
            }
        }

        ac.addAction(submitAction)

        present(ac, animated: true)
    }
    
    func presentContentsOfReminder(name: String){
        guard let dirName = dirName else {
            return
        }
        
        if let content = FileManager.default.getFileContent(directoryInsideDocuments: dirName, textFileName: name) {
            let ac = UIAlertController(title: name, message: nil, preferredStyle: .alert)
            ac.addTextField()
            ac.textFields![0].text = content

            let submitAction = UIAlertAction(title: "Save", style: .default) { [unowned ac] _ in
                let answer = ac.textFields![0].text ?? ""
                if !answer.isEmpty{
                    FileManager.default.createTextFileIn(directoryInsideDocuments: dirName, textFileName: name, text: answer)
                    ac.dismiss(animated: true)
                    self.resetReminders()
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

            ac.addAction(submitAction)
            ac.addAction(cancelAction)

            present(ac, animated: true)
        }
    }
    
}

extension RemindersViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewItemCell") as? TableViewItemCell {
            cell.setUp(name: reminders[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentContentsOfReminder(name: reminders[indexPath.row])
    }
    
}
