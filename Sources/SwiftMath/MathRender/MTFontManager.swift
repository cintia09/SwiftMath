
//
//  Created by Mike Griebling on 2022-12-31.
//  Translated from an Objective-C implementation by Kostub Deshmukh.
//
//  This software may be modified and distributed under the terms of the
//  MIT license. See the LICENSE file for details.
//

import Foundation

public class MTFontManager {
    
    static public private(set) var manager: MTFontManager = {
        MTFontManager()
    }()
    
    let kDefaultFontSize = CGFloat(20)
    
    static var fontManager : MTFontManager {
        return manager
    }

    public init() { }

    @RWLocked
    var nameToFontMap = [String: MTFont]()

    public func font(withName name:String, size:CGFloat) -> MTFont? {
        // --- START OF FIX ---
        
        // 1. 检查缓存（这部分逻辑保持不变）
        // 注意：由于 MTFontV2 已经实现了 copy(withSize:)，我们可以继续使用这个缓存机制。
        if let cachedFont = self.nameToFontMap[name] {
            if cachedFont.fontSize == size {
                return cachedFont
            } else {
                return cachedFont.copy(withSize: size)
            }
        }
        
        // 2. 如果缓存未命中，使用新的、健壮的字体系统来创建字体。
        //    首先，将字体名称转换为 MathFont 枚举类型。
        guard let mathFont = MathFont(rawValue: name) else {
            // 如果传入的 name 不是一个已知的数学字体（比如 PingFangSC），
            // 我们就不应该尝试用这个管理器加载它。返回 nil 是安全的。
            print("MTFontManager Error: '\(name)' is not a recognized MathFont in the library.")
            return nil
        }
        
        // 3. 使用 MathFont 枚举的便捷方法来创建 MTFontV2 实例。
        //    这个方法会通过 BundleManager 安全地加载字体。
        let newFont = mathFont.mtfont(size: size)
        
        // 4. 将新创建的字体存入缓存。
        self.nameToFontMap[name] = newFont
        
        return newFont
        
        // --- END OF FIX ---
        
        /*
         // ----> 以下是旧的、导致崩溃的代码，我们不再使用它 <----
         var f = self.nameToFontMap[name]
         if f == nil {
         // 这行代码调用了 MTFont.swift 中有问题的 init
         f = MTFont(fontWithName: name, size: size)
         self.nameToFontMap[name] = f
         }
         
         if f!.fontSize == size { return f }
         else { return f!.copy(withSize: size) }
         */
    }
    
    public func latinModernFont(withSize size:CGFloat) -> MTFont? {
        MTFontManager.fontManager.font(withName: "latinmodern-math", size: size)
    }
    
    public func kpMathLightFont(withSize size:CGFloat) -> MTFont? {
        MTFontManager.fontManager.font(withName: "KpMath-Light", size: size)
    }
    
    public func kpMathSansFont(withSize size:CGFloat) -> MTFont? {
        MTFontManager.fontManager.font(withName: "KpMath-Sans", size: size)
    }
    
    public func xitsFont(withSize size:CGFloat) -> MTFont? {
        MTFontManager.fontManager.font(withName: "xits-math", size: size)
    }
    
    public func termesFont(withSize size:CGFloat) -> MTFont? {
        MTFontManager.fontManager.font(withName: "texgyretermes-math", size: size)
    }
    
    public func asanaFont(withSize size:CGFloat) -> MTFont? {
        MTFontManager.fontManager.font(withName: "Asana-Math", size: size)
    }
    
    public func eulerFont(withSize size:CGFloat) -> MTFont? {
        MTFontManager.fontManager.font(withName: "Euler-Math", size: size)
    }
    
    public func firaRegularFont(withSize size:CGFloat) -> MTFont? {
        MTFontManager.fontManager.font(withName: "FiraMath-Regular", size: size)
    }
    
    public func notoSansRegularFont(withSize size:CGFloat) -> MTFont? {
        MTFontManager.fontManager.font(withName: "NotoSansMath-Regular", size: size)
    }
    
    public func libertinusRegularFont(withSize size:CGFloat) -> MTFont? {
        MTFontManager.fontManager.font(withName: "LibertinusMath-Regular", size: size)
    }
    
    public func garamondMathFont(withSize size:CGFloat) -> MTFont? {
        MTFontManager.fontManager.font(withName: "Garamond-Math", size: size)
    }
    
    public func leteSansFont(withSize size:CGFloat) -> MTFont? {
        MTFontManager.fontManager.font(withName: "LeteSansMath", size: size)
    }
    
    public var defaultFont: MTFont? {
        MTFontManager.fontManager.latinModernFont(withSize: kDefaultFontSize)
    }


}
