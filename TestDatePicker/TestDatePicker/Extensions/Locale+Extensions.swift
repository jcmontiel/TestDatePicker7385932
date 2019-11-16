//
//  Locale+Extensions.swift
//  TestDatePicker
//
//  Created by John C Montiel on 11/15/19.
//  Copyright © 2019 Montiel Mobile, LLC. All rights reserved.
//

import Foundation

extension NSLocale
{
    
    private static var currentLocaleIdentifier = NSLocale.current.identifier
    private static var originalPreferredLanguages = NSLocale.preferredLanguages
    
    @objc public static func setLocale(_ locale: NSLocale)
    {
        currentLocaleIdentifier = locale.localeIdentifier
        Bundle.setLocale(locale)
        NotificationCenter.default.post(name: NSLocale.currentLocaleDidChangeNotification, object: Locale.current)
    }
    
    @objc public static func initializeLocale()
    {
        currentLocaleIdentifier = Locale.current.identifier
        originalPreferredLanguages = Locale.preferredLanguages
        swizzle(selector: #selector(getter: NSLocale.current), with: #selector(getter: NSLocale.appLocale))
        swizzle(selector: #selector(getter: NSLocale.preferredLanguages), with: #selector(getter: NSLocale.appPreferredLanguages))
        
        NSCalendar.initializeCalendar()
    }
    
    private static func swizzle(selector: Selector, with replacement: Selector)
    {
        guard let originalMethod = class_getClassMethod(self, selector),
            let swizzledMethod = class_getClassMethod(self, replacement) else { return }
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
    @objc class var appLocale: Locale
    {
        return Locale(identifier: currentLocaleIdentifier)
    }
    
    @objc class var appPreferredLanguages: [String]
    {
        var originalLanguages = originalPreferredLanguages
        
        if let languageCode = appLocale.languageCode
        {
            if let firstLanguageCode = originalLanguages.first, languageCode == firstLanguageCode
            {
                return originalLanguages
            }
            
            if originalLanguages.contains(languageCode), let index = originalLanguages.firstIndex(of: languageCode)
            {
                originalLanguages.remove(at: index)
            }
            
            originalLanguages.insert(languageCode, at: 0)
        }
        
        return originalLanguages
    }
    
}
