/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import Foundation
import Leanplum
import Shared

struct LPVariables {
    static var showOnboardingScreen = LPVar.define("showOnboardingScreen", with: true)
}

enum OnboardingScreenType: String {
    case versionV1 // Default
    case versionV2 // New version 2
}

class OnboardingUserResearch {
    // Delegate closure
    var updatedLPVariables: ((LPVar?) -> Void)?
    // variable
    var lpVariable: LPVar?
    // Constants
    let onboardingScreenTypeKey = "onboardingScreenTypeKey"
    // Saving user defaults
    let defaults = UserDefaults.standard
    var onboardingScreenType:OnboardingScreenType? {
        set(value) {
            if value == nil {
                defaults.removeObject(forKey: onboardingScreenTypeKey)
            } else {
                defaults.set(value?.rawValue, forKey: onboardingScreenTypeKey)
            }
        }
        get {
            guard let value = defaults.value(forKey: onboardingScreenTypeKey) else {
                return nil
            }
            return OnboardingScreenType(rawValue: value as! String) ?? nil
        }
    }
    
    // Initializer
    init(lpVariable: LPVar? = LPVariables.showOnboardingScreen) {
        self.lpVariable = lpVariable
    }
    
    func lpVariableObserver() {
        Leanplum.onVariablesChanged {
            self.updatedLPVariables?(self.lpVariable)
        }
    }
    
    func updateValue(value: Bool) {
        // For LP variable below is the convention
        // we are going to follow
        // True = Current Onboarding Screen
        // False = New Onboarding Screen
        onboardingScreenType = value ? .versionV1 : .versionV2
    }
    
    func lpVarient() {
        print("lp variant \(String(describing: Leanplum.variants()))")
        if Leanplum.variants() != nil {
            let lpVariants = Leanplum.variants()?.first
            if let lpData = lpVariants as? Dictionary<String, AnyObject> {
                var abTestId = ""
                if let value = lpData["abTestId"] as? Int64 {
                    abTestId = "\(value)"
                }
                let abTestName = lpData["abTestName"] as? String ?? ""
                let abTestVariant = lpData["name"] as? String ?? ""
                LeanPlumClient.shared.set(attributes:[LPAttributeKey.experimentId: abTestId, LPAttributeKey.experimentName: abTestName, LPAttributeKey.experimentVariant: abTestVariant])
            }
        }
    }
}
