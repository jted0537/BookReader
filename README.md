# FOCUSLY
------------------
<br/>

## FOCUSLY Project Description
---------------------

<img width="684" alt="스크린샷 2021-02-19 오후 2 14 10" src="https://user-images.githubusercontent.com/47416192/108461251-b0786e00-72bd-11eb-802e-3bcad3443c5e.png">
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

When running the app, the first login view:<br/>
<img width="266" alt="KakaoTalk_Photo_2021-02-19-15-27-07" src="https://user-images.githubusercontent.com/47416192/108466462-0d2c5680-72c7-11eb-9bd1-2710b7e9b900.png">

After logged in, users can add a new article which is taken from .docx file:
![KakaoTalk_Photo_2021-02-19-15-31-03](https://user-images.githubusercontent.com/47416192/108467431-8a0c0000-72c8-11eb-9661-da4c45b90f42.gif){: width="266" height="100"}
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
