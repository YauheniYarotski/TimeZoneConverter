//
//  ViewController.swift
//  TimeZoneConverterController
//
//  Created by Yarotsky, Eugene on 11/20/15.
//  Copyright (c) 2015 Yarotsky, Eugene. All rights reserved.
//

import UIKit

@objc class TimeZoneConverterController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var fromDateTF: UITextField!
    @IBOutlet weak var fromTZTF: UITextField!
    @IBOutlet weak var toDateLabel: UILabel!
    @IBOutlet weak var toTZLabel: UILabel!
    @IBOutlet weak var timeIntervalLabel: UILabel!
    
    var datePicker = UIDatePicker()
    var tzPicker = UIPickerView()
    var timer: NSTimer?
    
    let kRefreshInterval = 2.0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: Setup
    
    func setup() {
        setupTimeZonePicker()
        setupDatePicker()
        
        initInitialScreen()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(TimeZoneConverterController.viewTaped(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    
    func viewTaped(tap: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func setupTimeZonePicker() {
        tzPicker.delegate = self
        tzPicker.dataSource = self
        if let index =  NSTimeZone.sorteredTimeZones().indexOf(NSTimeZone(forSecondsFromGMT: 0)) { //init is GMT 0.
            tzPicker.selectRow(index, inComponent: 0, animated: false)
        }
    }
    
    func setupDatePicker() {
        let timeZoneIndex = tzPicker.selectedRowInComponent(0)
        datePicker.timeZone = NSTimeZone.sorteredTimeZones()[timeZoneIndex]
        datePicker.addTarget(self, action: #selector(TimeZoneConverterController.changeInitialDate), forControlEvents: .AllEvents)
    }
    
    func setupTextFields() {
    }
    
    
    
    func initInitialScreen() {
        
        fromDateTF.inputView = datePicker
        fromTZTF.inputView = tzPicker
        
        configAppNotifications()
        
        changeInitialDate()
        
        toTZLabel.text = NSTimeZone.localTimeZone().abbreviation
        
        toDateLabel.text = NSString.localizedStringFromDate(NSDate())
        
        fromTZTF.text = NSTimeZone.sorteredTimeZones()[tzPicker.selectedRowInComponent(0)].abbreviation
        
    }
    
    //MARK: - UIPickerViewDataSource
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return NSTimeZone.sorteredTimeZones().count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return NSTimeZone.sorteredTimeZones()[row].abbreviation
    }
    
    //MARK: - UIPickerViewDelegate
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedTZ =  NSTimeZone.sorteredTimeZones()[row]
        let tZAbbreviation = selectedTZ.abbreviation ?? ""
        
        
        fromTZTF.text = tZAbbreviation
        
        //update date in datePciker
        if let date = NSTimeZone.date(fromLocalizedString: fromDateTF.text!, andTimeZone: selectedTZ) {
            datePicker.date = date
            datePicker.timeZone = NSTimeZone.sorteredTimeZones()[row]
            
            //update result date lable
            toDateLabel.text = NSTimeZone.localizedString(fromDate: date, andTimeZone: NSTimeZone.localTimeZone())
            updateTimeIntervalToEventLabel()
        }
    }
    
    //MARK: Update UI
    
    func changeInitialDate() {
        fromDateTF.text = NSTimeZone.localizedString(fromDate: datePicker.date, andTimeZone: NSTimeZone.sorteredTimeZones()[tzPicker.selectedRowInComponent(0)])
        toDateLabel.text = NSString.localizedStringFromDate(datePicker.date)
        timeIntervalLabel.text = NSTimeZone.localizedString(fromDate: datePicker.date)
        updateTimeIntervalToEventLabel()
        
    }
    
    func updateTimeIntervalToEventLabel() {
        let calendar = NSCalendar.autoupdatingCurrentCalendar()
        let components = calendar.components([.Day,.Hour, .Minute], fromDate: NSDate(), toDate: datePicker.date, options: .WrapComponents)
        timeIntervalLabel.text = NSTimeZone.timeInterval(fromComponents: components)
    }
    
    func updateMethod(timer: NSTimer) {
        updateTimeIntervalToEventLabel()
    }
    
    //MARK: - Timer
    
    func startTimer() {
        timer = NSTimer.scheduledTimerWithTimeInterval(kRefreshInterval, target: self, selector: #selector(TimeZoneConverterController.nextSecondPassed(_:)), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func nextSecondPassed(timer: NSTimer) {
        updateTimeIntervalToEventLabel()
        
    }
    
    //MARK: - AppNotifications
    
    func configAppNotifications()
    {
        let defaultCenter = NSNotificationCenter.defaultCenter()
        
        defaultCenter.addObserver(self, selector: #selector(appDidBecomeActive(_:)), name: UIApplicationDidBecomeActiveNotification, object: nil)
        
        defaultCenter.addObserver(self, selector: #selector(appWillResignActive(_:)), name:UIApplicationWillResignActiveNotification, object: nil)
        defaultCenter.addObserver(self, selector: #selector(systemTimeZoneDidChange(_:)), name:NSSystemTimeZoneDidChangeNotification, object: nil)
        defaultCenter.addObserver(self, selector: #selector(currentLocaleDidChange(_:)), name:NSCurrentLocaleDidChangeNotification, object: nil)
        
    }
    
    func appDidBecomeActive(note: NSNotification)
    {
        fromTZTF.becomeFirstResponder()
        startTimer()
    }
    
    func appWillResignActive(note: NSNotification)
    {
        stopTimer()
    }
    
    func systemTimeZoneDidChange(note: NSNotification) {
        
        NSTimeZone.resetSystemTimeZone()
        
        toDateLabel.text = NSString.localizedStringFromDate(datePicker.date)
        toTZLabel.text = NSTimeZone.localTimeZone().localizedName(.Generic, locale: NSLocale.autoupdatingCurrentLocale())
        
    }
    
    func currentLocaleDidChange(note: NSNotification)
    {
        
        fromDateTF.resignFirstResponder()
        fromDateTF.inputView = nil
        setupDatePicker()
        fromDateTF.inputView = datePicker
        fromTZTF.becomeFirstResponder()
        changeInitialDate()
        
    }
    
    //MARK: - tbd
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = event?.allTouches()?.first {
            
            if let _ = touch.view as? UITextField {
                
            } else {
                view.endEditing(true)
            }
            
        }
        
        super.touchesBegan(touches, withEvent: event)
        
    }
    
}

