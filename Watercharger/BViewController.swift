//
//  BViewController.swift
//  Watercharger
//
//  Created by 平良悠貴 on 2020/07/27.
//  Copyright © 2020 平良悠貴. All rights reserved.
//

import UIKit
import Hero

class BViewController: UIViewController {
    @IBOutlet weak var bUpperView: UIView!
    
    @IBOutlet weak var blowerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.bUpperView.hero.id = "upper"
        self.blowerView.hero.id = "lower"
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
