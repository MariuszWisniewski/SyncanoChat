//
//  IQTitleBarButtonItem.swift
// https://github.com/hackiftekhar/IQKeyboardManager
// Copyright (c) 2013-15 Iftekhar Qurashi.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


import UIKit

public class IQTitleBarButtonItem: UIBarButtonItem {
   
    public var font : UIFont? {
    
        didSet {
            if let unwrappedFont = font {
                _titleLabel?.font = unwrappedFont
            } else {
                _titleLabel?.font = UIFont.boldSystemFontOfSize(12)
            }
        }
    }
    
    private var _titleLabel : UILabel?
    private var _titleView : UIView?

    override init() {
        super.init()
    }
    
    init(frame : CGRect, title : String?) {

        self.init(title: nil, style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        _titleView = UIView(frame: frame)
        _titleView?.backgroundColor = UIColor.clearColor()
        _titleView?.autoresizingMask = .FlexibleWidth
        
        _titleLabel = UILabel(frame: _titleView!.bounds)
        _titleLabel?.textColor = UIColor.lightGrayColor()
        _titleLabel?.backgroundColor = UIColor.clearColor()
        _titleLabel?.textAlignment = .Center
        _titleLabel?.text = title
        _titleLabel?.autoresizingMask = .FlexibleWidth
        font = UIFont.boldSystemFontOfSize(12.0)
        _titleLabel?.font = self.font
        customView = _titleLabel
        enabled = false
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
