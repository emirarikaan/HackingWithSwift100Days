//
//  TableViewCell.swift
//  Day16-18
//
//  Created by Emir Arıkan on 31.01.2023.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var textL: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
