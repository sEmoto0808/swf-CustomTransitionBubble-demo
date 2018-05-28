//
//  DestinationViewController.swift
//  swf-CustomTransitionHamon-demo
//
//  Created by S.Emoto on 2018/05/28.
//  Copyright © 2018年 S.Emoto. All rights reserved.
//

import UIKit

class DestinationViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    private let bubbleTransitionDelegate = BubbleTransitionDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
}

extension DestinationViewController {
    
    func setup() {
    }
    
    @IBAction func didTapBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

