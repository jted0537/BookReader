//License Info:
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


// SNDocx
// implemented: open source + modified
// purpose: extract the text contents of docx files
// method: zip the docx file and extract xml file & filter the conents

import Foundation
import Zippy

public class SNDocx:NSObject{
    
    private let wordName = "document.xml"
    
    public static let shared = SNDocx()
    
    private override init() {
        super.init()
    }
    
    // get the text of docx
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
    
    // parse the docx
    private func parseDocx(_ data:Data?)->String?{
        guard let data = data else {
            return nil
        }
        let str = String.init(data: data, encoding: .utf8)
        return matches(str ?? "")
    }
    
    // 정규화식 통해 tag filter 후 docx 내용 추출 & return
    private func matches(_ originalText:String)->String{
        var linefeedsRsids = [String]()
        var result = [String]()
        var rePara: NSRegularExpression!
        var reTab: NSRegularExpression!
        var reLF: NSRegularExpression!
        var reWord: NSRegularExpression!
        
        do {
            rePara = try NSRegularExpression(pattern: "<w:p(.*?)w:rsidRDefault=\"([A-Z0-9+]*)\"(.*?)>(.*?)</w:p>", options: [])
            // tab 공백 추가해주기 위한 정규화식
            reTab = try NSRegularExpression(pattern: "(.*?)<w:ind w:firstLine=\"800\"/>(.*?)", options: [])
            // 예외적인 linefeed를 추가해주기 위한 정규화식
            reLF = try NSRegularExpression(pattern: "<w:p(.*?)w:rsidRDefault=\"([A-Z0-9+]*)\"/>", options: [])
            reWord = try NSRegularExpression(pattern: "(<w:t(\\s?)(.*?)>(.*?)</w:t>|<w:br/>)", options: [])
        } catch {
            
        }
        
        let lmatches = reLF.matches(in: originalText, options: [], range: NSRange(location: 0, length: originalText.utf16.count))
        
        for lmatch in lmatches {
            linefeedsRsids.append((originalText as NSString).substring(with: lmatch.range(at: 2)))
        }
        
        let pmatches = rePara.matches(in: originalText, options: [], range: NSRange(location: 0, length: originalText.utf16.count))
        
        var i = 0
        for pmatch in pmatches {
            let paragraph = (originalText as NSString).substring(with: pmatch.range(at:4))
            let rsid = (originalText as NSString).substring(with: pmatch.range(at:2))
            var sentences = [String]()
            let components = reWord.matches(in: paragraph, options: [], range: NSRange(location: 0, length: paragraph.utf16.count))
            let istab: Bool = !(reTab.matches(in: paragraph, options: [], range: NSRange(location: 0, length: paragraph.utf16.count)).isEmpty)
            
            // tab 있으면 tab 추가
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
            
            // words 추출
            for component in components {
                
                if component.range(at: 4).location != NSNotFound {
                    sentences.append((paragraph as NSString).substring(with: component.range(at: 4)))
                    print(component.range(at: 3))
                }
                // <w:br/> 태그 있으면 줄 바꿈
                else {
                    sentences.append("\n")
                }
                
            }
            result.append(sentences.joined(separator: ""))
        }
        return result.joined(separator: "\n")
    }
}
