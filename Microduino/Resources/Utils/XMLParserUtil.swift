//
//  XMLParserUtil.swift
//  Microduino
//
//  Created by harvey on 16/4/5.
//  Copyright © 2016年 harvey. All rights reserved.
//
import UIKit

class XMLParserUtil: NSObject, NSXMLParserDelegate {
    private var parserManager : NSXMLParser!
    private var currentModel : XMLContentModel?
    private var currentElement : String?
    private var currentValue : String?
    var contentArray : Array<XMLContentModel> = Array()
    // 回调block
    typealias XMLParserBlock = (array : Array<XMLContentModel>) -> Void
    var block : XMLParserBlock?
    
    convenience init(content : String, block : XMLParserBlock?) {
        self.init()
        
        var contentStr = "<content>" + content + "</content>"
        contentStr = contentStr.stringByReplacingOccurrencesOfString("<p><br></p>", withString: "")
        contentStr = contentStr.stringByReplacingOccurrencesOfString("<br>", withString: "")
//        contentStr = contentStr.stringByReplacingOccurrencesOfString("<span style=\"letter-spacing: 0.8px;\">", withString: "")
//        contentStr = contentStr.stringByReplacingOccurrencesOfString("</span>", withString: "")
//        contentStr = contentStr.stringByReplacingOccurrencesOfString("<o:p></o:p>", withString: "")
//        contentStr = contentStr.stringByReplacingOccurrencesOfString("&quot;", withString: "")
        
        self.block = block
 
        parserManager = NSXMLParser(data: contentStr.dataUsingEncoding(NSUTF8StringEncoding)!)
        parserManager.delegate = self
        parserManager.parse()
    
    }
    
    // MARK: - NSXMLParserDelegate
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
         print(currentElement)
        
        currentElement = elementName
        if elementName == "img" {
           
            currentModel = XMLContentModel()
            currentElement = "img"
            currentValue = attributeDict["src"]
              print("图片",currentValue)
            currentModel!.contentType = .XMLContentTypeImg
            currentModel!.content = attributeDict["src"]!
        }else if elementName == "a" {
            currentModel = XMLContentModel()
            currentElement = "a"
            currentValue = attributeDict["href"]!
            currentModel!.contentType = .XMLContentTypeA
            currentModel!.content = attributeDict["href"]!
            print("链接",currentValue)
        }
        
        
    }
   
   
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        
        print(currentElement)
        
        if currentElement != "" {
            // 发现标题
            switch currentElement! {
                case "h2":
                  
                    currentModel = XMLContentModel()
                    currentModel?.contentType = .XMLContentTypeH2
                    currentValue = string
                    print("标题",currentValue)
                    currentModel?.content = currentValue
                case "p" :
                   
                    currentModel = XMLContentModel()
                    currentModel?.contentType = .XMLContentTypeP
                    currentValue = string
                      print("内容",currentValue)
                    currentModel?.content = currentValue
            default:
                break
                
            }
        }
        
       
    }
    // 结束
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
       
        guard let _ = self.currentModel else {
            return
        }
        
        guard currentElement != "" && currentValue != "" else {
            return
        }
        
        self.contentArray.append(currentModel!)
        currentValue = ""
        currentElement = ""
        currentModel = nil
        
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        
        print ("解析xml错误\(parser.parserError?.description)")
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        if let _ = self.block {
            self.block!(array: self.contentArray)
        }
    }
}
