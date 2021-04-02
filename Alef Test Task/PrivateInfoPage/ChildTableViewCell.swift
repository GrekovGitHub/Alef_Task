//
//  ChildTableViewCell.swift
//  Alef Test Task
//
//  Created by Rostislav on 4/1/21.
//

import UIKit

class ChildTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabelValue: UILabel!
    @IBOutlet weak var ageLabelValue: UILabel!
    @IBOutlet weak var deleteChildButton: UIButton!

    var deleteBlock: (() -> Void)? = nil
    
    @IBAction func tapDeleteButton(sender: UIButton) {
        deleteBlock?()
    }
}
