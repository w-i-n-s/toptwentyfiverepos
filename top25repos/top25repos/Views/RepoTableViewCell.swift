//
//  RepoTableViewCell.swift
//  top25repos
//
//  Created by Sergey Vinogradov on 22.04.2019.
//  Copyright © 2019 RedBite. All rights reserved.
//

import UIKit
//class Repository: String{}

class RepoTableViewCell: UITableViewCell {
    
    static let identifier = "RepoTableViewCell"
    
    @IBOutlet weak private var avatarImageView: UIImageView!
    @IBOutlet weak private var usernameLabel: UILabel!
    @IBOutlet weak private var commitsCountLabel: UILabel!
    
    var repository: Repository! {
        didSet {
            usernameLabel.text = repository.username
            commitsCountLabel.text = "\(repository.commitCount)"
        }
    }
}
