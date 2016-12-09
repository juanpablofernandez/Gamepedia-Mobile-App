//
//  ViewController.swift
//  Gamepedia Mobile App
//
//  Created by Jay on 12/6/16.
//  Copyright © 2016 Juan Pablo Fernandez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeAllRequests(URL: "http://ark.gamepedia.com/Dino_Dossiers")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func makeStringArray(string: String) -> String {
        var fraseString: String = ""
        var test = false
        
        for chars in string.characters {
            if chars == Character(">") {
                test = true
            } else if chars == Character("<") {
                test = false
            }
            if test == true {
                if chars != Character(">") {
                    let char = String(chars)
                    fraseString += char
                }
            }
        }
        return fraseString
    }
    
    func makeAllRequests(URL: String) {
        let url = NSURL(string: URL)
        let request = NSURLRequest(url: url! as URL)
        
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main) {(response, data, error) in
            let html = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as! String
            let body = html.components(separatedBy: "</head>")[1]
//            let globalWrapper = body.components(separatedBy: "<div id=\"pageWrapper\">")[0]
            //        let globalBody = globalWrapper.components(separatedBy: "<script>")[0]
            
            
            let new = html.html2AttributedString?.string
            
//            let text = self.makeStringArray(string: body)
            self.textView.text = new
            
        }
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
