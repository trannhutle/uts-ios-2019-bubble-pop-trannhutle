//
//  ShowRankingViewController.swift
//  Bubble-Pop
//
//  Created by Tran Nhut Minh An Le on 3/5/19.
//  Copyright © 2019 Tran Nhut Minh An Le. All rights reserved.
//

import UIKit

class ShowRankingViewController: UITableViewController {
    
    var ranking: Ranking = Ranking()
    var standingList: [Score] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.standingList = self.ranking.getUserScoringListDesc()
    }
    // MARK: - Table view data source
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // There isjust one row in every section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.standingList.count
    }
    
    // Set the spacing between sections
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AppConfig.tableViewRowSpacing
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell
        
        if indexPath.row == 0{
            cell = tableView.dequeueReusableCell(withIdentifier: AppConfig.firstCell, for: indexPath)
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: AppConfig.normalCell, for: indexPath)
        }
        
        if Utils.isEven(number: indexPath.row){
            cell.backgroundColor = UIColor.BubbleColor.white
        }
        let rowNumber = indexPath.row + 1
        cell.textLabel?.text = "\(rowNumber). \(self.standingList[indexPath.row].name)"
        cell.detailTextLabel?.text = String(self.standingList[indexPath.row].score)
        
        return cell
    }
   

}
