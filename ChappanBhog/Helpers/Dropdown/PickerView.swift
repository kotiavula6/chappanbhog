//
//  PickerView.swift
//
//  Created by Vakul Saini.
//  Copyright © 2019 enAct eServices. All rights reserved.
//

import UIKit

protocol PickerViewDelegate {
    func pickerDidSelectOption(_ option: String, picker: PickerView)
    func pickerDidSelectDate(_ date: Date, picker: PickerView)
}

enum PickerViewType {
    case Picker
    case DatePicker
    case DateTimePicker
    case TimePicker
}


class PickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var delegate: PickerViewDelegate?
    
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var options: [String] = [] {
        didSet {
            picker.reloadAllComponents()
        }
    }
    
    var type: PickerViewType = .Picker {
        didSet {
            if type == .Picker {
                datePicker.isHidden = true
                picker.isHidden = false
            }
            else {
                datePicker.isHidden = false
                picker.isHidden = true
                if type == .DatePicker {
                    datePicker.datePickerMode = .date
                }
                else if type == .DateTimePicker {
                    datePicker.datePickerMode = .dateAndTime
                }
                else {
                    datePicker.datePickerMode = .time
                }
            }
        }
    }
    
    fileprivate let overlay: UIView = UIView()
    
    static let shared = PickerView.view()
    static fileprivate func view() -> PickerView {
        let outlets = Bundle.main.loadNibNamed("PickerView", owner: self, options: nil)
        var obj: PickerView?
        for outlet in outlets ?? [] {
            if let out = outlet as? PickerView {
                obj = out
                obj?.picker.delegate = obj
                obj?.datePicker.datePickerMode = UIDatePicker.Mode.date
                obj?.datePicker.addTarget(obj, action: #selector(dateDidChange(_ :)), for: UIControl.Event.valueChanged)
                obj?.overlay.backgroundColor = UIColor.black.withAlphaComponent(0.4)
                break
            }
        }
        return obj!
    }
    
    func show() {
        if let window = UIApplication.shared.keyWindow {
            showIn(view: window)
        }
    }
    
    func showIn(view: UIView) {
        
        var rect = self.frame
        rect.size.width = view.frame.size.width
        rect.origin.y = view.frame.size.height
        
        DispatchQueue.main.async {
            self.frame = rect
            rect.origin.y -= self.frame.size.height
            
            self.overlay.alpha = 0.0
            self.overlay.frame = view.bounds
            view.addSubview(self.overlay)
            view.addSubview(self)
            
            UIView.animate(withDuration: 0.3) {
                self.overlay.alpha = 1.0
                self.frame = rect
            }
        }
    }
    
    func hide() {
        
        self.tag = 0
        self.type = .Picker
        
        DispatchQueue.main.async {
            var rect = self.frame
            rect.origin.y += self.frame.size.height
            
            UIView.animate(withDuration: 0.2, animations: {
                self.overlay.alpha = 0.0
                self.frame = rect
            }) { (finished) in
                self.removeFromSuperview()
                self.overlay.removeFromSuperview()
            }
        }
    }
    
    // MARK:- Actions
    @IBAction func doneAction(_ sender: UIButton) {
        if type == .DatePicker || type == .DateTimePicker || type == .TimePicker {
            self.delegate?.pickerDidSelectDate(datePicker.date, picker: self)
        }
        else if type == .Picker {
            let row = picker.selectedRow(inComponent: 0)
            if options.count > row {
                let option = options[row]
                self.delegate?.pickerDidSelectOption(option, picker: self)
            }
        }
        self.hide()
    }
    
    // MARK:- Methods
    @objc func dateDidChange(_ datePicker: UIDatePicker) {
        
    }
    
    // MARK:- Picker Delegates & DataSources
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // let option = options[row]
        // self.delegate?.pickerDidSelectOption(option, picker: self)
    }
}
