/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import Foundation
import UIKit
import SnapKit
import Shared

class IntroViewControllerV2: UIViewController {
    private lazy var welcomeCard: IntroScreenWelcomeView = {
        let welcomeCardView = IntroScreenWelcomeView()
        welcomeCardView.contentMode = .scaleAspectFit
        welcomeCardView.clipsToBounds = true
        welcomeCardView.tag = 0
        return welcomeCardView
    }()
    private lazy var syncCard: IntroScreenSyncView = {
        let syncCardView = IntroScreenSyncView()
        syncCardView.contentMode = .scaleAspectFit
        syncCardView.clipsToBounds = true
        syncCardView.tag = 0
        return syncCardView
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
    let tempView = UIView()
    func initialViewSetup() {
        // Initialize
        view.addSubview(syncCard)
        view.addSubview(welcomeCard)
        // Constraints
        setupWelcomeCard()

        welcomeCard.nextClosure = {
            print("Going to next screen")
            self.welcomeCard.isHidden = true
        }
        
        welcomeCard.closeClosure = {
            self.dismiss(animated: true)
        }
        
        syncCard.startBrowsing = {
            self.dismiss(animated: true)
        }
    }
    
    func setupWelcomeCard() {
        welcomeCard.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        syncCard.snp.makeConstraints() { make in
            make.edges.equalToSuperview()
        }
    }
}
