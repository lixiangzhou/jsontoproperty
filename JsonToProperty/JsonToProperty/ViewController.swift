//
//  ViewController.swift
//  JsonToProperty
//
//  Created by lixiangzhou on 2019/4/22.
//  Copyright © 2019 lixiangzhou. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    enum Language: String {
        case swift = "Swift"
        case objectiveC = "Objective C"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let a: Any = 1
//        let b: Any = "a"
//        let c: Any = 1.2
//        let d: Any = true
//
//        print(type(of: a))
//        print(type(of: b))
//        print(type(of: c))
//        print(type(of: d))
//
//        if type(of: a) == Int.self {
//            print("haha")
//        }
        
        comboBox.selectItem(at: 0)
    }
    
    private let dataSource = [Language.swift, Language.objectiveC]
    
    
    @IBOutlet var inputView: NSTextView!
    @IBOutlet var outputView: NSTextView!
    @IBOutlet weak var comboBox: NSComboBox!
}

extension ViewController {
    @IBAction func generateAction(_ sender: NSButton) {
        guard let inputData = inputView.string.data(using: .utf8) else { return }
        do {
            let json = try JSONSerialization.jsonObject(with: inputData, options: JSONSerialization.ReadingOptions.mutableContainers)
            var result = ""
//            objects are NSString, NSNumber, NSArray, NSDictionary, or NSNull
            if let dict = json as? NSDictionary {
                for key in dict.allKeys {
                    let value = dict[key]!
                    result += "var \(key): "
                    
                    let t = type(of: value)
                    let typeString = "\(t)"
                    print(typeString)
                    
                    if let _ = value as? NSArray {
                        result += "[]"
                    } else if let _ = value as? NSDictionary {
                        result += "[:]"
                    } else {
                        
                        
                        if typeString.contains("String") {
                            result += "String = \"\""
                        } else if typeString.contains("Number") {
                            if "\(value)".contains(".") {
                                result += "Double = 0.0"
                            } else {
                                result += "Int = 0"
                            }
                        } else if typeString.contains("Boolean") {
                            result += "Bool = false"
                        }
                    }
                    result += "\n\n"
                }
            }
            
            outputView.string = result
            print(result)
        } catch {
            print(error)
        }
        
    }
}

extension ViewController: NSComboBoxDataSource {
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return dataSource.count
    }
    
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        return dataSource[index].rawValue
    }
}

