//
//  ViewController.swift
//  swf-CustomTransitionHamon-demo
//
//  Created by S.Emoto on 2018/05/28.
//  Copyright © 2018年 S.Emoto. All rights reserved.
//

import UIKit

class SourceViewController: UIViewController, CAAnimationDelegate {
    
    @IBOutlet weak var bubbleButton: UIButton!
    
    private let bubbleTransitionDelegate = BubbleTransitionDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension SourceViewController {
    
    func setup() {
        
        bubbleTransitionDelegate.transitionButton = bubbleButton
    }
    
    @IBAction func didTapHamon(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "DestinationViewController", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DestinationViewController") as! DestinationViewController

        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = bubbleTransitionDelegate

        present(controller, animated: true, completion: nil)
    }
}
