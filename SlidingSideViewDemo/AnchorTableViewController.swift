//
//  AnchorTableViewController.swift
//  SlidingSideView
//
//  Created by Kacper Raczy on 26.07.2017.
//  Copyright © 2017 Kacper Raczy. All rights reserved.
//

import UIKit

class AnchorTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Choose side"
    }
    
    var anchorDict: [String: SlidingSideViewAnchor] = [
        "Bottom": .bottom,
        "Top": .top,
        "Left": .left,
        "Right":.right
    ]

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return anchorDict.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = Array(anchorDict.keys)[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDemo", sender: indexPath.row)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
        switch identifier {
            case "showDemo":
                if let vc = segue.destination as? DemoViewController {
                    if let index = sender as? Int {
                        vc.slidingDetailAnchor = Array(anchorDict.values)[index]
                        vc.title = Array(anchorDict.keys)[index]
                    }
                }
            default:
                break
            }
        }
    }

}
