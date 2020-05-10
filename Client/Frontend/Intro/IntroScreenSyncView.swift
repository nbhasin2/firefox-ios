/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import Foundation
import UIKit
import Shared
import SnapKit

/* The layout for update view controller.

The whole is divided into two parts. Top container view and Bottom view.
Top container view sits above Sign Up button and its height spans all
the way from sign up button to top safe area. We then add [combined view]
that contains Image, Title and Description inside [Top container view]
to make it center in the top container view.
 
|----------------|----------[Top Container View]---------
|                |
|                |----------[Combined View]
|                |
|     Image      | [Top View]
|                |      -- Has title image view
|                |
|                | [Mid View]
|     Title      |      -- Has title
|                |      -- Description
|   Description  |
|                |---------[Combined View]
|                |
|----------------|----------[Top Container View]--------------
|                |  Bottom View
|   [Sign up]    |      -- Bottom View
|                |      -- Start Browsing
| Start Browsing |
|                |
|----------------|

*/

class IntroScreenSyncView: UIView {
    static let theme = BuiltinThemeName(rawValue: ThemeManager.instance.current.name) ?? .normal
    // Private vars
    private var fxTextThemeColour: UIColor {
        // For dark theme we want to show light colours and for light we want to show dark colours
        return UpdateViewController.theme == .dark ? .white : .black
    }
    private var fxBackgroundThemeColour: UIColor {
        return UpdateViewController.theme == .dark ? .black : .white
    }
    
    var signUp: (() -> Void)?
    var startBrowsing: (() -> Void)?
    
    private lazy var titleImageView: UIImageView = {
        let imgView = UIImageView(image: #imageLiteral(resourceName: "tour-Sync"))
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.CardTitleFxASyncDevices
        label.textColor = fxTextThemeColour
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.CardDescriptionFxASyncDevices
        label.textColor = fxTextThemeColour
        label.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private var signUpButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.Photon.Blue50
        button.setTitle(Strings.IntroSignUpButtonTitle, for: .normal)
        return button
    }()
    private lazy var startBrowsingButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .clear
        button.setTitleColor(UIColor.Photon.Blue50, for: .normal)
        button.setTitle(Strings.StartBrowsingButtonTitle, for: .normal)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    // Screen constants
    private let screenHeight = UIScreen.main.bounds.size.height
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialViewSetup()
        topViewSetup()
        stackViewSetup()
        combinedViewSetup()
    }
    
    private func initialViewSetup() {

        let titleLabelHeight = 100
        let descriptionLabelHeight = 100
        let titleImageHeight = screenHeight > 600 ? 300 : 200
        
        let topContainerView = UIView()
        addSubview(topContainerView)
        
        let combinedView = UIView()
        combinedView.addSubview(titleLabel)
        combinedView.addSubview(descriptionLabel)
        combinedView.addSubview(titleImageView)
        
        topContainerView.addSubview(combinedView)
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
//            make.top.equalToSuperview()
            make.top.equalTo(titleImageView.snp.bottom)
            make.height.equalTo(titleLabelHeight)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalTo(titleLabel.snp.bottom)
            make.height.equalTo(descriptionLabelHeight)
        }
//        addSubview(titleLabel)
//        addSubview(descriptionLabel)
        
        addSubview(signUpButton)
        addSubview(startBrowsingButton)
        
        titleImageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
//            make.top.equalToSuperview().offset(40)
//            make.top.equalTo(safeArea.top).offset(40)
            make.height.equalTo(titleImageHeight)
//            make.height.equalToSuperview().dividedBy(2.5)
        }
        
        topContainerView.snp.makeConstraints { make in
//            make.top.equalTo(titleImageView.snp.bottom)
            make.top.equalTo(safeArea.top)
            make.bottom.equalTo(signUpButton.snp.top)
            make.left.right.equalToSuperview()
        }
        
        combinedView.snp.makeConstraints { make in
            make.height.equalTo(titleLabelHeight + descriptionLabelHeight + titleImageHeight)
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        signUpButton.snp.makeConstraints { make in
            make.bottom.equalTo(startBrowsingButton.snp.top).offset(-20)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(46)
            
        }
        
        startBrowsingButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeArea.bottom)
            make.left.right.equalToSuperview().inset(80)
            make.height.equalTo(46)
        }
        
        signUpButton.addTarget(self, action: #selector(signUpAction), for: .touchUpInside)
        startBrowsingButton.addTarget(self, action: #selector(startBrowsingAction), for: .touchUpInside)
    }
    
    private func topViewSetup() {
        // Background colour setup
        backgroundColor = fxBackgroundThemeColour
        
        
        
        
//         Close button target and constraints
//        closeButton.addTarget(self, action: #selector(dismissAnimated), for: .touchUpInside)
//        closeButton.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(30)
//            make.right.equalToSuperview().inset(10)
//        }
//        // Top view constraints
//        topView.snp.makeConstraints { make in
//            make.top.equalToSuperview().inset(-20)
//            make.left.right.equalToSuperview()
//            make.height.equalToSuperview().dividedBy(2.4)
//        }
//        // Title image constraints
//        titleImageView.snp.makeConstraints { make in
//            make.left.right.equalToSuperview()
//            // changing offset for smaller screen Eg. iPhone 5
//            let offsetValue = screenHeight > 570 ? 40 : 10
//            make.top.equalToSuperview().offset(offsetValue)
//            make.height.equalToSuperview().dividedBy(2)
//        }
//        // Title label constraints
//        titleLabel.snp.makeConstraints { make in
//            make.top.equalTo(titleImageView.snp.bottom).offset(23)
//            make.left.right.equalToSuperview()
//            make.height.equalTo(30)
//        }
    }
    
    private func stackViewSetup() {
//        // Item stack view constraints
//        itemStackView.snp.makeConstraints { make in
//            make.left.right.equalToSuperview()
//            make.height.equalTo(320)
//            // changing inset for smaller screen Eg. iPhone 5
//            let insetValue = screenHeight > 570 ? -10 : 4
//            make.top.equalTo(topView.snp.bottom).inset(insetValue)
//        }
//        // Automaitc privacy
//        welcomeCardItems[0].titleLabel.snp.makeConstraints { make in
//            make.left.right.equalToSuperview().inset(20)
//            make.top.equalToSuperview()
//        }
//        welcomeCardItems[0].descriptionLabel.snp.makeConstraints { make in
//            make.left.right.equalToSuperview().inset(20)
//            make.top.equalTo(welcomeCardItems[0].titleLabel.snp.bottom).offset(2)
//        }
//        // Fast Search
//        welcomeCardItems[1].titleLabel.snp.makeConstraints { make in
//            make.left.right.equalToSuperview().inset(20)
//            make.top.equalToSuperview()
//        }
//        welcomeCardItems[1].descriptionLabel.snp.makeConstraints { make in
//            make.left.right.equalToSuperview().inset(20)
//            make.top.equalTo(welcomeCardItems[1].titleLabel.snp.bottom).offset(2)
//        }
//        // Safe Sync
//        welcomeCardItems[2].titleLabel.snp.makeConstraints { make in
//            make.left.right.equalToSuperview().inset(20)
//            make.top.equalToSuperview()
//        }
//        welcomeCardItems[2].descriptionLabel.snp.makeConstraints { make in
//            make.left.right.equalToSuperview().inset(20)
//            make.top.equalTo(welcomeCardItems[2].titleLabel.snp.bottom).offset(2)
//        }
    }
    
    private func combinedViewSetup() {
//        // Combined top view and stack view constraints
//        combinedView.snp.makeConstraints { make in
//            make.left.right.equalToSuperview()
//            make.centerY.equalToSuperview()
//            make.height.equalToSuperview().dividedBy(1.3)
//        }
//        // Next Button bottom action and constraints
//        nextButton.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
//        nextButton.snp.makeConstraints { make in
//            make.left.right.equalToSuperview()
//            make.bottom.equalTo(safeArea.bottom).inset(10)
//            make.height.equalTo(30)
//        }
    }
    
    // Button Actions
    @objc private func signUpAction() {
        print("Sign up")
        signUp?()
    }
    
    @objc private func startBrowsingAction() {
        print("Start Browsing")
        startBrowsing?()
    }
}

