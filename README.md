# TestDatePicker7385932

UIDatePicker with a datePickerMode of UIDatePickerModeCountDownTimer does NOT honor the locale set for it's locale property or when swizzling - the locale returned by NSLocale's currentLocale and NSCalender's currentCalender locale property.     The UI is still presented with the user's language as set on the device, not as set by the overridden locale for the UIDatePicker.

Apple Feedback: https://feedbackassistant.apple.com/feedback/7385932
