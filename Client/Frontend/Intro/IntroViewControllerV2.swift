//
//  IntroViewControllerV2.swift
//  Client
//
//  Created by Nishant Bhasin on 2020-05-05.
//  Copyright © 2020 Mozilla. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Shared

class IntroViewControllerV2: UIViewController {
    private lazy var welcomeCard: IntroScreenWelcomeView = {
        let welcomeCardView = IntroScreenWelcomeView()
        welcomeCardView.contentMode = .scaleAspectFit
        welcomeCardView.clipsToBounds = true
        return welcomeCardView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialViewSetup()
    }

    func initialViewSetup() {
        // Initialize
        view.addSubview(welcomeCard)
        
        // Constraints
        setupWelcomeCard()
    }
    
    func setupWelcomeCard() {
        welcomeCard.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalToSuperview()
        }
    }

}
