//
//  BaseTableViewController.swift
//  FormKit
//
//  Created by Jacob Sikorski on 2018-08-07.
//  Copyright © 2018 Jacob Sikorski. All rights reserved.
//

import UIKit

open class BaseTableViewController: UITableViewController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        // Setup Table View
        tableView.keyboardDismissMode = .onDrag
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 400
    }
}
