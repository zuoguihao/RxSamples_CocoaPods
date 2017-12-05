//
//  UIColor+DS.swift
//  RxSamples_CocoaPods
//
//  Created by 左得胜 on 2017/12/5.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import UIKit

extension UIColor {
    /// 扩展随机色
    class var random: UIColor {
        return UIColor(red: CGFloat(arc4random_uniform(256))/255.0, green: CGFloat(arc4random_uniform(256))/255.0, blue: CGFloat(arc4random_uniform(256))/255.0, alpha: 1.0)
    }
    
    /// 扩展 rgba 颜色
    ///
    /// - Parameters:
    ///   - r: red（0~256）
    ///   - g: green（0 ~ 256）
    ///   - b: blue（0 ~ 256）
    ///   - alpha: 透明度
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
    
    /// 扩展十六进制颜色（前缀可能为：## # 0X 0x）
    ///
    ///   - hexString: 十六进制颜色值
    convenience init?(hexString: String) {
        
        // 方法一：
        //        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        //        var int = UInt32()
        //        Scanner(string: hex).scanHexInt32(&int)
        //        let a, r, g, b: UInt32
        //        switch hex.characters.count {
        //        case 3: // RGB (12-bit)
        //            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        //        case 6: // RGB (24-bit)
        //            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        //        case 8: // ARGB (32-bit)
        //            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        //        default:
        //            (a, r, g, b) = (1, 1, 1, 0)
        //        }
        //
        //        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 255.0)
        
        
        // 方法二：
        // 判断字符串长度是否大于6
        guard hexString.count >= 6 else {
            print("非正确的十六进制颜色取色值，请检查取色值")
            return nil
        }
        
        var hexTempString = hexString.uppercased()
        
        // 如果字符串是 0XFF0022
        if hexTempString.hasPrefix("0X") || hexTempString.hasPrefix("##") {
            hexTempString = (hexTempString as NSString).substring(from: 2)
        } else if hexTempString.hasPrefix("#") {// 如果字符串是以 # 开头
            hexTempString = (hexTempString as NSString).substring(from: 1)
        }
        
        // 获取 RGB 分别对应的十六进制
        // r: FF g: 00 b: 22
        var range = NSRange(location: 0, length: 2)
        let rHex = (hexTempString as NSString).substring(with: range)
        range.location = 2
        let gHex = (hexTempString as NSString).substring(with: range)
        range.location = 4
        let bHex = (hexTempString as NSString).substring(with: range)
        
        // 将十六进制转成数值 FF 22
        var r: UInt32 = 0
        var g: UInt32 = 0
        var b: UInt32 = 0
        Scanner(string: rHex).scanHexInt32(&r)
        Scanner(string: gHex).scanHexInt32(&g)
        Scanner(string: bHex).scanHexInt32(&b)
        
        self.init(r: CGFloat(r), g: CGFloat(g), b: CGFloat(b))
        
    }
    
    // 从颜色重获取 RGB 的值
    func getRGBValue() -> (CGFloat, CGFloat, CGFloat) {
        /*
         guard let components = cgColor.components else {
         fatalError("错误：请确定颜色是通过 rgb 创建的！")
         }
         
         return (components[0] * 255, components[1] * 255, components[2] * 255)
         */
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        return (red * 255, green * 255, blue * 255)
    }
}
