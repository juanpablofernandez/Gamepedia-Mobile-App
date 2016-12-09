//
//  wikiArticles.swift
//  Gamepedia Mobile App
//
//  Created by Jay on 12/6/16.
//  Copyright © 2016 Juan Pablo Fernandez. All rights reserved.
//

import Foundation
import UIKit

protocol wikiArticlesDelegate {
    func listOfWikis(wikiList: [[String: String]])
}

class wikiArticles {
    
    var delegate: wikiArticlesDelegate?
    var allWikis: [[String:String]] = []
    
    init() {
        makeAllRequests(URL: "http://www.gamepedia.com/wikis")
    }
    
    func getAllWikis(mainUrl: String) {
        let url = NSURL(string: mainUrl)
        let request = NSURLRequest(url: url! as URL)
        var wikiInfo: [[String:String]] = []
        
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main) {(response, data, error) in
            let html = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as! String
            let body = html.components(separatedBy: "</head>")[1]
            
            //Get All of the Wikis:
            let wikis = body.components(separatedBy: "<ul class=\"listing listing-wiki wiki-listing\"  data-ajax-set-window-state=\"true\"  data-row-selector=\"&gt;li\">")[1]
            let lis = wikis.components(separatedBy: "</div>")[0]
            var content = lis.components(separatedBy: "<li class=\"wiki\">")
            
            for i in content.indices {
                var wikiArticle: [String:String] = [:]
                
                if i > 0 {
                    var lines = content[i].components(separatedBy: ">")
                    
                    var one = lines[1]
                    one = one.components(separatedBy: "<a href=")[1]
                    wikiArticle["Link"] = one.components(separatedBy: "\"")[1]
                    
                    var two = lines[2]
                    two = two.components(separatedBy: "<img src=")[1]
                    wikiArticle["Image"] = two.components(separatedBy: "\"")[1]
                    
                    let three = lines[4]
                    wikiArticle["Title"] = three.components(separatedBy: "<")[0].html2AttributedString?.string
                    
                    let four = lines[7]
                    wikiArticle["Edits"] = four.components(separatedBy: "<")[0]
                    
                    let five = lines[9]
                    wikiArticle["Contributors"] = five.components(separatedBy: "<")[0]
                    
                    let six = lines[11]
                    wikiArticle["Articles"] = six.components(separatedBy: "<")[0]
                    
                    self.allWikis.append(wikiArticle)
                    self.delegate?.listOfWikis(wikiList: self.allWikis)
                    
                }
            }
            
            
            
//            for i in wikiInfo.indices {
//                print()
//                for a in wikiInfo[i].indices {
//                    print(wikiInfo[i][a])
//                }
//            }
        }
    }
    
    func makeAllRequests(URL: String) {
        let url = NSURL(string: URL)
        let request = NSURLRequest(url: url! as URL)
        
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main) {(response, data, error) in
            let html = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as! String
            _ = html.components(separatedBy: "</head>")[1]
            
            //Get the number of pages:
            let numberOfPagesDiv = html.components(separatedBy: "<ul class=\"b-pagination-list paging-list j-tablesorter-pager j-listing-pagination\" data-viewstate=\"\"  style=\"\">")[1]
            let numberOfPagesDivClose = numberOfPagesDiv.components(separatedBy: "</ul>")[0]
            let numberOfPagesLi = numberOfPagesDivClose.components(separatedBy: "<li class=\"b-pagination-item\">")[6]
            let numberOfPagesA = numberOfPagesLi.components(separatedBy: ">")[1]
            let numberOfPages = numberOfPagesA.components(separatedBy: "<")[0]
            let pages = Int(numberOfPages)
            
            for pageNumber in 1...pages! {
                self.getAllWikis(mainUrl: "http://www.gamepedia.com/wikis?page=\(pageNumber)")
            }
        }
    }
}
