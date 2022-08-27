//
//  TableViewItemCell.swift
//  HomeWork24 (shio andghuladze)
//
//  Created by shio andghuladze on 23.08.22.
//

import UIKit

class TableViewItemCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    var deleteAction: ()-> Void = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(name: String){
        nameLabel.text = name
    }
    
    @IBAction func onDelete(_ sender: Any) {
        deleteAction()
    }
}
