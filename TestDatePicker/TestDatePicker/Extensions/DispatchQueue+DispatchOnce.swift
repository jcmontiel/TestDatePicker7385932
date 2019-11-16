//
//  DispatchQueue+DispatchOnce.swift
//  TestDatePicker
//
//  Created by John C Montiel on 11/15/19.
//  Copyright © 2019 Montiel Mobile, LLC. All rights reserved.

//  Original idea from: https://stackoverflow.com/questions/37886994/dispatch-once-after-the-swift-3-gcd-api-changes
//

import Foundation

public extension DispatchQueue
{
    private static var tokens: [String] = []
    
    /// Replacemant for dispatch_once
    ///
    /// - Parameters:
    ///   - token: Unique token for the execution block. A block will get executed only once per token.
    ///   - block: Closure that will be called if the token wasn't used already.
    class func once(token: String, block:()->())
    {
        objc_sync_enter(self)
        defer
        {
            objc_sync_exit(self)
        }
        
        if tokens.contains(token)
        {
            return
        }
        
        tokens.append(token)
        block()
    }
}
