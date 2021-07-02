//
//  UIViewControllerExt.swift
//  goalpost-app
//
//  Created by Hector Barrios on 9/4/20.
//  Copyright © 2020 Hector Barrios. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentDetail(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
        
        self.view.window?.layer.add(transition, forKey:kCATransition)
        viewControllerToPresent.modalPresentationStyle = .fullScreen
        
        present(viewControllerToPresent, animated: false, completion: nil)
    }
    
    func presentSecondaryDetail(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
        
        self.view.window?.layer.add(transition, forKey:kCATransition)
        viewControllerToPresent.modalPresentationStyle = .fullScreen
        
        guard let presentedViewController = presentedViewController else { return }
        
        presentedViewController.dismiss(animated: false) {
            self.view.window?.layer.add(transition, forKey: kCATransition)
            self.present(viewControllerToPresent, animated: false, completion: nil)
        }
    }
    
    func dismissDetail() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
        //transition.subtype = CATransitionSubtype.fromLeft
        self.view.window?.layer.add(transition, forKey: kCATransition)
        self.view.backgroundColor = UIColor.white
        dismiss(animated: false, completion: nil)
    }
    
    
}
