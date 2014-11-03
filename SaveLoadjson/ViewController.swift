//
//  ViewController.swift
//  SaveLoadjson
//
//  Created by Craig Grummitt on 11/3/14.
//  Copyright (c) 2014 Craig Grummitt. All rights reserved.
//


import UIKit

class ViewController: UIViewController {
    /*  Stack Overflow useful for reading/writing in Swift:
            http://stackoverflow.com/questions/24097826/read-and-write-data-from-text-file
        SwiftyJSON:
        https://github.com/SwiftyJSON/SwiftyJSON
    */
    let file = "data.json"
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func saveName(sender: AnyObject) {
        //create json from fields
        let json = JSON(["name":nameField.text, "surname": surnameField.text])
        //create an error variable to store error info
        var error:NSError?
        //create NSData variable from json raw data
        let jsonData:NSData = json.rawData(options: NSJSONWritingOptions.PrettyPrinted, error: &error)!
        //store data to disk
        jsonData.writeToFile(getFilePath(), options: NSDataWritingOptions.DataWritingFileProtectionNone, error: &error)
        //error handling
        if let theError = error {
            print("\(theError.localizedDescription)")
        }
    }
    @IBAction func loadName(sender: AnyObject) {
        //create an error variable to store error info
        var error:NSError?
        //get data from file path
        let data:NSData? = NSData(contentsOfFile: getFilePath(), options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &error)
        //if there were no errors...
        if let theError = error {
            print("\(theError.localizedDescription)")
        } else {
            //convert data to JSON structure
            let json = JSON(data:data!)
            //check if the json object contains name, if so set the nameField
            if let name = json["name"].string {
                nameField.text = name
            }
            //check if the json object contains surname, if so set the surnameField
            if let surname = json["surname"].string {
                surnameField.text = surname
            }
        }
    }
    //get the file path
    func getFilePath()->String {
        //search for the Documents path
        let dirs: [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
        var path = ""
        if (dirs != nil) {
            let directories:[String] = dirs!
            let dirs = directories[0]; //documents directory (first element of the array)
            //add the file to the documents path
            path = dirs.stringByAppendingPathComponent(file);
        }
        return path
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

