//
//  PlayGameController.swift
//  Bubble-Pop
//
//  Created by Tran Nhut Minh An Le on 8/4/19.
//  Copyright © 2019 Tran Nhut Minh An Le. All rights reserved.
//

import UIKit

class PlayGameController: UIViewController {

    var playerName : String = ""
    
    @IBOutlet weak var playerNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        var gameSettingController = segue.destination as!
//    }
    
    @IBAction func submitPlayerName(_ sender: UIButton) {
        print("The input from user: \(playerNameField.text!)" )
        if playerNameField.text != ""{
            performSegue(withIdentifier: "showGameSettingSegue", sender: self)
        }
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
