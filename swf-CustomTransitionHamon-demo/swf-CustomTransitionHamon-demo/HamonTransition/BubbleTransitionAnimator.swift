//
//  ZoomPresentedAnimator.swift
//  swf-CustomTransition-demo
//
//  Created by S.Emoto on 2018/05/26.
//  Copyright © 2018年 S.Emoto. All rights reserved.
//

import UIKit

class BubbleTransitionAnimator: NSObject {
    
    open var startingPoint = CGPoint.zero {
        didSet {
            bubble.center = startingPoint
        }
    }
    
    open var duration = 0.5
    open var transitionMode: BubbleTransitionMode = .present
    open var bubbleColor: UIColor = .white
    open fileprivate(set) var bubble = UIView()
    
    @objc public enum BubbleTransitionMode: Int {
        case present, dismiss, pop
    }
}

extension BubbleTransitionAnimator: UIViewControllerAnimatedTransitioning {
    
    //MARK: - アニメーションの時間
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    //MARK: - アニメーションの実装
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        presentedTransition(transitionContext: transitionContext)
    }
    
    private func presentedTransition(transitionContext: UIViewControllerContextTransitioning) {
        // 遷移元のViewController
        guard let fromVC = transitionContext.viewController(forKey: .from) else { return }
        
        // 遷移先のViewController
        guard let toVC = transitionContext.viewController(forKey: .to) else { return }
        
        // アニメーションの土台となるビュー
        let containerView = transitionContext.containerView
        
        if transitionMode == .present {
            fromVC.beginAppearanceTransition(false, animated: true)
            if toVC.modalPresentationStyle == .custom {
                toVC.beginAppearanceTransition(true, animated: true)
            }
            
            let presentedControllerView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
            let originalCenter = presentedControllerView.center
            let originalSize = presentedControllerView.frame.size
            
            // bubble作成　containerViewに追加
            bubble = UIView()
            bubble.frame = frameForBubble(originalCenter, size: originalSize, start: startingPoint)
            bubble.layer.cornerRadius = bubble.frame.size.height / 2
            bubble.center = startingPoint
            bubble.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            bubble.backgroundColor = bubbleColor
            containerView.addSubview(bubble)
            
            // 遷移先画面のView　containerViewに追加
            presentedControllerView.center = startingPoint
            presentedControllerView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            presentedControllerView.alpha = 0
            containerView.addSubview(presentedControllerView)
            
            UIView.animate(withDuration: duration, animations: {
                
                self.bubble.transform = CGAffineTransform.identity
                presentedControllerView.transform = CGAffineTransform.identity
                presentedControllerView.alpha = 1
                presentedControllerView.center = originalCenter
            }, completion: { (_) in
                
                transitionContext.completeTransition(true)
                self.bubble.isHidden = true
                fromVC.endAppearanceTransition()
                if toVC.modalPresentationStyle == .custom {
                    toVC.endAppearanceTransition()
                }
            })
        } else {
            if fromVC.modalPresentationStyle == .custom {
                fromVC.beginAppearanceTransition(false, animated: true)
            }
            toVC.beginAppearanceTransition(true, animated: true)
            
            // 戻り先画面のView
            let key = (transitionMode == .pop) ? UITransitionContextViewKey.to : UITransitionContextViewKey.from
            let returningControllerView = transitionContext.view(forKey: key)!
            let originalCenter = returningControllerView.center
            let originalSize = returningControllerView.frame.size
            
            // bubble作成
            bubble.frame = frameForBubble(originalCenter, size: originalSize, start: startingPoint)
            bubble.layer.cornerRadius = bubble.frame.size.height / 2
            bubble.center = startingPoint
            bubble.backgroundColor = bubbleColor
            bubble.isHidden = false
            
            UIView.animate(withDuration: duration, animations: {
                self.bubble.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                returningControllerView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                returningControllerView.center = self.startingPoint
                returningControllerView.alpha = 0
                
                if self.transitionMode == .pop {
                    containerView.insertSubview(returningControllerView, belowSubview: returningControllerView)
                    containerView.insertSubview(self.bubble, belowSubview: returningControllerView)
                }
            }, completion: { (_) in
                returningControllerView.center = originalCenter
                returningControllerView.removeFromSuperview()
                self.bubble.removeFromSuperview()
                transitionContext.completeTransition(true)
                
                if fromVC.modalPresentationStyle == .custom {
                    fromVC.endAppearanceTransition()
                }
                toVC.endAppearanceTransition()
            })
        }
    }
}

extension BubbleTransitionAnimator {
    func frameForBubble(_ originalCenter: CGPoint, size originalSize: CGSize, start: CGPoint) -> CGRect {
        let lengthX = fmax(start.x, originalSize.width - start.x)
        let lengthY = fmax(start.y, originalSize.height - start.y)
        let offset = sqrt(lengthX * lengthX + lengthY * lengthY) * 2
        let size = CGSize(width: offset, height: offset)
        
        return CGRect(origin: CGPoint.zero, size: size)
    }
}
