////
////  CountryCodesViewController.swift
////  ChappanBhog
////
////  Created by AAVULA KOTI on 14/09/20.
////  Copyright © 2020 AAvula. All rights reserved.
////
//
//import UIKit
//
//import UIKit
//
///**
//The purpose of the `CountryCodesViewController` is to Displaying Country Names List Along with their Respective Country Code
// 
// /* Here we are displaying countries in Two Sections */
// 
// 1. Popular
// 2. All Countires
// 
//There's a matching scene in the *Main.storyboard* file, and in that scene there is a `UITableView` with `UITableViewCell` design. Go to Interface Builder for details.
//
//The `CountryCodesViewController` class is a subclass of the `UIViewController`, and it conforms to the `UITableViewDataSource`, `UITableViewDelegate`  protocol.
//*/
//
//class CountryCodesViewController: UIViewController {
//
//  
//    @IBOutlet weak var countryCodeTable: UITableView!
//    
//    var keysArray = NSArray()
//    
//    var selectedTF : UITextField!
//    var selectedImageView: UIImageView!
//        
//    // MARK: View Life Cycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//        
//        setUI()
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    func setUI() {
//                
//        self.navigationItem.title = "Country Codes"
//
//        /* Getting section names here */
//        keysArray = searchDictionary.allKeys as AnyObject as! NSArray
//        
//        NSLog(" %@", keysArray)
//        
//    }
//        
//    //MARK: Search based keyword
//    func searchResultsWithKeyword(_ text : String) -> NSMutableDictionary {
//        NSLog(" text is   %@ ", text)
//        
//        let dictionary = NSMutableDictionary()
//        
//        for index in 0 ..< keysArray.count {
//            
//            let sectionDataArray : NSArray = searchDictionary.value(forKey: keysArray.object(at: index) as! String)! as AnyObject as! NSArray
//            
//            let resultPredicate = NSPredicate(format: "name contains[c] %@ OR dial_code contains[c] %@ ", text, text)
//            
//            let  array : NSArray = sectionDataArray.filtered(using: resultPredicate) as NSArray
//            
//            dictionary.setObject(array, forKey: (keysArray.object(at: index) as? String)! as NSCopying)
//        }
//        
//        NSLog(" %@", dictionary)
//        
//        return dictionary
//    }
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
//
//extension CountryCodesViewController : UITextFieldDelegate {
//    
//    /// This is Implementing search Countries Names while Enter Text in Search Field
//    /// - Parameters:
//    ///   - textField: Search Textfiled
//    ///   - range: Getting where Letter is entering
//    ///   - string: Getting what value is entering
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        
//        let TEXT : String = (textField.text! as NSString).replacingCharacters(in: range, with: string)
//        
//        print(TEXT)
//        
//        if  TEXT == "" { searchDictionary = countryDictionary }
//        else { searchDictionary = searchResultsWithKeyword(TEXT) }
//        
//        countryCodeTable.reloadData()
//        
//        return true
//    }
//    
//}
//
//extension CountryCodesViewController : UITableViewDataSource, UITableViewDelegate {
//    
//    /// To display number of rows in each section of table
//    /// - Parameters:
//    ///   - tableView: tableView object that displays Countries list
//    ///   - section: current section index
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        let sectionDataArray : NSArray = searchDictionary.value(forKey: keysArray.object(at: section) as! String)! as AnyObject as! NSArray
//        
//        return sectionDataArray.count
//    }
//    
//    /// To set the values for fields on the each cell of the row
//    /// - Parameters:
//    ///   - tableView: tableView object that displays Countries  list
//    ///   - indexPath: current indexpath object
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let countryCell = tableView.dequeueReusableCell(withIdentifier: "CountryCodeCell", for: indexPath) as! CountryCodeCell
//        
//        countryCell.selectionStyle = .none
//        
//        /// Retreive the data from Countries based on Group wise and display the data in the respected fields
//        let sectionDataArray : NSArray = searchDictionary.value(forKey: keysArray.object(at: indexPath.section) as! String)! as AnyObject as! NSArray
//        
//        countryCell.countryNameLabel.text = (sectionDataArray.object(at: indexPath.row) as AnyObject).value(forKey: "name") as? String
//        countryCell.countryCodeLabel.text = (sectionDataArray.object(at: indexPath.row) as AnyObject).value(forKey: "dialCode") as? String
//        countryCell.countryImageView.image = ((sectionDataArray[indexPath.row] as AnyObject)["emoji"] as? String)!.emojiToImage()
//        
//        countryCell.countryCodeLabel.font = UIFont(name: "Brandon_reg", size: 16)
//        countryCell.countryNameLabel.font = UIFont(name: "Brandon_reg", size: 16)
//
//        return countryCell
//    }
//    
//    // method to run when table view cell is tapped
//    /// Click action delegate of table view row For Pickedup selected country details from List
//    /// - Parameters:
//    ///   - tableView: tableView object that displays Countries list
//    ///   - indexPath: getting for selected indexpath object from TableView
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        /// Retreive the data from Countries based on Group wise and display the data in the respected fields
//        let sectionDataArray : NSArray = searchDictionary.value(forKey: keysArray.object(at: indexPath.section) as! String)! as AnyObject as! NSArray
//        
//        if (selectedTF.placeholder?.contains("Office"))! {
//            selectedOfficeCountryDictionary = sectionDataArray[indexPath.row] as? NSDictionary ?? NSDictionary()
//        }
//        else {
//            selectedCountryDictionary = sectionDataArray[indexPath.row] as? NSDictionary ?? NSDictionary()
//        }
//        
//        let countryCell = tableView.cellForRow(at: indexPath) as! CountryCodeCell
//        selectedTF.text = (countryCell.countryCodeLabel.text ?? "") + " " + (countryCell.countryNameLabel.text ?? "")
//        
//        if selectedTF.tag == 3 {
//            selectedTF.text = countryCell.countryCodeLabel.text!
//        }
//        
//        if selectedImageView != nil {
//            selectedImageView.image = ((sectionDataArray[indexPath.row] as AnyObject)["emoji"] as? String)!.emojiToImage()
//        }
//        
//        self.dismiss(animated: true, completion: nil)
//    }
//    
//    /// To display the number of sections for table
//    /// - Parameter tableView: tableView object that displays sections as Popular and All Countries
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return searchDictionary.allKeys.count
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UIDevice().userInterfaceIdiom == .phone ? 50 : 80
//    }
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//                
//        if section == 0 {
//            return 0
//        }
//        else {
//            return UIDevice().userInterfaceIdiom == .phone ? 50 : 80
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        
//        return keysArray.object(at: section) as? String
//    }
//}
//
//var countryDictionary : NSMutableDictionary!
//var searchDictionary : NSMutableDictionary!
//
//var selectedCountryDictionary = NSDictionary()
//var selectedOfficeCountryDictionary = NSDictionary()
//
//func startJsonServiceForRetrieveCountryCodes() {
//    
//    /// get the country json file path to string , File name - CountryCode.json
//    let path: NSString = Bundle.main.path(forResource: "CountryCode", ofType: "json")! as NSString
//    
//    /// convery file path binary data
//    let data : Data = try! Data(contentsOf: URL(fileURLWithPath: path as String), options: NSData.ReadingOptions.dataReadingMapped)
//    
//    /**
//     *  parse the binary using NSJSONSerialization
//     *
//     *  @param data  pass binary data
//     *  @param NSJSONReadingOptions.MutableContainers format specifier
//     *
//     *  @return it returns the all values to dictionary, Retrieving the data into responseDictionary
//     */
//    countryDictionary = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSMutableDictionary
//    
//    searchDictionary = countryDictionary;
//    
//    #if DEDEBUG
//    NSLog(" %@", searchDictionary)
//    #endif
//    
//}
