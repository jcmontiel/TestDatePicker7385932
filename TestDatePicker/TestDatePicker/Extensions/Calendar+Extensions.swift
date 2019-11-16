//
//  Calendar+Extensions.swift
//  TestDatePicker
//
//  Created by John C Montiel on 11/15/19.
//  Copyright © 2019 Montiel Mobile, LLC. All rights reserved.
//

import Foundation

extension NSCalendar
{
    
    private static var currentCalendarIdentifier = NSCalendar.current.identifier
        
    @objc public static func initializeCalendar()
    {
        currentCalendarIdentifier = Calendar.current.identifier
        swizzle(selector: #selector(getter: NSCalendar.current), with: #selector(getter: NSCalendar.appCalendar))
    }
    
    
    @objc class var appCalendar: Calendar
    {
        var calendar = Calendar(identifier: currentCalendarIdentifier)
        calendar.locale = NSLocale.current
        return calendar
    }
    
    private static func swizzle(selector: Selector, with replacement: Selector)
    {
        guard let originalMethod = class_getClassMethod(self, selector),
            let swizzledMethod = class_getClassMethod(self, replacement) else { return }
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}
