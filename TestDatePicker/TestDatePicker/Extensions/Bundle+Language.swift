//
//  Bundle+Language.swift
//  TestDatePicker
//
//  Created by John C Montiel on 11/15/19.
//  Copyright © 2019 Montiel Mobile, LLC. All rights reserved.
//

import Foundation

import ObjectiveC

private var associatedLanguageBundleKey: Character = "0"

class AssociatedLanguageBundle: Bundle
{
    @objc override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String
    {
        if let bundle = objc_getAssociatedObject(self, &associatedLanguageBundleKey) as? Bundle
        {
            return bundle.localizedString(forKey: key, value: value, table: tableName)
        }
        else
        {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
    }
}

extension Bundle
{
    /// Utility function that will set a locale for all the bundles and frameworks shipped with the app.
    ///
    /// - Parameter locale: Desired locale. If the project isn't localized for the passed in locale the function will return.
    @objc class func setLocale(_ locale: NSLocale)
    {
        Set(Bundle.allBundles + Bundle.allFrameworks).forEach { $0.setLocale(locale) }
    }
    
    /// Overrides the device locale and sets a custom locale for the bundle.
    ///
    /// - Parameter locale: Desired locale. If the project isn't localized for the passed in locale the function will return.
    @objc func setLocale(_ locale: NSLocale)
    {
        // Fix of a region specific locale selection
        // It handles fr_FR -> fr-FR localizations
        let regionSpecificPath = self.path(forResource: locale.localeIdentifier.replacingOccurrences(of: "_", with: "-"), ofType: "lproj")
        let languageSpecificPath = self.path(forResource: locale.languageCode, ofType: "lproj")
        let path = (regionSpecificPath != nil) ? regionSpecificPath : languageSpecificPath
        
        guard let bundlePath = path else {
            return
        }
        
        DispatchQueue.once(token: "com.montiel.module.bundle.language.\(self)") {
            object_setClass(self, AssociatedLanguageBundle.self)
        }
        
        objc_setAssociatedObject(self,
                                 &associatedLanguageBundleKey,
                                 Bundle(path: bundlePath),
                                 .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
