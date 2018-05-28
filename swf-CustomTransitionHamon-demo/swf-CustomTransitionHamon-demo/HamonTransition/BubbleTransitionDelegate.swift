//
//  ZoomModalTransitionDelegate.swift
//  swf-CustomTransition-demo
//
//  Created by S.Emoto on 2018/05/26.
//  Copyright © 2018年 S.Emoto. All rights reserved.
//

import UIKit

class BubbleTransitionDelegate: NSObject {
    
    private let bubbleTransitionAnimator = BubbleTransitionAnimator()
    
    var transitionButton = UIButton()
}

extension BubbleTransitionDelegate: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        bubbleTransitionAnimator.transitionMode = .present
        bubbleTransitionAnimator.startingPoint = transitionButton.center
        bubbleTransitionAnimator.bubbleColor = transitionButton.backgroundColor!

        return bubbleTransitionAnimator
    }

    func animationController(forDismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        bubbleTransitionAnimator.transitionMode = .dismiss
        bubbleTransitionAnimator.startingPoint = (forDismissed as! DestinationViewController).backButton.center
        bubbleTransitionAnimator.bubbleColor = (forDismissed as! DestinationViewController).backButton.backgroundColor!

        return bubbleTransitionAnimator
    }
}
