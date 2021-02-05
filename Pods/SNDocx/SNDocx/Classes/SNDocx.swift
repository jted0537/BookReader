//
//Copyright (c) 2018 ahmedAlmasri <ahmed.almasri@ymail.com>
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.
//

import Foundation
import Zippy

public class SNDocx:NSObject{
    
    private let wordName = "document.xml"
    
    public static let shared = SNDocx()
    
    private override init() {
        super.init()
    }
    
    public func getText(fileUrl url:URL)->String?{
        var result:String?  = nil
        do {
            let files = try ZipFile.init(url: url)
            
            for file in files {
                
                if file.contains(wordName){
                    result =  parseDocx(files[file])
                    break
                }
            }
            
        }catch {
            debugPrint(error.localizedDescription)
        }
        
        return result
    }
    
    
    
    private func parseDocx(_ data:Data?)->String?{
        guard let data = data else {
            return nil
        }
        let str = String.init(data: data, encoding: .utf8)
        return matches(str ?? "")
    }
    
    
    private func matches(_ originalText:String)->String{
        var paragraphs = [String]()
        var result = [String]()
        var re: NSRegularExpression!
        var re2: NSRegularExpression!
        
        do {
            re = try NSRegularExpression(pattern: "<w:p.*?>(.*?)</w:p>", options: [])
            re2 = try NSRegularExpression(pattern: "<w:t.*?>(.*?)</w:t>", options: [])
            
        } catch {
            
        }
        
        let matches = re.matches(in: originalText, options: [], range: NSRange(location: 0, length: originalText.utf16.count))
        
        for match in matches {
            paragraphs.append((originalText as NSString).substring(with: match.range(at: 0)))
        }
        
        for paragraph in paragraphs {
            var sentences = [String]()
            let components = re2.matches(in: paragraph, options: [], range: NSRange(location: 0, length: paragraph.utf16.count))

            for component in components {
                sentences.append((paragraph as NSString).substring(with: component.range(at: 1)))
            }
            result.append(sentences.joined(separator: ""))
        }
        return result.joined(separator: "\n")
    }
}
