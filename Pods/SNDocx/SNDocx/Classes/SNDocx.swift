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
        //var paragraphs = [String]() // rsid : contents
        var linefeedsRsids = [String]()
        var result = [String]()
        var re: NSRegularExpression!
        var re2: NSRegularExpression!
        var re3: NSRegularExpression!
        var reTab: NSRegularExpression!
        
        print("open the docx")
        
        do {
            re = try NSRegularExpression(pattern: "<w:p(.*?)w:rsidRDefault=\"([A-Z0-9+]*)\"(.*?)>(.*?)</w:p>", options: [])
//            re = try NSRegularExpression(pattern: "<w:p(.*?)w:rsidRDefault=\"([A-Z0-9+]*)\">(.*?)</w:p>", options: [])
            // 예외적인 linefeed를 추가해주기 위한 정규화식
            reTab = try NSRegularExpression(pattern: "(.*?)<w:ind w:firstLine=\"800\"/>(.*?)", options: [])
//            reSpace = try NSRegularExpression(pattern: "<w:t xml:space=\"([a-z+]*\">(.*?)</w:t>")
            reSpace = try NSRegularExpression(pattern: "(.*?)<w:br/>(.*?)")
            re2 = try NSRegularExpression(pattern: "<w:p(.*?)w:rsidRDefault=\"([A-Z0-9+]*)\"/>", options: [])
            re3 = try NSRegularExpression(pattern: "<w:t(\\s?)(.*?)>(.*?)</w:t>", options: [])
        } catch {
            
        }
        
        let lmatches = re2.matches(in: originalText, options: [], range: NSRange(location: 0, length: originalText.utf16.count))
        
        for lmatch in lmatches {
            linefeedsRsids.append((originalText as NSString).substring(with: lmatch.range(at: 2)))
        }
        
        let pmatches = re.matches(in: originalText, options: [], range: NSRange(location: 0, length: originalText.utf16.count))
        
        var i = 0
        for pmatch in pmatches {
            var paragraph = (originalText as NSString).substring(with: pmatch.range(at:4))
            var rsid = (originalText as NSString).substring(with: pmatch.range(at:2))
            var sentences = [String]()
            let components = re3.matches(in: paragraph, options: [], range: NSRange(location: 0, length: paragraph.utf16.count))
            let istab: Bool = !(reTab.matches(in: paragraph, options: [], range: NSRange(location: 0, length: paragraph.utf16.count)).isEmpty)
            
            
            if istab {
                sentences.append("\t")
            }
            
            // 여기서 문단의 rsid랑 개행의 rsid가 일치하면 sentences 앞에 개행 문자 추가
            if linefeedsRsids.count > i {
                if rsid == linefeedsRsids[i]{
                    result.append("")
                    i += 1
                }
            }
            
            for component in components {
                sentences.append((paragraph as NSString).substring(with: component.range(at: 3)))
            }
            result.append(sentences.joined(separator: ""))
        }
        return result.joined(separator: "\n")
    }
}
