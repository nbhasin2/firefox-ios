/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import Foundation
import UIKit
import SnapKit
import Shared
import Leanplum

/*
    
 |----------------|
 |              X |
 |                |
 |     Image      |
 |    [Centre]    | (Top View)
 |                |
 |Title Multiline |
 |                |
 |Description     |
 |Multiline       |
 |                |
 |----------------|
 |                |
 |                |
 |    [Button]    | (Bottom View)
 |----------------|
 
 */

class DefaultBrowserOnboardingViewController: UIViewController {
    // Public constants
    let viewModel = ETPViewModel()
    static let theme = BuiltinThemeName(rawValue: ThemeManager.instance.current.name) ?? .normal
    // Private vars
    private var fxTextThemeColour: UIColor {
        // For dark theme we want to show light colours and for light we want to show dark colours
        return DefaultBrowserOnboardingViewController.theme == .dark ? .white : .black
    }
    private var fxBackgroundThemeColour: UIColor {
        return DefaultBrowserOnboardingViewController.theme == .dark ? .black : .white
    }
    private var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "nav-stop")?.withRenderingMode(.alwaysTemplate), for: .normal)
        return button
    }()
    private lazy var topImageView: UIImageView = {
        let imgView = UIImageView(image: viewModel.etpCoverSheetmodel?.titleImage)
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.DefaultBrowserCardTitle
        label.textColor = fxTextThemeColour
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    private lazy var descriptionLabel1: UILabel = {
        let label = UILabel()
        label.text = Strings.DefaultBrowserOnboardingDescriptionStep1
        label.textColor = fxTextThemeColour
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    private lazy var descriptionLabel2: UILabel = {
        let label = UILabel()
        label.text = Strings.DefaultBrowserOnboardingDescriptionStep2
        label.textColor = fxTextThemeColour
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    private lazy var descriptionLabel3: UILabel = {
        let label = UILabel()
        label.text = Strings.DefaultBrowserOnboardingDescriptionStep3
        label.textColor = fxTextThemeColour
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    private lazy var goToSettingsButton: UIButton = {
        let button = UIButton()
        button.setTitle(Strings.CoverSheetETPSettingsButton, for: .normal)
        button.titleLabel?.font = UpdateViewControllerUX.StartBrowsingButton.font
        button.layer.cornerRadius = UpdateViewControllerUX.StartBrowsingButton.cornerRadius
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UpdateViewControllerUX.StartBrowsingButton.colour
        return button
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialViewSetup()
    }
    
    func initialViewSetup() {
        self.view.backgroundColor = fxBackgroundThemeColour
        
        // Initialize
        self.view.addSubview(topImageView)
        self.view.addSubview(closeButton)
        self.view.addSubview(titleLabel)
        self.view.addSubview(descriptionLabel1)
        self.view.addSubview(descriptionLabel2)
        self.view.addSubview(descriptionLabel3)
        self.view.addSubview(goToSettingsButton)
        
        // Constraints
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupView() {
        // Done button target setup
        closeButton.addTarget(self, action: #selector(dismissAnimated), for: .touchUpInside)
        // Done button constraints setup
        // This button is located at top right hence top, right and height
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin).offset(UpdateViewControllerUX.DoneButton.paddingTop)
            make.right.equalToSuperview().inset(UpdateViewControllerUX.DoneButton.paddingRight)
            make.height.equalTo(UpdateViewControllerUX.DoneButton.height)
        }
        // The top imageview constraints setup
        topImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(closeButton.snp.bottom).offset(10)
            make.bottom.equalTo(goToSettingsButton.snp.top).offset(-200)
            make.height.lessThanOrEqualTo(100)
        }
        // Top title label constraints setup
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(descriptionLabel1.snp.top).offset(-5)
            make.left.right.equalToSuperview().inset(20)
        }
        // Description title label constraints setup
        descriptionLabel1.snp.makeConstraints { make in
            make.bottom.equalTo(descriptionLabel2.snp.top).offset(-40)
            make.left.right.equalToSuperview().inset(20)
        }
        // Description title label constraints setup
        descriptionLabel2.snp.makeConstraints { make in
            make.bottom.equalTo(descriptionLabel3.snp.top).offset(-40)
            make.left.right.equalToSuperview().inset(20)
        }
        // Description title label constraints setup
        descriptionLabel3.snp.makeConstraints { make in
            make.bottom.equalTo(goToSettingsButton.snp.top).offset(-40)
            make.left.right.equalToSuperview().inset(20)
        }
        // Bottom start button constraints
        goToSettingsButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(UpdateViewControllerUX.StartBrowsingButton.edgeInset)
            make.bottom.equalTo(startBrowsingButton.snp.top).offset(-16)
            make.height.equalTo(UpdateViewControllerUX.StartBrowsingButton.height)
        }
        // Bottom goto settings button
        goToSettingsButton.addTarget(self, action: #selector(goToSettings), for: .touchUpInside)
    }
    
    // Button Actions
    @objc private func dismissAnimated() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func goToSettings() {
        viewModel.goToSettings?()
    }
}

// UIViewController setup to keep it in portrait mode
extension DefaultBrowserOnboardingViewController {
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        // This actually does the right thing on iPad where the modally
        // presented version happily rotates with the iPad orientation.
        return .portrait
    }
}
