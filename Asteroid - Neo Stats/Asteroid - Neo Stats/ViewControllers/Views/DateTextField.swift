//
//  DateTextField.swift
//  Asteroid - Neo Stats
//
//  Created by Shailendra Kushwaha on 06/02/23.
//

import UIKit

class DateTextField: UITextField {
    
    private lazy var datePicker : UIDatePicker = {
        let picker =  UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        return picker
    }()
    
    private lazy var toolBar : UIToolbar = {
       let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style:.plain, target: self, action: #selector(self.doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelDatePicker))
          toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        return toolbar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextField()
    }
    
    private func setupTextField(){
        borderStyle = .roundedRect
        inputAccessoryView = toolBar
        inputView = datePicker
    }
    
    @objc private func cancelDatePicker(){
        self.resignFirstResponder()
    }
    
    @objc private func doneDatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.text = formatter.string(from: datePicker.date)
        //dismiss date picker dialog
        self.resignFirstResponder()
    }

}
