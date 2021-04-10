# BookReader
------------------
For reading book contents.
<br/>
We provide convert .docx, .pdf to book contents and OCR functions
<br/>

## Development Environment
---------------------

- Xcode 12.4(12D4e)
- Language: Swift 5
- SwiftUI
- Database Model: Realtime Database
- used SDK: Firebase
<br/>

## Podfile Installation
--------------------

There are some files to be installed in Podfile:
```
pod 'Firebase/Analytics'
pod 'Firebase/Auth'
pod 'Firebase/Firestore'
pod 'GoogleSignIn'
pod 'SNDocx'
pod 'lottie-ios'
pod 'Firebase/MLVision'
pod 'Firebase/Database'
```

After add the required elements listed above, execute the installation command in the terminal:
```
pod install
```
<br/>

## License
------------

License Info for SNDocx:
```
Copyright (c) 2018 ahmedAlmasri <ahmed.almasri@ymail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```

License Info for Zippy:
```
Copyright © 2017 Clemens Schulz. All rights reserved.
```

License Info for ImagePicker.swift:
```
Copyright © 2020 Mohammad Azam. All rights reserved.
```
<br/>

## Application Execution Flow
--------------------------
After logged in, the first main view(displaying MyLibrary View):<br/>
<img width="266" alt="myLibrary-view" src="https://user-images.githubusercontent.com/47416192/108469755-33082a00-72cc-11eb-8866-5f9f07a132ce.png"><br/>

When users select one of their articles, the article vew:<br/>
<img width="266" alt="Article-view" src="https://user-images.githubusercontent.com/47416192/108647457-0df9fe00-74fc-11eb-8060-0de01f59ff11.gif"><br/>

Users can highlight& repeat the words that they want to look into:<br/>
<img width="266" alt="Article-view-highlihgt-repeat" src="https://user-images.githubusercontent.com/47416192/108653045-dcd3fa80-7508-11eb-995f-e71e84b14103.gif"><br/>

Users can add a new article which is taken from .pdf, .docx, .txt files:<br/>
<img width="266" alt="extract-docx" src="https://user-images.githubusercontent.com/47416192/108468707-7eb9d400-72ca-11eb-8aa2-4cfa5ce90a27.gif"><br/>

<br/>

## To-be Fixed Problems
--------------------------

- Repeat Mode : When repeat play is being executed, return button is not listening well
- Higlight Mode : Cannot choose the highlight color & Highlights are applied temporarily
- Data Model: Folder Model is not implemented & Higlight Model in Article Model is not applied yet(unstable)
- Tab Item: Settings page is not implemented yet
- Progress circle: Representation of reading progress circle is unstable
- Epub File: Extracting epub file is not supported yet
- Docx File: Needed to be optimized to reduce the loading time
<br/>
