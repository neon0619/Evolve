//
//  CookingInstructionViewController.swift
//  EVOLVE
//
//  Created by iOS Developer on 24/03/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import UIKit

class CookingInstructionViewController: BaseViewController, TopBarDelegate {
    
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Variables
    var instructions = [String]()
    
    //MARK:- Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let container = self.mainContainer {
            container.delegate = self
            container.setBackButton()
            container.setTitle(NavigationTitles.Instructions)
        }
        tableView.reloadData()
    }
    
    func actionBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension CookingInstructionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.instructions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CookingInstructionTableViewCell.reuseIdentifier, for: indexPath) as! CookingInstructionTableViewCell
        
        cell.lblStepNumber.text = "Step \(indexPath.row + 1)"
        cell.lblInstruction.text = self.instructions[indexPath.row].trim()
        
        if indexPath.row == self.instructions.count - 1 {
            cell.lblBottomLine.isHidden = true
        }else {
            cell.lblBottomLine.isHidden = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
