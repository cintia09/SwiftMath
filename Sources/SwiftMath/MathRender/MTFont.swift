
import Foundation
import CoreText

//
//  Created by Mike Griebling on 2022-12-31.
//  Translated from an Objective-C implementation by Kostub Deshmukh.
//
//  This software may be modified and distributed under the terms of the
//  MIT license. See the LICENSE file for details.
//

public class MTFont {
    
    var defaultCGFont: CGFont!
    var ctFont: CTFont!
    var mathTable: MTFontMathTable?
    var rawMathTable: NSDictionary?
    
    init() {}
    
    /// `MTFont(fontWithName:)` does not load the complete math font, it only has about half the glyphs of the full math font.
    /// In particular it does not have the math italic characters which breaks our variable rendering.
    /// So we first load a CGFont from the file and then convert it to a CTFont.
    convenience init(fontWithName name: String, size:CGFloat) {
        self.init()
        // ------------------ FINAL FIX START ------------------
                
        // 1. 直接使用 Bundle.module，这是在 Swift Package 中查找资源的正确方式。
        let bundle = Bundle.module

        // 2. 安全地查找字体文件 .otf
        guard let fontPath = bundle.path(forResource: name, ofType: "otf") else {
            fatalError("MTFont Fatal Error: Font file '\(name).otf' not found in SwiftMath's bundle. Ensure it's included in the target's resources.")
        }
        
        // 3. 安全地加载字体数据
        guard let fontDataProvider = CGDataProvider(filename: fontPath),
              let cgFont = CGFont(fontDataProvider) else {
            fatalError("MTFont Fatal Error: Could not create font from path: \(fontPath)")
        }
        self.defaultCGFont = cgFont
        
        self.ctFont = CTFontCreateWithGraphicsFont(self.defaultCGFont, size, nil, nil);
        
        // 4. 安全地查找和加载 .plist 文件
        guard let mathTablePlistURL = bundle.url(forResource: name, withExtension: "plist"),
              let dict = NSDictionary(contentsOf: mathTablePlistURL) else {
            fatalError("MTFont Fatal Error: Math table plist for font '\(name)' not found or failed to load.")
        }
        self.rawMathTable = dict
        
        // 5. 直接调用 MTFontMathTable 的构造器，因为它返回非可选值。
        //    这个构造器在失败时会抛出 Objective-C 异常，这在 Swift 中通常会导致程序终止。
        //    所以这里的调用本身就是“要么成功，要么停机”，不需要可选绑定。
        self.mathTable = MTFontMathTable(withFont: self, mathTable: dict)
        
        // ------------------- FINAL FIX END -------------------
    }
    
    static var fontBundle:Bundle {
        // CJK MOD / BUNDLE FIX: 直接返回库的 Bundle，而不是寻找子 Bundle
            return Bundle.module
    }
    
    /** Returns a copy of this font but with a different size. */
    public func copy(withSize size: CGFloat) -> MTFont {
        let newFont = MTFont()
        newFont.defaultCGFont = self.defaultCGFont
        newFont.ctFont = CTFontCreateWithGraphicsFont(self.defaultCGFont, size, nil, nil)
        newFont.rawMathTable = self.rawMathTable
        newFont.mathTable = MTFontMathTable(withFont: newFont, mathTable: newFont.rawMathTable!)
        return newFont
    }
    
    func get(nameForGlyph glyph:CGGlyph) -> String {
        let name = defaultCGFont.name(for: glyph) as? String
        return name ?? ""
    }
    
    func get(glyphWithName name:String) -> CGGlyph {
        defaultCGFont.getGlyphWithGlyphName(name: name as CFString)
    }
    
    /** The size of this font in points. */
    public var fontSize:CGFloat { CTFontGetSize(self.ctFont) }
    
    deinit {
        self.ctFont = nil
        self.defaultCGFont = nil
    }
    
}
