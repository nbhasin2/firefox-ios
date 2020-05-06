//
//  IntroScreenWelcomeView.swift
//  Client
//
//  Created by Nishant Bhasin on 2020-05-05.
//  Copyright © 2020 Mozilla. All rights reserved.
//

import Foundation
import UIKit
import Shared
import SnapKit

/* The layout for update view controller.
   
|----------------|
|            Done|
|     Image      | (Top View)
|                |
|Title Multiline |
|----------------|
|     Title      |
|   Description  |
|                | (Mid View)
|     Title      |
|   Description  |
|                |
|     Title      |
|   Description  |
|                |
|----------------|
|                |
|                |
|    [Button]    | (Bottom View)
|----------------|

*/

class IntroScreenWelcomeView: UIView {
//    weak var delegate: Any?
    static let theme = BuiltinThemeName(rawValue: ThemeManager.instance.current.name) ?? .normal
    // Private vars
    private var fxTextThemeColour: UIColor {
        // For dark theme we want to show light colours and for light we want to show dark colours
        return UpdateViewController.theme == .dark ? .white : .black
    }
    private var fxBackgroundThemeColour: UIColor {
        return UpdateViewController.theme == .dark ? .black : .white
    }
    private lazy var titleImageView: UIImageView = {
        let imgView = UIImageView(image: #imageLiteral(resourceName: "splash"))
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.CardTitleWelcome
        label.textColor = fxTextThemeColour
        label.font = UIFont.systemFont(ofSize: 26, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.setImage(UIImage(named: "close-large"), for: .normal)
        if #available(iOS 13, *) {
            closeButton.tintColor = .secondaryLabel
        } else {
            closeButton.tintColor = .black
        }
        return closeButton
    }()
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle(Strings.IntroNextButtonTitle, for: .normal)
        button.titleLabel?.font = UpdateViewControllerUX.StartBrowsingButton.font
        button.setTitleColor(UIColor.Photon.Blue50, for: .normal)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    struct WelcomeUICardItem {
        var title:String
        var description:String
        var titleColour: UIColor
        var descriptionColour: UIColor
        lazy var titleLabel: UILabel = {
            let label = UILabel()
            label.text = title
            label.textColor = titleColour
            label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            label.textAlignment = .left
            label.numberOfLines = 0
            return label
        }()
        lazy var descriptionLabel: UILabel = {
            let label = UILabel()
            label.text = description
            label.textColor = descriptionColour
            label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
            label.textAlignment = .left
            label.numberOfLines = 0
            return label
        }()
    }
    
    private lazy var welcomeCardItems: [WelcomeUICardItem] = {
        var cardItems = [WelcomeUICardItem]()
        // Automatic Privacy
        let automaticPrivacy = WelcomeUICardItem(title: Strings.CardTitleAutomaticPrivacy, description: Strings.CardDescriptionAutomaticPrivacy, titleColour: fxTextThemeColour, descriptionColour: fxTextThemeColour)
        cardItems.append(automaticPrivacy)
        // Fast Search
        let fastSearch = WelcomeUICardItem(title: Strings.CardTitleFastSearch, description: Strings.CardDescriptionFastSearch, titleColour: fxTextThemeColour, descriptionColour: fxTextThemeColour)
        cardItems.append(fastSearch)
        // Safe Sync
        let safeSync = WelcomeUICardItem(title: Strings.CardTitleSafeSync, description: Strings.CardDescriptionSafeSync, titleColour: fxTextThemeColour, descriptionColour: fxTextThemeColour)
        cardItems.append(safeSync)
        return cardItems
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        initialViewSetup()
        setupTopView()
        setupMidView()
        setupBottomView()
    }
    
    private func initialViewSetup() {
        backgroundColor = fxBackgroundThemeColour
        
        // Initialize
        addSubview(closeButton)
        addSubview(titleImageView)
        addSubview(titleLabel)
        addSubview(nextButton)
        // Automatic Privacy | Fast Search | Safe Sync - Labels
        for i in 0...2 {
            addSubview(welcomeCardItems[i].titleLabel)
            addSubview(welcomeCardItems[i].descriptionLabel)
        }
    }
    
    func setupTopView() {
        // Done button target setup
        closeButton.addTarget(self, action: #selector(dismissAnimated), for: .touchUpInside)
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.right.equalToSuperview().inset(10)
        }

        titleImageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(snp.topMargin).inset(40)
            make.height.width.equalTo(90)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.top.equalTo(titleImageView.snp.bottom).offset(15)
            make.height.equalTo(40)
        }
    }
    
    func setupMidView() {
        // Automatic Privacy
        welcomeCardItems[0].titleLabel.backgroundColor = UIColor.lightGray
        welcomeCardItems[0].titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(titleLabel.snp.bottom).inset(-10)
            make.height.width.equalTo(24)
        }
        welcomeCardItems[0].descriptionLabel.backgroundColor = UIColor.yellow
        welcomeCardItems[0].descriptionLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(welcomeCardItems[0].titleLabel.snp.bottom).inset(-2)
            make.height.width.equalTo(80)
        }
        
        // Fast Search
        welcomeCardItems[1].titleLabel.backgroundColor = UIColor.lightGray
        welcomeCardItems[1].titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(welcomeCardItems[0].descriptionLabel.snp.bottom).inset(-10)
            make.height.width.equalTo(24)
        }
        welcomeCardItems[1].descriptionLabel.backgroundColor = UIColor.yellow
        welcomeCardItems[1].descriptionLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(welcomeCardItems[1].titleLabel.snp.bottom).inset(-2)
            make.height.width.equalTo(50)
        }
        
        // Safe Sync
        welcomeCardItems[2].titleLabel.backgroundColor = UIColor.lightGray
        welcomeCardItems[2].titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(welcomeCardItems[1].descriptionLabel.snp.bottom).inset(-10)
            make.height.width.equalTo(24)
        }
        welcomeCardItems[2].descriptionLabel.backgroundColor = UIColor.yellow
        welcomeCardItems[2].descriptionLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(welcomeCardItems[2].titleLabel.snp.bottom).inset(-2)
            make.height.width.equalTo(50)
        }
    }
    
    func setupBottomView() {
        // Next button start browsing target setup
        nextButton.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        nextButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(22)
            make.height.equalTo(46)
        }
    }
    
    // Button Actions
    @objc private func dismissAnimated() {
        print("Dismiss Action")
    }
    
    @objc private func nextAction() {
        print("Next Action")
    }
}
