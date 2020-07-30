//
//  pageViewController.swift
//  Watercharger
//
//  Created by 平良悠貴 on 2020/07/28.
//  Copyright © 2020 平良悠貴. All rights reserved.
//

import UIKit

class pageViewController: UIPageViewController,UIPageViewControllerDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setViewControllers([getFirst()], direction: .forward, animated: true, completion: nil)
        self.dataSource = self //追加
    }
    
    func getFirst() -> nvViewController {
        return storyboard!.instantiateViewController(withIdentifier: "NavViewController") as! nvViewController
    }
    func getSecond() -> nv2ViewController {
        return storyboard!.instantiateViewController(withIdentifier: "NavViewController2") as! nv2ViewController
    }
    
    func getThird() -> nv3ViewController {
        return storyboard!.instantiateViewController(withIdentifier: "NavViewController3") as! nv3ViewController
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKind(of: nvViewController.self){
                   // 1 -> 2
                   return getSecond()
               } else if viewController.isKind(of: nv2ViewController.self) {
                   // 2 -> 3
                   return getThird()
               } else {
                   // 3 -> end of the road
                   return nil
               }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
       
        if viewController.isKind(of: nv3ViewController.self){
            // 3 -> 2
            return getSecond()
        }else if viewController.isKind(of: nv2ViewController.self) {
            // 2 -> 1
            return getFirst()
        } else {
            // 1 -> end of the road
            return nil
        }
    }
}
