//
//  ViewController.swift
//  TestDatePicker
//
//  Created by John C Montiel on 11/15/19.
//  Copyright © 2019 Montiel Mobile, LLC. All rights reserved.
//

// UIDatePicker with a datePickerMode of UIDatePickerModeCountDownTimer does NOT honor the locale set for it's locale property.
// The UI is still presented with the user's language of the device, not as set by the overridden locale for the UIDatePicker.
// https://feedbackassistant.apple.com/feedback/7385932

/*
   UIDatePicker with a datePickerMode of UIDatePickerModeCountDownTimer does NOT honor the locale set for it's locale property or when swizzling - the locale returned by NSLocale's currentLocale and NSCalender's currentCalender locale property.

   The UI is still presented with the user's language as set on the device, not as set by the overridden locale for the UIDatePicker.
*/

import UIKit

fileprivate extension String
{
    struct Localized
    {
        static var helloWorld: String { return NSLocalizedString("Hello World", comment: "Hello World") }
    }
}

class ViewController: UIViewController {
    
    // For testing PAT-1178
    
    let kLang = "lang"
    let kIdentifier = "id"
    lazy var languages: [[String:String]] = [
        [kLang:"English",kIdentifier:"en_US"],
        [kLang:"Spanish",kIdentifier:"es_US"],
        [kLang:"Bulgarian",kIdentifier:"bg_BG"],
    ]

    @IBOutlet weak var hello: UILabel!
    @IBOutlet weak var languagePicker: UIPickerView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var modeButton: UIButton!
    
    var datePicker: UIDatePicker = UIDatePicker()
    var pickerMode: UIDatePicker.Mode = .countDownTimer

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(localeChanged), name: NSLocale.currentLocaleDidChangeNotification, object: nil)
        
        localeChanged()
    }
        
    @objc func localeChanged() {
        
        configureUI()
        populateUI()
    }
    
    func configureUI() {
        
        // Allocating a new picker every time to isolate from prior initializations for testing purposes
        
        datePicker.removeFromSuperview()
        self.datePicker = UIDatePicker()
        datePicker.datePickerMode = pickerMode
        datePicker.calendar = NSCalendar.current
        datePicker.locale = NSLocale.current
        datePicker.frame = container.bounds
        container.addSubview(datePicker)
        
        if pickerMode == .countDownTimer {
            modeButton.setTitle("Count Down Mode", for: .normal)
        }
        else {
            modeButton.setTitle("Date & Time Mode", for: .normal)
        }
    }
    
    func populateUI() {
        
        hello.text = String.Localized.helloWorld
    }
    
    @IBAction func modeTapped(_ sender: Any) {
        
        if pickerMode == .countDownTimer {
            pickerMode = .dateAndTime
        }
        else {
            pickerMode = .countDownTimer
        }
        configureUI()
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        guard let localeId = languages[row][kIdentifier] else { return }
        
        let locale = Locale(identifier: localeId)
        NSLocale.setLocale(locale as NSLocale)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let language = languages[row][kLang] else { return "ERROR" }
        return language
    }
}
