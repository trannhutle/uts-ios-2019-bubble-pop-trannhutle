//
//  GameSettingViewController.swift
//  Bubble-Pop
//
//  Created by Tran Nhut Minh An Le on 28/4/19.
//  Copyright © 2019 Tran Nhut Minh An Le. All rights reserved.
//

import UIKit

class GameSettingViewController: UITableViewController {

    @IBOutlet weak var gameDurationLbl: UILabel!
    @IBOutlet weak var numberOfBubbleLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameDurationLbl.text = "20s"
        numberOfBubbleLbl.text = "5"

        // Do any additional setup after loading the view.
    }
    
    @IBAction func durationSlideChanged(_ sender: UISlider) {
        let sliderValue = lroundf(sender.value)
        gameDurationLbl.text = "\(sliderValue)s"
    }
    
    @IBAction func numberOfBubblesSlideChanged(_ sender: UISlider) {
        let sliderValue = lroundf(sender.value)
        numberOfBubbleLbl.text = "\(sliderValue)"
    }
    
    @IBAction func playGameBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "playGameSegue", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
