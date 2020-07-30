//
//  AViewController.swift
//  Watercharger
//
//  Created by 平良悠貴 on 2020/07/27.
//  Copyright © 2020 平良悠貴. All rights reserved.
//

import UIKit
import Hero

let viewControllerIDs = ["iphone", "watch", "macbook"]

class AViewController: UIViewController, HeroViewControllerDelegate {
    var panGR: UIPanGestureRecognizer!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        panGR = UIPanGestureRecognizer(target: self, action: #selector(pan))
        view.addGestureRecognizer(panGR)
    }
    
    func applyShrinkModifiers() {
        view.hero.modifiers = nil
        primaryLabel.hero.modifiers = [.translate(x:-50, y:(view.center.y - primaryLabel.center.y)/10), .scale(0.9), HeroModifier.duration(0.3)]
        secondaryLabel.hero.modifiers = [.translate(x:-50, y:(view.center.y - secondaryLabel.center.y)/10), .scale(0.9), HeroModifier.duration(0.3)]
        imageView.hero.modifiers = [.translate(x:-80), .scale(0.9), HeroModifier.duration(0.3)]
    }
    
    func applySlideModifiers() {
        view.hero.modifiers = [.translate(x: view.bounds.width), .duration(0.3), .beginWith(modifiers: [.zPosition(2)])]
        primaryLabel.hero.modifiers = [.translate(x:100), .duration(0.3)]
        secondaryLabel.hero.modifiers = [.translate(x:100), .duration(0.3)]
        imageView.hero.modifiers = nil
    }
    
    enum TransitionState {
        case normal, slidingLeft, slidingRight
    }
    var state: TransitionState = .normal
    weak var nextVC: AViewController?
    
    @objc func pan() {
        let translateX = panGR.translation(in: nil).x
        let velocityX = panGR.velocity(in: nil).x
        switch panGR.state {
        case .began, .changed:
            let nextState: TransitionState
            if state == .normal {
                nextState = velocityX < 0 ? .slidingLeft : .slidingRight
            } else {
                nextState = translateX < 0 ? .slidingLeft : .slidingRight
            }
            
            if nextState != state {
                Hero.shared.cancel(animate: false)
                let currentIndex = viewControllerIDs.index(of: self.title!)!
                let nextIndex = (currentIndex + (nextState == .slidingLeft ? 1 : viewControllerIDs.count - 1)) % viewControllerIDs.count
                nextVC = self.storyboard!.instantiateViewController(withIdentifier: viewControllerIDs[nextIndex]) as? AViewController
                
                if nextState == .slidingLeft {
                    applyShrinkModifiers()
                    nextVC!.applySlideModifiers()
                } else {
                    applySlideModifiers()
                    nextVC!.applyShrinkModifiers()
                }
                state = nextState
                hero.replaceViewController(with: nextVC!)
            } else {
                let progress = abs(translateX / view.bounds.width)
                Hero.shared.update(progress)
                if state == .slidingLeft, let nextVC = nextVC {
                    Hero.shared.apply(modifiers: [.translate(x: view.bounds.width + translateX)], to: nextVC.view)
                } else {
                    Hero.shared.apply(modifiers: [.translate(x: translateX)], to: view)
                }
            }
        default:
            let progress = (translateX + velocityX) / view.bounds.width
            if (progress < 0) == (state == .slidingLeft) && abs(progress) > 0.3 {
                Hero.shared.finish()
            } else {
                Hero.shared.cancel()
            }
            state = .normal
        }
    }
    
    func heroWillStartAnimatingTo(viewController: UIViewController) {
        if !(viewController is AViewController) {
            view.hero.modifiers = [.ignoreSubviewModifiers(recursive: true)]
        }
    }
}
