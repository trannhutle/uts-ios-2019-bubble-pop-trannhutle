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
        self.standingList = self.ranking.getUserScoringList()
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.standingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        cell.textLabel?.text = self.standingList[indexPath.row].name
        cell.detailTextLabel?.text = String(self.standingList[indexPath.row].score)
        
        return cell
    }
    

}
