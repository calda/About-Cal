//
//  ContentParser.swift
//  About Cal
//
//  Created by Cal on 4/18/15.
//  Copyright (c) 2015 Cal Stephens. All rights reserved.
//

import UIKit

class ContentParser : NSObject, XMLParserDelegate {
    
    var pages : [PageData] = []
    var activePage : PageData?
    var activeModuleType : String?
    
    override init() {
        let path = Bundle.main.path(forResource: "content", ofType: "xml")!
        let data = try? Data(contentsOf: URL(fileURLWithPath: path))
        let xmlParser = XMLParser(data: data!)
        super.init()
        xmlParser.delegate = self
        xmlParser.parse()
    }
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        if elementName == "page" { //is a new page
            //save the previousPage if it exists
            if let active = activePage {
                pages.append(active)
                activePage = nil
            }
            
            if attributeDict["title"] == nil { //is naked page, most likely end marker
                return
            }
            
            //get the data for this page
            let title = attributeDict["title"]!
            let icon = attributeDict["icon"]!
            let date = attributeDict["date"]
            
            activePage = PageData(title: title, iconName: icon, date: date)
        }
        
        if elementName == "item" { //is item module
            activeModuleType = attributeDict["type"]
        }
        
    }
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        //if let string = string {
            if string.hasPrefix("\n") { return }
            if let module = activeModuleType {
                activePage?.modules.append((type: module, data: string))
                activeModuleType = nil
            }
            
        //}
    }
    
}

class PageData {
    
    let title: String
    let icon: UIImage
    let date: String?
    var modules : [(type: String, data: String)] = []
    
    init(title: String, iconName: String, date: String?) {
        self.title = title
        self.date = date
        
        let imagePath = Bundle.main.path(forResource: iconName, ofType: "png")!
        icon = UIImage(contentsOfFile: imagePath)!
    }
    
}
