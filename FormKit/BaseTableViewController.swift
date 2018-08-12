//
//  BaseTableViewController.swift
//  FormKit
//
//  Created by Jacob Sikorski on 2018-08-07.
//  Copyright © 2018 Jacob Sikorski. All rights reserved.
//

import UIKit

open class BaseTableViewController: UITableViewController {
    public enum Cell {
        case standard
        case subtitle
        case rightValue
        case input
        case select
        case `switch`
        case date
        case textArea
        case signature
        case custom(reuseIdentifier: String, cellType: UITableViewCell.Type)
        
        public var reuseIdentifier: String {
            switch self {
            case .standard                          : return "com.pineapplepush.FormKit.StandardCell"
            case .subtitle                          : return "com.pineapplepush.FormKit,SubtitleCell"
            case .rightValue                        : return "com.pineapplepush.FormKit.RightValueCell"
            case .input                             : return "com.pineapplepush.FormKit.InputCell"
            case .select                            : return "com.pineapplepush.FormKit.SelectCell"
            case .switch                            : return "com.pineapplepush.FormKit.SwitchCell"
            case .date                              : return "com.pineapplepush.FormKit.DateCell"
            case .textArea                          : return "com.pineapplepush.FormKit.TextAreaCell"
            case .signature                         : return "com.pineapplepush.FormKit.SignatureCell"
            case .custom(let reuseIdentifier, _)    : return reuseIdentifier
            }
        }
        
        public var cellType: UITableViewCell.Type {
            switch self {
            case .standard                  : return UITableViewCell.self
            case .subtitle                  : return UITableViewCell.self
            case .rightValue                : return UITableViewCell.self
            case .input                     : return TextInputTableViewCell.self
            case .select                    : return SingleSelectTableViewCell.self
            case .switch                    : return SwitchTableViewCell.self
            case .date                      : return DateInputTableViewCell.self
            case .textArea                  : return TextAreaTableViewCell.self
            case .signature                 : return SignatureTableViewCell.self
            case .custom(_, let cellType)   : return cellType
            }
        }
        
        public func dequeCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
            switch self {
            case .subtitle:
                return tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ?? UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: reuseIdentifier)
            case .rightValue:
                return tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ?? UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
            default:
                if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) {
                    return cell
                } else {
                    tableView.register(cellType, forCellReuseIdentifier: reuseIdentifier)
                    return tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
                }
            }
        }
    }
    
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
