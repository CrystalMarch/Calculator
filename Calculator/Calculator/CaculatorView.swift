//
//  CaculatorView.swift
//  Hippo
//
//  Created by 朱慧平 on 2017/4/10.
//  Copyright © 2017年 Crystal. All rights reserved.
//

import UIKit
import SnapKit
class CaculatorView: UIView {
    let buttonArray = [".","7","8","9","x","÷","C","","4","5","6","-","√","","0","1","2","3","+","y˟","="]
    let ScreenHeight = UIScreen.main.bounds.height
    let ScreenWidth = UIScreen.main.bounds.width
    let marginX:CGFloat = 8
    let width = (UIScreen.main.bounds.width-64)/7
    let textField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var frame: CGRect{
        didSet{
            updateLayerFrames()
        }
    }
    func updateLayerFrames(){
    
    }
    func addSubViews() {
       self.expands()
        let floatButton = UIButton()
        floatButton.backgroundColor = kHexRGB("323e46", alpha: nil)
        floatButton.setTitle("点击展开", for: .normal)
        floatButton.setTitle("点击收起", for: .selected)
        self.addSubview(floatButton)
        floatButton.isSelected = true
        floatButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(180)
            make.height.equalTo(20)
        }
        floatButton.addTarget(self, action: #selector(self.floatButtonClick(sender:)), for: .touchUpInside)
        let backGroundView = UIView()
        backGroundView.backgroundColor = kHexRGB("2e72d7", alpha: nil)
        self.addSubview(backGroundView)
        backGroundView.snp.makeConstraints { (make) in
            make.top.equalTo(floatButton.snp.bottom)
            make.bottom.equalTo(self.snp.bottom)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
        }
        textField.backgroundColor = UIColor.white
        textField.textAlignment = .right
        textField.text = ""
        textField.tintColor = kHexRGB("2e72d7", alpha: nil)
        textField.textColor = kHexRGB("212f37", alpha: nil)
        let rightView = UIView()
        rightView.frame = CGRect(x:0,y:0,width:20,height:10)
        textField.rightView = rightView
        textField.rightViewMode = .always
        textField.font = UIFont.boldSystemFont(ofSize: 18)
        self.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.top.equalTo(floatButton.snp.bottom).offset(10)
            make.height.equalTo(40)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
        }
        
        
        for index in 0...buttonArray.count - 1 {
            let button = UIButton()
            button.layer.masksToBounds = true
            button.layer.cornerRadius = width/2
            button.setTitle(buttonArray[index], for: .normal)
            if let number = Float.init(buttonArray[index]){
                button.setTitleColor(UIColor.white, for: .normal)
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 23)
                button.addTarget(self, action: #selector(self.buttonClick(sender:)), for: .touchUpInside)
                
            }else if buttonArray[index] == "." || buttonArray[index] == "=" || buttonArray[index] == "C"{
                button.setTitleColor(UIColor.white, for: .normal)
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 23)
                if buttonArray[index] == "=" {
                    button.backgroundColor = kHexRGB("45e2ff", alpha: nil)
                    button.addTarget(self, action: #selector(self.caculatorButtonClick(sender:)), for: .touchUpInside)
                }else if buttonArray[index] == "C"{
                        button.addTarget(self, action: #selector(self.cleanButtonClick(sender:)), for: .touchUpInside)
                }else{
                     button.addTarget(self, action: #selector(self.buttonClick(sender:)), for: .touchUpInside)
                }
            }else{
                 button.titleLabel?.font = UIFont.systemFont(ofSize: 23)
                button.setTitleColor(kHexRGB("80cdfc", alpha: nil), for: .normal)
                button.addTarget(self, action: #selector(self.buttonClick(sender:)), for: .touchUpInside)
                
            }
            self.addSubview(button)
            button.snp.makeConstraints({ (make) in
                make.top.equalTo(textField.snp.bottom).offset(CGFloat(index/7)*width+CGFloat(index/7 + 1)*marginX)
                make.height.equalTo(width)
                make.width.equalTo(width)
                make.left.equalTo(self.snp.left).offset(CGFloat(index%7)*width+CGFloat(index%7 + 1)*marginX)
            })
        }
    }
    func floatButtonClick(sender:UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.expands()
        }else{
            self.contracts()
        }
    }
    func expands() {
        
        self.frame = CGRect(x:0,y:ScreenHeight-(width*3+80+marginX*4),width:ScreenWidth,height:width*3+100+marginX*4)
    }
    func contracts() {
        self.frame = CGRect(x:0,y:ScreenHeight - 20,width:ScreenWidth,height:20)
    }
    func show()  {
        let window = UIApplication.shared.delegate?.window
        window??.addSubview(self)
    }
    func dismiss() {
        self.removeFromSuperview()
    }
    func buttonClick(sender:UIButton) {
        if (sender.currentTitle?.characters.count)! > 0 {
            var str = "\(textField.text!)\(sender.currentTitle!)"
            str = str.replacingOccurrences(of: "÷", with: "/")
            str = str.replacingOccurrences(of: "y˟", with: "^")
            
            textField.text = str
        }
    }
    func cleanButtonClick(sender:UIButton) {
        textField.text = ""
    }
    func caculatorButtonClick(sender:UIButton) {
       
        let m = Calculate(str: textField.text!)
        if let error = m.error {
            print(error.domain)
            self.showAlertView(message: error.domain)
            textField.text = ""
            return
        }
        if let result = m.result {
            if result == Float(NSNotFound){
                self.showAlertView(message: "This format is not correct.")
                textField.text = ""
            }else{
                textField.text = "\(result)"
            }
        }
    }
    func showAlertView(message:String) {
        let alert = UIAlertView(title: nil, message: message, delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
    func kHexRGB(_ Color_Value:NSString,alpha: CGFloat?) -> UIColor {
        var  Str :NSString = Color_Value.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased() as NSString
        if Color_Value.hasPrefix("#"){
            Str=(Color_Value as NSString).substring(from: 1) as NSString
        }
        let StrRed = (Str as NSString ).substring(to: 2)
        let StrGreen = ((Str as NSString).substring(from: 2) as NSString).substring(to: 2)
        let StrBlue = ((Str as NSString).substring(from: 4) as NSString).substring(to: 2)
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: StrRed).scanHexInt32(&r)
        Scanner(string: StrGreen).scanHexInt32(&g)
        Scanner(string: StrBlue).scanHexInt32(&b)
        if (alpha == nil) {
            return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1)
        }
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha!)
    }

}
