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
            label.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
            label.textAlignment = .left
            label.numberOfLines = 1
            label.adjustsFontSizeToFitWidth = true
            return label
        }()
        lazy var descriptionLabel: UILabel = {
            let label = UILabel()
            label.text = description
            label.textColor = descriptionColour
            label.font = UIFont.systemFont(ofSize: 19, weight: .regular)
            label.textAlignment = .left
            label.numberOfLines = 2
            label.adjustsFontSizeToFitWidth = true
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

    var topView = UIView()
    var automaticPrivacyView = UIView()
    var fastSearchView = UIView()
    var safeSyncView = UIView()
    var itemStackView = UIStackView()
    var combinedView = UIView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
  
        tempSetup()
    }
    
    private func tempSetup() {
//        topView.backgroundColor = .orange
        topView.addSubview(titleImageView)
        topView.addSubview(titleLabel)
        
//        automaticPrivacyView.backgroundColor = .red
//        fastSearchView.backgroundColor = .purple
//        safeSyncView.backgroundColor = .cyan

        automaticPrivacyView.addSubview(welcomeCardItems[0].titleLabel)
        automaticPrivacyView.addSubview(welcomeCardItems[0].descriptionLabel)
        
        fastSearchView.addSubview(welcomeCardItems[1].titleLabel)
        fastSearchView.addSubview(welcomeCardItems[1].descriptionLabel)
        
        safeSyncView.addSubview(welcomeCardItems[2].titleLabel)
        safeSyncView.addSubview(welcomeCardItems[2].descriptionLabel)
        
        itemStackView.axis = .vertical
        itemStackView.distribution = .fillProportionally
        itemStackView.addArrangedSubview(automaticPrivacyView)
        itemStackView.addArrangedSubview(fastSearchView)
        itemStackView.addArrangedSubview(safeSyncView)
        
//        addSubview(topView)
//        addSubview(itemStackView)
        combinedView.addSubview(topView)
        combinedView.addSubview(itemStackView)
        addSubview(combinedView)

        addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(dismissAnimated), for: .touchUpInside)
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.right.equalToSuperview().inset(10)
        }
        
        addSubview(nextButton)
        nextButton.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        nextButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(safeArea.bottom).inset(10)
            make.height.equalTo(30)
        }
        
        topView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)
        }
//        combinedView.backgroundColor = .lightGray
        combinedView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
            //iphone 5s height devidedby 1.2
            make.height.equalToSuperview().dividedBy(1.2)
        }
        combinedView.sizeToFit()
        
        itemStackView.snp.makeConstraints { make in
            let h = frame.height
            // On large iPhone screens, bump this up from the bottom
//            let offset: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 20 : (h > 800 ? 60 : 20)
            make.left.right.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)
            //iPhone 5s inset equals 0 - can also keep for o
            make.bottom.equalToSuperview()
        }

//        titleImageView.backgroundColor = .yellow
        titleImageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview().offset(-15)
            make.height.equalToSuperview().dividedBy(2)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleImageView.snp.bottom).offset(23)
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
        }

        welcomeCardItems[0].titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview()
        }

        welcomeCardItems[0].descriptionLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(welcomeCardItems[0].titleLabel.snp.bottom).offset(2)
        }

        welcomeCardItems[1].titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview()
        }

        welcomeCardItems[1].descriptionLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(welcomeCardItems[1].titleLabel.snp.bottom).offset(2)
        }

        welcomeCardItems[2].titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview()
        }

        welcomeCardItems[2].descriptionLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(welcomeCardItems[2].titleLabel.snp.bottom).offset(2)
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
