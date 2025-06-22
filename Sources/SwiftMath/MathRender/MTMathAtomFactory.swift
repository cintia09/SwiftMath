//
//  Created by Mike Griebling on 2022-12-31.
//  Translated from an Objective-C implementation by Kostub Deshmukh.
//
//  This software may be modified and distributed under the terms of the
//  MIT license. See the LICENSE file for details.
//

import Foundation

/** A factory to create commonly used MTMathAtoms. */
public class MTMathAtomFactory {
    
    // In: MTMathAtomFactory.swift

    public static let aliases: [String: String] = [
        "ne": "neq",        // not equal
        "le": "leq",        // less or equal
        "ge": "geq",        // greater or equal
        "lnot": "neg",      // logical not
        "land": "wedge",    // logical and
        "lor": "vee",       // logical or

        "gets": "leftarrow",
        "to": "rightarrow",
        "iff": "Longleftrightarrow", // if and only if
        "implies": "Longrightarrow",
        "impliedby": "Longleftarrow",

        "lbrace": "{",
        "rbrace": "}",
        "Vert": "|",        // double vertical bar
        "langle": "langle",
        "rangle": "rangle",

        "dots": "ldots",
        "AA": "angstrom",
        "Box": "square",    // D'Alembertian operator
    ]
    
    public static let delimiters = [
        "." : "", // . means no delimiter
        "(" : "(",
        ")" : ")",
        "[" : "[",
        "]" : "]",
        "<" : "\u{2329}",
        ">" : "\u{232A}",
        "/" : "/",
        "\\" : "\\",
        "|" : "|",
        "lgroup" : "\u{27EE}",
        "rgroup" : "\u{27EF}",
        "||" : "\u{2016}",
        "Vert" : "\u{2016}",
        "vert" : "|",
        "uparrow" : "\u{2191}",
        "downarrow" : "\u{2193}",
        "updownarrow" : "\u{2195}",
        "Uparrow" : "\u{21D1}",
        "Downarrow" : "\u{21D3}",
        "Updownarrow" : "\u{21D5}",
        "backslash" : "\\",
        "rangle" : "\u{232A}",
        "langle" : "\u{2329}",
        "rbrace" : "}",
        "}" : "}",
        "{" : "{",
        "lbrace" : "{",
        "lceil" : "\u{2308}",
        "rceil" : "\u{2309}",
        "lfloor" : "\u{230A}",
        "rfloor" : "\u{230B}"
    ]
    
    private static let delimValueLock = NSLock()
    static var _delimValueToName = [String: String]()
    public static var delimValueToName: [String: String] {
        if _delimValueToName.isEmpty {
            var output = [String: String]()
            for (key, value) in Self.delimiters {
                if let existingValue = output[value] {
                    if key.count > existingValue.count {
                        continue
                    } else if key.count == existingValue.count {
                        if key.compare(existingValue) == .orderedDescending {
                            continue
                        }
                    }
                }
                output[value] = key
            }
            // protect lazily loading table in a multi-thread concurrent environment
            delimValueLock.lock()
            defer { delimValueLock.unlock() }
            if _delimValueToName.isEmpty {
                _delimValueToName = output
            }
        }
        return _delimValueToName
    }
    
    public static let accents = [
        "grave" :  "\u{0300}",
        "acute" :  "\u{0301}",
        "hat" :  "\u{0302}",  // In our implementation hat and widehat behave the same.
        "tilde" :  "\u{0303}", // In our implementation tilde and widetilde behave the same.
        "bar" :  "\u{0304}",
        "breve" :  "\u{0306}",
        "dot" :  "\u{0307}",
        "ddot" :  "\u{0308}",
        "check" :  "\u{030C}",
        "vec" :  "\u{20D7}",
        "widehat" :  "\u{0302}",
        "widetilde" :  "\u{0303}",
        "dddot":   "\u{20DB}",
        "mathring": "\u{030A}"
    ]
    
    private static let accentValueLock = NSLock()
    static var _accentValueToName: [String: String]? = nil
    public static var accentValueToName: [String: String] {
        if _accentValueToName == nil {
            var output = [String: String]()

            for (key, value) in Self.accents {
                if let existingValue = output[value] {
                    if key.count > existingValue.count {
                        continue
                    } else if key.count == existingValue.count {
                        if key.compare(existingValue) == .orderedDescending {
                            continue
                        }
                    }
                }
                output[value] = key
            }
            // protect lazily loading table in a multi-thread concurrent environment
            accentValueLock.lock()
            defer { accentValueLock.unlock() }
            if _accentValueToName == nil {
                _accentValueToName = output
            }
        }
        return _accentValueToName!
    }
    
    static var supportedLatexSymbolNames:[String] {
        let commands = MTMathAtomFactory.supportedLatexSymbols
        return commands.keys.map { String($0) }
    }
    
    // In: MTMathAtomFactory.swift

    static var supportedLatexSymbols: [String: MTMathAtom] = [
        
        // MARK: - Placeholder
        "square": MTMathAtomFactory.placeholder(),
        
        // MARK: - Greek Characters (Lowercase)
        "alpha":      MTMathAtom(type: .variable, value: "α"),
        "beta":       MTMathAtom(type: .variable, value: "β"),
        "gamma":      MTMathAtom(type: .variable, value: "γ"),
        "delta":      MTMathAtom(type: .variable, value: "δ"),
        "varepsilon": MTMathAtom(type: .variable, value: "ε"),
        "zeta":       MTMathAtom(type: .variable, value: "ζ"),
        "eta":        MTMathAtom(type: .variable, value: "η"),
        "theta":      MTMathAtom(type: .variable, value: "θ"),
        "iota":       MTMathAtom(type: .variable, value: "ι"),
        "kappa":      MTMathAtom(type: .variable, value: "κ"),
        "lambda":     MTMathAtom(type: .variable, value: "λ"),
        "mu":         MTMathAtom(type: .variable, value: "μ"),
        "nu":         MTMathAtom(type: .variable, value: "ν"),
        "xi":         MTMathAtom(type: .variable, value: "ξ"),
        "omicron":    MTMathAtom(type: .variable, value: "ο"),
        "pi":         MTMathAtom(type: .variable, value: "π"),
        "rho":        MTMathAtom(type: .variable, value: "ρ"),
        "varsigma":   MTMathAtom(type: .variable, value: "ς"),
        "sigma":      MTMathAtom(type: .variable, value: "σ"),
        "tau":        MTMathAtom(type: .variable, value: "τ"),
        "upsilon":    MTMathAtom(type: .variable, value: "υ"),
        "varphi":     MTMathAtom(type: .variable, value: "φ"),
        "chi":        MTMathAtom(type: .variable, value: "χ"),
        "psi":        MTMathAtom(type: .variable, value: "ψ"),
        "omega":      MTMathAtom(type: .variable, value: "ω"),
        
        // Greek Variants (treated as ordinary to prevent auto-italicization)
        "epsilon":  MTMathAtom(type: .ordinary, value: "ϵ"),
        "vartheta": MTMathAtom(type: .ordinary, value: "ϑ"),
        "phi":      MTMathAtom(type: .ordinary, value: "ϕ"),
        "varrho":   MTMathAtom(type: .ordinary, value: "ϱ"),
        "varpi":    MTMathAtom(type: .ordinary, value: "ϖ"),
        
        // MARK: - Greek Characters (Uppercase)
        "Gamma":   MTMathAtom(type: .variable, value: "Γ"),
        "Delta":   MTMathAtom(type: .variable, value: "Δ"),
        "Theta":   MTMathAtom(type: .variable, value: "Θ"),
        "Lambda":  MTMathAtom(type: .variable, value: "Λ"),
        "Xi":      MTMathAtom(type: .variable, value: "Ξ"),
        "Pi":      MTMathAtom(type: .variable, value: "Π"),
        "Sigma":   MTMathAtom(type: .variable, value: "Σ"),
        "Upsilon": MTMathAtom(type: .variable, value: "Υ"),
        "Phi":     MTMathAtom(type: .variable, value: "Φ"),
        "Psi":     MTMathAtom(type: .variable, value: "Ψ"),
        "Omega":   MTMathAtom(type: .variable, value: "Ω"),
        
        // MARK: - Delimiters & Brackets
        "{" :          MTMathAtom(type: .open, value: "{"),
        "langle":      MTMathAtom(type: .open, value: "⟨"),
        "lfloor":      MTMathAtom(type: .open, value: "⌊"),
        "lceil":       MTMathAtom(type: .open, value: "⌈"),
        "lgroup":      MTMathAtom(type: .open, value: "⟮"),
        "llbracket":  MTMathAtom(type: .open, value: "⟦"),
        "}" :          MTMathAtom(type: .close, value: "}"),
        "rangle":      MTMathAtom(type: .close, value: "⟩"),
        "rfloor":      MTMathAtom(type: .close, value: "⌋"),
        "rceil":       MTMathAtom(type: .close, value: "⌉"),
        "rgroup":      MTMathAtom(type: .close, value: "⟯"),
        "rrbracket":  MTMathAtom(type: .close, value: "⟧"),
        "vert":        MTMathAtom(type: .ordinary, value: "|"),
        "|" :          MTMathAtom(type: .ordinary, value: "‖"), // Vert
        
        // MARK: - Arrows
        "leftarrow":          MTMathAtom(type: .relation, value: "←"),
        "rightarrow":         MTMathAtom(type: .relation, value: "→"),
        "uparrow":            MTMathAtom(type: .relation, value: "↑"),
        "downarrow":          MTMathAtom(type: .relation, value: "↓"),
        "leftrightarrow":     MTMathAtom(type: .relation, value: "↔"),
        "updownarrow":        MTMathAtom(type: .relation, value: "↕"),
        "Leftarrow":          MTMathAtom(type: .relation, value: "⇐"),
        "Rightarrow":         MTMathAtom(type: .relation, value: "⇒"),
        "Uparrow":            MTMathAtom(type: .relation, value: "⇑"),
        "Downarrow":          MTMathAtom(type: .relation, value: "⇓"),
        "Leftrightarrow":     MTMathAtom(type: .relation, value: "⇔"),
        "Updownarrow":        MTMathAtom(type: .relation, value: "⇕"),
        "longleftarrow":      MTMathAtom(type: .relation, value: "⟵"),
        "longrightarrow":     MTMathAtom(type: .relation, value: "⟶"),
        "longleftrightarrow": MTMathAtom(type: .relation, value: "⟷"),
        "Longleftarrow":      MTMathAtom(type: .relation, value: "⟸"),
        "Longrightarrow":     MTMathAtom(type: .relation, value: "⟹"),
        "Longleftrightarrow": MTMathAtom(type: .relation, value: "⟺"),
        "mapsto":             MTMathAtom(type: .relation, value: "↦"),
        "hookleftarrow":      MTMathAtom(type: .relation, value: "↩"),
        "hookrightarrow":     MTMathAtom(type: .relation, value: "↪"),
        "nearrow":            MTMathAtom(type: .relation, value: "↗"),
        "searrow":            MTMathAtom(type: .relation, value: "↘"),
        "swarrow":            MTMathAtom(type: .relation, value: "↙"),
        "nwarrow":            MTMathAtom(type: .relation, value: "↖"),
        "rightharpoonup":     MTMathAtom(type: .relation, value: "⇀"),
        "rightharpoondown":   MTMathAtom(type: .relation, value: "⇁"),
        "leftharpoonup":      MTMathAtom(type: .relation, value: "↼"),
        "leftharpoondown":    MTMathAtom(type: .relation, value: "↽"),
        "leftrightharpoons":  MTMathAtom(type: .relation, value: "⇋"),
        "rightleftharpoons":  MTMathAtom(type: .relation, value: "⇌"),

        // MARK: - Relations & Logic
        "leq":       MTMathAtom(type: .relation, value: "≤"),
        "geq":       MTMathAtom(type: .relation, value: "≥"),
        "neq":       MTMathAtom(type: .relation, value: "≠"),
        "in":        MTMathAtom(type: .relation, value: "∈"),
        "notin":     MTMathAtom(type: .relation, value: "∉"),
        "ni":        MTMathAtom(type: .relation, value: "∋"),
        "subset":    MTMathAtom(type: .relation, value: "⊂"),
        "supset":    MTMathAtom(type: .relation, value: "⊃"),
        "subseteq":  MTMathAtom(type: .relation, value: "⊆"),
        "supseteq":  MTMathAtom(type: .relation, value: "⊇"),
        "subsetneq": MTMathAtom(type: .relation, value: "⊊"),
        "supsetneq": MTMathAtom(type: .relation, value: "⊋"),
        "sqsubset":  MTMathAtom(type: .relation, value: "⊏"),
        "sqsupset":  MTMathAtom(type: .relation, value: "⊐"),
        "sqsubseteq":MTMathAtom(type: .relation, value: "⊑"),
        "sqsupseteq":MTMathAtom(type: .relation, value: "⊒"),
        "sim":       MTMathAtom(type: .relation, value: "∼"),
        "simeq":     MTMathAtom(type: .relation, value: "≃"),
        "cong":      MTMathAtom(type: .relation, value: "≅"),
        "approx":    MTMathAtom(type: .relation, value: "≈"),
        "asymp":     MTMathAtom(type: .relation, value: "≍"),
        "doteq":     MTMathAtom(type: .relation, value: "≐"),
        "equiv":     MTMathAtom(type: .relation, value: "≡"),
        "prec":      MTMathAtom(type: .relation, value: "≺"),
        "succ":      MTMathAtom(type: .relation, value: "≻"),
        "precsim":   MTMathAtom(type: .relation, value: "≾"),
        "succsim":   MTMathAtom(type: .relation, value: "≿"),
        "ll":        MTMathAtom(type: .relation, value: "≪"),
        "gg":        MTMathAtom(type: .relation, value: "≫"),
        "mid":       MTMathAtom(type: .relation, value: "∣"),
        "nmid":      MTMathAtom(type: .relation, value: "∤"),
        "parallel":  MTMathAtom(type: .relation, value: "∥"),
        "perp":      MTMathAtom(type: .relation, value: "⊥"),
        "propto":    MTMathAtom(type: .relation, value: "∝"),
        "models":    MTMathAtom(type: .relation, value: "⊧"),
        "vdash":     MTMathAtom(type: .relation, value: "⊢"),
        "dashv":     MTMathAtom(type: .relation, value: "⊣"),
        "Join":      MTMathAtom(type: .relation, value: "⨝"),
        "bowtie":    MTMathAtom(type: .relation, value: "⋈"),
        "therefore": MTMathAtom(type: .relation, value: "∴"),
        "because":   MTMathAtom(type: .relation, value: "∵"),
        "triangleq": MTMathAtom(type: .relation, value: "≜"),
        ":=":        MTMathAtom(type: .relation, value: ":="),
        "textless":    MTMathAtom(type: .relation, value: "<"),
        "textgreater": MTMathAtom(type: .relation, value: ">"),
        
        // MARK: - Binary Operators
        "pm":      MTMathAtom(type: .binaryOperator, value: "±"),
        "mp":      MTMathAtom(type: .binaryOperator, value: "∓"),
        "times":   MTMathAtomFactory.times(),
        "div":     MTMathAtomFactory.divide(),
        "cdot":    MTMathAtom(type: .binaryOperator, value: "·"),
        "ast":     MTMathAtom(type: .binaryOperator, value: "∗"),
        "star":    MTMathAtom(type: .binaryOperator, value: "⋆"),
        "circ":    MTMathAtom(type: .binaryOperator, value: "∘"),
        "bullet":  MTMathAtom(type: .binaryOperator, value: "∙"),
        "oplus":   MTMathAtom(type: .binaryOperator, value: "⊕"),
        "ominus":  MTMathAtom(type: .binaryOperator, value: "⊖"),
        "otimes":  MTMathAtom(type: .binaryOperator, value: "⊗"),
        "oslash":  MTMathAtom(type: .binaryOperator, value: "⊘"),
        "odot":    MTMathAtom(type: .binaryOperator, value: "⊙"),
        "cap":     MTMathAtom(type: .binaryOperator, value: "∩"),
        "cup":     MTMathAtom(type: .binaryOperator, value: "∪"),
        "uplus":   MTMathAtom(type: .binaryOperator, value: "⊎"),
        "sqcap":   MTMathAtom(type: .binaryOperator, value: "⊓"),
        "sqcup":   MTMathAtom(type: .binaryOperator, value: "⊔"),
        "wedge":   MTMathAtom(type: .binaryOperator, value: "∧"),
        "vee":     MTMathAtom(type: .binaryOperator, value: "∨"),
        "setminus":MTMathAtom(type: .binaryOperator, value: "∖"),
        "wr":      MTMathAtom(type: .binaryOperator, value: "≀"),
        "amalg":   MTMathAtom(type: .binaryOperator, value: "⨿"),
        "diamond": MTMathAtom(type: .binaryOperator, value: "⋄"),
        
        // MARK: - Operators (with & without limits)
        "log":     MTMathAtomFactory.operatorWithName("log", limits: false),
        "lg":      MTMathAtomFactory.operatorWithName("lg", limits: false),
        "ln":      MTMathAtomFactory.operatorWithName("ln", limits: false),
        "sin":     MTMathAtomFactory.operatorWithName("sin", limits: false),
        "cos":     MTMathAtomFactory.operatorWithName("cos", limits: false),
        "tan":     MTMathAtomFactory.operatorWithName("tan", limits: false),
        "cot":     MTMathAtomFactory.operatorWithName("cot", limits: false),
        "sec":     MTMathAtomFactory.operatorWithName("sec", limits: false),
        "csc":     MTMathAtomFactory.operatorWithName("csc", limits: false),
        "arcsin":  MTMathAtomFactory.operatorWithName("arcsin", limits: false),
        "arccos":  MTMathAtomFactory.operatorWithName("arccos", limits: false),
        "arctan":  MTMathAtomFactory.operatorWithName("arctan", limits: false),
        "sinh":    MTMathAtomFactory.operatorWithName("sinh", limits: false),
        "cosh":    MTMathAtomFactory.operatorWithName("cosh", limits: false),
        "tanh":    MTMathAtomFactory.operatorWithName("tanh", limits: false),
        "coth":    MTMathAtomFactory.operatorWithName("coth", limits: false),
        "arg":     MTMathAtomFactory.operatorWithName("arg", limits: false),
        "ker":     MTMathAtomFactory.operatorWithName("ker", limits: false),
        "dim":     MTMathAtomFactory.operatorWithName("dim", limits: false),
        "hom":     MTMathAtomFactory.operatorWithName("hom", limits: false),
        "exp":     MTMathAtomFactory.operatorWithName("exp", limits: false),
        "deg":     MTMathAtomFactory.operatorWithName("deg", limits: false),
        "Tr":      MTMathAtomFactory.operatorWithName("Tr", limits: false),
        "tr":      MTMathAtomFactory.operatorWithName("tr", limits: false),
        "rank":    MTMathAtomFactory.operatorWithName("rank", limits: false),
        "lim":     MTMathAtomFactory.operatorWithName("lim", limits: true),
        "liminf":  MTMathAtomFactory.operatorWithName("lim inf", limits: true),
        "limsup":  MTMathAtomFactory.operatorWithName("lim sup", limits: true),
        "varliminf": MTMathAtomFactory.operatorWithName("lim inf", limits: true),
        "varlimsup": MTMathAtomFactory.operatorWithName("lim sup", limits: true),
        "min":     MTMathAtomFactory.operatorWithName("min", limits: true),
        "max":     MTMathAtomFactory.operatorWithName("max", limits: true),
        "inf":     MTMathAtomFactory.operatorWithName("inf", limits: true),
        "sup":     MTMathAtomFactory.operatorWithName("sup", limits: true),
        "det":     MTMathAtomFactory.operatorWithName("det", limits: true),
        "Pr":      MTMathAtomFactory.operatorWithName("Pr", limits: true),
        "gcd":     MTMathAtomFactory.operatorWithName("gcd", limits: true),
        "lcm":     MTMathAtomFactory.operatorWithName("lcm", limits: true),
        "bmod":    MTMathAtomFactory.operatorWithName("mod", limits: false),
        
        // MARK: - Large Operators
        "sum":      MTMathAtomFactory.operatorWithName("∑", limits: true),
        "prod":     MTMathAtomFactory.operatorWithName("∏", limits: true),
        "coprod":   MTMathAtomFactory.operatorWithName("∐", limits: true),
        "int":      MTMathAtomFactory.operatorWithName("∫", limits: false),
        "oint":     MTMathAtomFactory.operatorWithName("∮", limits: false),
        "iint":     MTMathAtomFactory.operatorWithName("∬", limits: false),
        "iiint":    MTMathAtomFactory.operatorWithName("∭", limits: false),
        "oiint":    MTMathAtomFactory.operatorWithName("∯", limits: false),
        "oiiint":   MTMathAtomFactory.operatorWithName("∰", limits: false),
        "bigwedge": MTMathAtomFactory.operatorWithName("⋀", limits: true),
        "bigvee":   MTMathAtomFactory.operatorWithName("⋁", limits: true),
        "bigcap":   MTMathAtomFactory.operatorWithName("⋂", limits: true),
        "bigcup":   MTMathAtomFactory.operatorWithName("⋃", limits: true),
        "bigsqcup": MTMathAtomFactory.operatorWithName("⨆", limits: true),
        "biguplus": MTMathAtomFactory.operatorWithName("⨄", limits: true),
        "bigodot":  MTMathAtomFactory.operatorWithName("⨀", limits: true),
        "bigoplus": MTMathAtomFactory.operatorWithName("⨁", limits: true),
        "bigotimes":MTMathAtomFactory.operatorWithName("⨂", limits: true),
        
        // MARK: - Punctuation & Special Characters
        "$":       MTMathAtom(type: .ordinary, value: "$"),
        "&":       MTMathAtom(type: .ordinary, value: "&"),
        "#":       MTMathAtom(type: .ordinary, value: "#"),
        "%":       MTMathAtom(type: .ordinary, value: "%"),
        "_":       MTMathAtom(type: .ordinary, value: "_"),
        " ":       MTMathAtom(type: .ordinary, value: " "),
        "backslash": MTMathAtom(type: .ordinary, value: "\\"),
        "colon":     MTMathAtom(type: .punctuation, value: ":"),
        "cdotp":   MTMathAtom(type: .punctuation, value: "·"),
        "prime":   MTMathAtom(type: .ordinary, value: "′"),
        "angle":   MTMathAtom(type: .ordinary, value: "∠"),
        "nabla":   MTMathAtom(type: .ordinary, value: "∇"),
        "partial": MTMathAtom(type: .ordinary, value: "∂"),
        "infty":   MTMathAtom(type: .ordinary, value: "∞"),
        "Box":     MTMathAtom(type: .ordinary, value: "□"),
        
        // MARK: - Sets, Logic & Misc Symbols
        "emptyset":  MTMathAtom(type: .ordinary, value: "∅"),
        "varnothing":MTMathAtom(type: .ordinary, value: "⌀"),
        "neg":       MTMathAtom(type: .ordinary, value: "¬"),
        "forall":    MTMathAtom(type: .ordinary, value: "∀"),
        "exists":    MTMathAtom(type: .ordinary, value: "∃"),
        "aleph":     MTMathAtom(type: .ordinary, value: "ℵ"),
        "hbar":      MTMathAtom(type: .ordinary, value: "ℏ"),
        "imath":     MTMathAtom(type: .ordinary, value: "\u{1D6A4}"),
        "jmath":     MTMathAtom(type: .ordinary, value: "\u{1D6A5}"),
        "ell":       MTMathAtom(type: .ordinary, value: "ℓ"),
        "wp":        MTMathAtom(type: .ordinary, value: "℘"),
        "Re":        MTMathAtom(type: .ordinary, value: "ℜ"),
        "Im":        MTMathAtom(type: .ordinary, value: "ℑ"),
        "mho":       MTMathAtom(type: .ordinary, value: "℧"),
        "top":       MTMathAtom(type: .ordinary, value: "⊤"),
        "bot":       MTMathAtom(type: .ordinary, value: "⊥"),
        "surd":      MTMathAtom(type: .ordinary, value: "√"),
        "degree":    MTMathAtom(type: .ordinary, value: "°"),
        "dagger":    MTMathAtom(type: .ordinary, value: "†"),
        "ddagger":   MTMathAtom(type: .binaryOperator, value: "‡"),
        "ldots":     MTMathAtom(type: .ordinary, value: "…"),
        "cdots":     MTMathAtom(type: .ordinary, value: "⋯"),
        "vdots":     MTMathAtom(type: .ordinary, value: "⋮"),
        "ddots":     MTMathAtom(type: .ordinary, value: "⋱"),
        "triangle":  MTMathAtom(type: .ordinary, value: "△"),
        "clubsuit":    MTMathAtom(type: .ordinary, value: "♣"),
        "diamondsuit": MTMathAtom(type: .ordinary, value: "♢"),
        "heartsuit":   MTMathAtom(type: .ordinary, value: "♡"),
        "spadesuit":   MTMathAtom(type: .ordinary, value: "♠"),
        
        // Accented latin characters
        "aa":  MTMathAtom(type: .ordinary, value: "å"),
        "ae":  MTMathAtom(type: .ordinary, value: "æ"),
        "oe":  MTMathAtom(type: .ordinary, value: "œ"),
        "o":   MTMathAtom(type: .ordinary, value: "ø"),
        "ss":  MTMathAtom(type: .ordinary, value: "ß"),
        "AA":  MTMathAtom(type: .ordinary, value: "Å"),
        "AE":  MTMathAtom(type: .ordinary, value: "Æ"),
        "OE":  MTMathAtom(type: .ordinary, value: "Œ"),
        "O":   MTMathAtom(type: .ordinary, value: "Ø"),
        "L":   MTMathAtom(type: .ordinary, value: "Ł"),
        "l":   MTMathAtom(type: .ordinary, value: "ł"),
        
        // MARK: - Spacing
        ",": MTMathSpace(space: 3),
        ">": MTMathSpace(space: 4),
        ";": MTMathSpace(space: 5),
        "!": MTMathSpace(space: -3),
        "quad":  MTMathSpace(space: 18),
        "qquad": MTMathSpace(space: 36),
        
        // MARK: - Styles
        "displaystyle":         MTMathStyle(style: .display),
        "textstyle":            MTMathStyle(style: .text),
        "scriptstyle":          MTMathStyle(style: .script),
        "scriptscriptstyle":    MTMathStyle(style: .scriptOfScript),
        
        // MARK: - Sizing commands (For manual delimiters, not fully supported yet)
        "big":   MTMathAtom(type: .ordinary, value: ""),
        "Big":   MTMathAtom(type: .ordinary, value: ""),
        "bigg":  MTMathAtom(type: .ordinary, value: ""),
        "Bigg":  MTMathAtom(type: .ordinary, value: ""),
        
        "angstrom":  MTMathAtom(type: .ordinary, value: "Å"),
    ]
	
	static var supportedAccentedCharacters: [Character: (String, String)] = [
		// Acute accents
		"á": ("acute", "a"), "é": ("acute", "e"), "í": ("acute", "i"),
		"ó": ("acute", "o"), "ú": ("acute", "u"), "ý": ("acute", "y"),
		
		// Grave accents
		"à": ("grave", "a"), "è": ("grave", "e"), "ì": ("grave", "i"),
		"ò": ("grave", "o"), "ù": ("grave", "u"),
		
		// Circumflex
		"â": ("hat", "a"), "ê": ("hat", "e"), "î": ("hat", "i"),
		"ô": ("hat", "o"), "û": ("hat", "u"),
		
		// Umlaut/dieresis
		"ä": ("ddot", "a"), "ë": ("ddot", "e"), "ï": ("ddot", "i"),
		"ö": ("ddot", "o"), "ü": ("ddot", "u"), "ÿ": ("ddot", "y"),
		
		// Tilde
		"ã": ("tilde", "a"), "ñ": ("tilde", "n"), "õ": ("tilde", "o"),
		
		// Special characters
		"ç": ("cc", ""), "ø": ("o", ""), "å": ("aa", ""), "æ": ("ae", ""),
		"œ": ("oe", ""), "ß": ("ss", ""),
		"'": ("upquote", ""),  // this may be dangerous in math mode
		
		// Upper case variants
		"Á": ("acute", "A"), "É": ("acute", "E"), "Í": ("acute", "I"),
		"Ó": ("acute", "O"), "Ú": ("acute", "U"), "Ý": ("acute", "Y"),
		"À": ("grave", "A"), "È": ("grave", "E"), "Ì": ("grave", "I"),
		"Ò": ("grave", "O"), "Ù": ("grave", "U"),
		"Â": ("hat", "A"), "Ê": ("hat", "E"), "Î": ("hat", "I"),
		"Ô": ("hat", "O"), "Û": ("hat", "U"),
		"Ä": ("ddot", "A"), "Ë": ("ddot", "E"), "Ï": ("ddot", "I"),
		"Ö": ("ddot", "O"), "Ü": ("ddot", "U"),
		"Ã": ("tilde", "A"), "Ñ": ("tilde", "N"), "Õ": ("tilde", "O"),
		"Ç": ("CC", ""),
		"Ø": ("O", ""),
		"Å": ("AA", ""),
		"Æ": ("AE", ""),
		"Œ": ("OE", ""),
	]
    
    private static let textToLatexLock = NSLock()
    static var _textToLatexSymbolName: [String: String]? = nil
    public static var textToLatexSymbolName: [String: String] {
        get {
            if self._textToLatexSymbolName == nil {
                var output = [String: String]()
                for (key, atom) in Self.supportedLatexSymbols {
                    if atom.nucleus.count == 0 {
                        continue
                    }
                    if let existingText = output[atom.nucleus] {
                        // If there are 2 key for the same symbol, choose one deterministically.
                        if key.count > existingText.count {
                            // Keep the shorter command
                            continue
                        } else if key.count == existingText.count {
                            // If the length is the same, keep the alphabetically first
                            if key.compare(existingText) == .orderedDescending {
                                continue
                            }
                        }
                    }
                    output[atom.nucleus] = key
                }
                // protect lazily loading table in a multi-thread concurrent environment
                textToLatexLock.lock()
                defer { textToLatexLock.unlock() }
                if self._textToLatexSymbolName == nil {
                    self._textToLatexSymbolName = output
                }
            }
            return self._textToLatexSymbolName!
        }
        // make textToLatexSymbolName readonly (allows internal load)
        // entries can be lazily added with NSLock protection.
        // set {
        //     self._textToLatexSymbolName = newValue
        // }
    }
    
  //  public static let sharedInstance = MTMathAtomFactory()
    
    static let fontStyles : [String: MTFontStyle] = [
        "mathnormal" : .defaultStyle,
        "mathrm": .roman,
        "textrm": .roman,
        "rm": .roman,
        "mathbf": .bold,
        "bf": .bold,
        "textbf": .bold,
        "mathcal": .caligraphic,
        "cal": .caligraphic,
        "mathtt": .typewriter,
        "texttt": .typewriter,
        "mathit": .italic,
        "textit": .italic,
        "mit": .italic,
        "mathsf": .sansSerif,
        "textsf": .sansSerif,
        "mathfrak": .fraktur,
        "frak": .fraktur,
        "mathbb": .blackboard,
        "mathbfit": .boldItalic,
        "bm": .boldItalic,
        "boldsymbol": .boldItalic,
        "mathscr": .caligraphic,
        "upgreek": .roman,
        "text": .roman,
    ]
    
    public static func fontStyleWithName(_ fontName:String) -> MTFontStyle? {
        fontStyles[fontName]
    }
    
    public static func fontNameForStyle(_ fontStyle:MTFontStyle) -> String {
        switch fontStyle {
            case .defaultStyle: return "mathnormal"
            case .roman:        return "mathrm"
            case .bold:         return "mathbf"
            case .fraktur:      return "mathfrak"
            case .caligraphic:  return "mathcal"
            case .italic:       return "mathit"
            case .sansSerif:    return "mathsf"
            case .blackboard:   return "mathbb"
            case .typewriter:   return "mathtt"
            case .boldItalic:   return "bm"
        }
    }
    
    /// Returns an atom for the multiplication sign (i.e., \times or "*")
    public static func times() -> MTMathAtom {
        MTMathAtom(type: .binaryOperator, value: UnicodeSymbol.multiplication)
    }
    
    /// Returns an atom for the division sign (i.e., \div or "/")
    public static func divide() -> MTMathAtom {
        MTMathAtom(type: .binaryOperator, value: UnicodeSymbol.division)
    }
    
    /// Returns an atom which is a placeholder square
    public static func placeholder() -> MTMathAtom {
        MTMathAtom(type: .placeholder, value: UnicodeSymbol.whiteSquare)
    }
    
    /** Returns a fraction with a placeholder for the numerator and denominator */
    public static func placeholderFraction() -> MTFraction {
        let frac = MTFraction()
        frac.numerator = MTMathList()
        frac.numerator?.add(placeholder())
        frac.denominator = MTMathList()
        frac.denominator?.add(placeholder())
        return frac
    }
    
    /** Returns a square root with a placeholder as the radicand. */
    public static func placeholderSquareRoot() -> MTRadical {
        let rad = MTRadical()
        rad.radicand = MTMathList()
        rad.radicand?.add(placeholder())
        return rad
    }
    
    /** Returns a radical with a placeholder as the radicand. */
    public static func placeholderRadical() -> MTRadical {
        let rad = MTRadical()
        rad.radicand = MTMathList()
        rad.degree = MTMathList()
        rad.radicand?.add(placeholder())
        rad.degree?.add(placeholder())
        return rad
    }
	
	public static func atom(fromAccentedCharacter ch: Character) -> MTMathAtom? {
		if let symbol = supportedAccentedCharacters[ch] {
			// first handle any special characters
			if let atom = atom(forLatexSymbol: symbol.0) {
				return atom
			}
			
			if let accent = MTMathAtomFactory.accent(withName: symbol.0) {
				// The command is an accent
				let list = MTMathList()
				let ch = Array(symbol.1)[0]
				list.add(atom(forCharacter: ch))
				accent.innerList = list
				return accent
			}
		}
		return nil
	}
    
    // MARK: -
    /** Gets the atom with the right type for the given character. If an atom
     cannot be determined for a given character this returns nil.
     This function follows latex conventions for assigning types to the atoms.
     The following characters are not supported and will return nil:
     - Any non-ascii character.
     - Any control character or spaces (< 0x21)
     - Latex control chars: $ % # & ~ '
     - Chars with special meaning in latex: ^ _ { } \
     All other characters, including those with accents, will have a non-nil atom returned.
     */
    public static func atom(forCharacter ch: Character) -> MTMathAtom? {
        let chStr = String(ch)
        
        if ch.isCJK {
            return MTMathAtom(type: .ordinary, value: chStr)
        }

        if ch.isLowerGreek || ch.isCapitalGreek {
            return MTMathAtom(type: .variable, value: chStr)
        }
        
        let subscriptDigits: [Character: Character] = ["₀":"0", "₁":"1", "₂":"2", "₃":"3", "₄":"4", "₅":"5", "₆":"6", "₇":"7", "₈":"8", "₉":"9"]
        let supscriptDigits: [Character: Character] = ["⁰":"0", "¹":"1", "²":"2", "³":"3", "⁴":"4", "⁵":"5", "⁶":"6", "⁷":"7", "⁸":"8", "⁹":"9"]
        
        if let _ = subscriptDigits[ch] {
            return MTMathAtom(type: .number, value: chStr)
        }
        if let _ = supscriptDigits[ch] {
            return MTMathAtom(type: .number, value: chStr)
        }
        if ch == "~" {
            return MTMathAtomFactory.atom(forLatexSymbol: "sim")
        }
        
        switch chStr {
            case "\u{0410}"..."\u{044F}":
				// Cyrillic alphabet
                return MTMathAtom(type: .ordinary, value: chStr)
			case _ where supportedAccentedCharacters.keys.contains(ch):
				// support for áéíóúýàèìòùâêîôûäëïöüÿãñõçøåæœß'ÁÉÍÓÚÝÀÈÌÒÙÂÊÎÔÛÄËÏÖÜÃÑÕÇØÅÆŒ
				return atom(fromAccentedCharacter: ch)
            case _ where ch.utf32Char < 0x0021 || ch.utf32Char > 0x007E:
                return nil
            case "$", "%", "#", "&", "\'", "^", "_", "{", "}", "\\":
                return nil
            case "(", "[":
                return MTMathAtom(type: .open, value: chStr)
            case ")", "]", "!", "?":
                return MTMathAtom(type: .close, value: chStr)
            case ",", ";":
                return MTMathAtom(type: .punctuation, value: chStr)
            case "=", ">", "<":
                return MTMathAtom(type: .relation, value: chStr)
            case ":":
                // Math colon is ratio. Regular colon is \colon
                return MTMathAtom(type: .relation, value: "\u{2236}")
            case "-":
                return MTMathAtom(type: .binaryOperator, value: "\u{2212}")
            case "+", "*":
                return MTMathAtom(type: .binaryOperator, value: chStr)
            case ".":
                return MTMathAtom(type: .punctuation, value: chStr)
            case "0"..."9":
                return MTMathAtom(type: .number, value: chStr)
            case "a"..."z", "A"..."Z":
                return MTMathAtom(type: .variable, value: chStr)
            case "\"", "/", "@", "`", "|":
                return MTMathAtom(type: .ordinary, value: chStr)
            default:
                if !ch.isControl && !ch.isWhitespace {
                     return MTMathAtom(type: .ordinary, value: String(ch))
                }
                //assertionFailure("Unknown ASCII character '\(ch)'. Should have been handled earlier.")
                return nil
        }
    }
    
    /** Returns a `MTMathList` with one atom per character in the given string. This function
     does not do any LaTeX conversion or interpretation. It simply uses `atom(forCharacter:)` to
     convert the characters to atoms. Any character that cannot be converted is ignored. */
    public static func atomList(for string: String) -> MTMathList {
        let list = MTMathList()
        for character in string {
            if let newAtom = atom(forCharacter: character) {
                list.add(newAtom)
            }
        }
        return list
    }
    
    /** Returns an atom with the right type for a given latex symbol (e.g. theta)
     If the latex symbol is unknown this will return nil. This supports LaTeX aliases as well.
     */
    public static func atom(forLatexSymbol name: String) -> MTMathAtom? {
        var name = name
        if let canonicalName = aliases[name] {
            name = canonicalName
        }
        if let atom = supportedLatexSymbols[name] {
            return atom.copy()
        }
        return nil
    }
    
    /** Finds the name of the LaTeX symbol name for the given atom. This function is a reverse
     of the above function. If no latex symbol name corresponds to the atom, then this returns `nil`
     If nucleus of the atom is empty, then this will return `nil`.
     Note: This is not an exact reverse of the above in the case of aliases. If an LaTeX alias
     points to a given symbol, then this function will return the original symbol name and not the
     alias.
     Note: This function does not convert MathSpaces to latex command names either.
     */
    public static func latexSymbolName(for atom: MTMathAtom) -> String? {
        guard !atom.nucleus.isEmpty else { return nil }
        return Self.textToLatexSymbolName[atom.nucleus]
    }
    
    /** Define a latex symbol for rendering. This function allows defining custom symbols that are
     not already present in the default set, or override existing symbols with new meaning.
     e.g. to define a symbol for "lcm" one can call:
     `MTMathAtomFactory.add(latexSymbol:"lcm", value:MTMathAtomFactory.operatorWithName("lcm", limits: false))` */
    public static func add(latexSymbol name: String, value: MTMathAtom) {
        let _ = Self.textToLatexSymbolName
        // above force textToLatexSymbolName to initialise first, _textToLatexSymbolName also initialized.
        // protect lazily loading table in a multi-thread concurrent environment
        textToLatexLock.lock()
        defer { textToLatexLock.unlock() }
        supportedLatexSymbols[name] = value
        Self._textToLatexSymbolName?[value.nucleus] = name
    }
    
    /** Returns a large opertor for the given name. If limits is true, limits are set up on
     the operator and displayed differently. */
    public static func operatorWithName(_ name: String, limits: Bool) -> MTLargeOperator {
        MTLargeOperator(value: name, limits: limits)
    }
    
    /** Returns an accent with the given name. The name of the accent is the LaTeX name
     such as `grave`, `hat` etc. If the name is not a recognized accent name, this
     returns nil. The `innerList` of the returned `MTAccent` is nil.
     */
    public static func accent(withName name: String) -> MTAccent? {
        if let accentValue = accents[name] {
            return MTAccent(value: accentValue)
        }
        return nil
    }
    
    /** Returns the accent name for the given accent. This is the reverse of the above
     function. */
    public static func accentName(_ accent: MTAccent) -> String? {
        accentValueToName[accent.nucleus]
    }
    
    /** Creates a new boundary atom for the given delimiter name. If the delimiter name
     is not recognized it returns nil. A delimiter name can be a single character such
     as '(' or a latex command such as 'uparrow'.
     @note In order to distinguish between the delimiter '|' and the delimiter '\|' the delimiter '\|'
     the has been renamed to '||'.
     */
    public static func boundary(forDelimiter name: String) -> MTMathAtom? {
        if let delimValue = Self.delimiters[name] {
            return MTMathAtom(type: .boundary, value: delimValue)
        }
        return nil
    }
    
    /** Returns the delimiter name for a boundary atom. This is a reverse of the above function.
     If the atom is not a boundary atom or if the delimiter value is unknown this returns `nil`.
     @note This is not an exact reverse of the above function. Some delimiters have two names (e.g.
     `<` and `langle`) and this function always returns the shorter name.
     */
    public static func getDelimiterName(of boundary: MTMathAtom) -> String? {
        guard boundary.type == .boundary else { return nil }
        return Self.delimValueToName[boundary.nucleus]
    }
    
    /** Returns a fraction with the given numerator and denominator. */
    public static func fraction(withNumerator num: MTMathList, denominator denom: MTMathList) -> MTFraction {
        let frac = MTFraction()
        frac.numerator = num
        frac.denominator = denom
        return frac
    }
    
    public static func mathListForCharacters(_ chars:String) -> MTMathList? {
        let list = MTMathList()
        for ch in chars {
            if let atom = self.atom(forCharacter: ch) {
                list.add(atom)
            }
        }
        return list
    }
    
    /** Simplification of above function when numerator and denominator are simple strings.
     This function converts the strings to a `MTFraction`. */
    public static func fraction(withNumeratorString numStr: String, denominatorString denomStr: String) -> MTFraction {
        let num = Self.atomList(for: numStr)
        let denom = Self.atomList(for: denomStr)
        return Self.fraction(withNumerator: num, denominator: denom)
    }
    

    static let matrixEnvs = [
        "matrix": [],
        "pmatrix": ["(", ")"],
        "bmatrix": ["[", "]"],
        "Bmatrix": ["{", "}"],
        "vmatrix": ["vert", "vert"],
        "Vmatrix": ["Vert", "Vert"]
    ]
    
    /** Builds a table for a given environment with the given rows. Returns a `MTMathAtom` containing the
     table and any other atoms necessary for the given environment. Returns nil and sets error
     if the table could not be built.
     @param env The environment to use to build the table. If the env is nil, then the default table is built.
     @note The reason this function returns a `MTMathAtom` and not a `MTMathTable` is because some
     matrix environments are have builtin delimiters added to the table and hence are returned as inner atoms.
     */
    public static func table(withEnvironment env: String?, rows: [[MTMathList]], error:inout NSError?) -> MTMathAtom? {
        let table = MTMathTable(environment: env)
        
        for i in 0..<rows.count {
            let row = rows[i]
            for j in 0..<row.count {
                table.set(cell: row[j], forRow: i, column: j)
            }
        }
        
        if env == nil {
            table.interColumnSpacing = 0
            table.interRowAdditionalSpacing = 1
            for i in 0..<table.numColumns {
                table.set(alignment: .left, forColumn: i)
            }
            return table
        } else if let env = env {
            if let delims = matrixEnvs[env] {
                table.environment = "matrix"
                table.interRowAdditionalSpacing = 0
                table.interColumnSpacing = 18
                
                let style = MTMathStyle(style: .text)
                
                for i in 0..<table.cells.count {
                    for j in 0..<table.cells[i].count {
                        table.cells[i][j].insert(style, at: 0)
                    }
                }
                
                if delims.count == 2 {
                    let inner = MTInner()
                    inner.leftBoundary = Self.boundary(forDelimiter: delims[0])
                    inner.rightBoundary = Self.boundary(forDelimiter: delims[1])
                    inner.innerList = MTMathList(atoms: [table])
                    return inner
                } else {
                    return table
                }
            } else if env == "eqalign" || env == "split" || env == "aligned" || env == "alignedat" || env == "align" || env == "align*" {
                if table.numColumns > 2 { // A row can have 1 or 2 columns
                    let message = "\(env) environment can only have 2 columns"
                    if error == nil {
                        error = NSError(domain: MTParseError, code: MTParseErrors.invalidNumColumns.rawValue, userInfo: [NSLocalizedDescriptionKey:message])
                    }
                    return nil
                }
                
                let spacer = MTMathAtom(type: .ordinary, value: "")
                
                for i in 0..<table.cells.count {
                    if table.cells[i].count >= 2 {
                        table.cells[i][1].insert(spacer, at: 0)
                    }
                }
                
                table.interRowAdditionalSpacing = 1
                table.interColumnSpacing = 0
                
                table.set(alignment: .right, forColumn: 0)
                table.set(alignment: .left, forColumn: 1)
                
                return table
            } else if env == "displaylines" || env == "gather" || env == "gathered" {
                if table.numColumns != 1 {
                    let message = "\(env) environment can only have 1 column"
                    if error == nil {
                        error = NSError(domain: MTParseError, code: MTParseErrors.invalidNumColumns.rawValue, userInfo: [NSLocalizedDescriptionKey:message])
                    }
                    return nil
                }
                
                table.interRowAdditionalSpacing = 1
                table.interColumnSpacing = 0
                
                table.set(alignment: .center, forColumn: 0)
                
                return table
            } else if env == "eqnarray" {
                if table.numColumns != 3 {
                    let message = "\(env) environment can only have 3 columns"
                    if error == nil {
                        error = NSError(domain: MTParseError, code: MTParseErrors.invalidNumColumns.rawValue, userInfo: [NSLocalizedDescriptionKey:message])
                    }
                    return nil
                }
                
                table.interRowAdditionalSpacing = 1
                table.interColumnSpacing = 18
                
                table.set(alignment: .right, forColumn: 0)
                table.set(alignment: .center, forColumn: 1)
                table.set(alignment: .left, forColumn: 2)
                
                return table
            } else if env == "cases" {
                /*if table.numColumns != 2 {
                    let message = "cases environment can only have 2 columns"
                    if error == nil {
                        error = NSError(domain: MTParseError, code: MTParseErrors.invalidNumColumns.rawValue, userInfo: [NSLocalizedDescriptionKey:message])
                    }
                    return nil
                }*/
                
                table.interRowAdditionalSpacing = 0
                table.interColumnSpacing = 18
                
                table.set(alignment: .left, forColumn: 0)
                table.set(alignment: .left, forColumn: 1)
                
                let style = MTMathStyle(style: .text)
                for i in 0..<table.cells.count {
                    for j in 0..<table.cells[i].count {
                        table.cells[i][j].insert(style, at: 0)
                    }
                }
                
                let inner = MTInner()
                inner.leftBoundary = Self.boundary(forDelimiter: "{")
                inner.rightBoundary = Self.boundary(forDelimiter: ".")
                let space = Self.atom(forLatexSymbol: ",")!
                
                inner.innerList = MTMathList(atoms: [space, table])
                
                return inner
            } else if env == "array" {
                // array 环境需要一个额外的参数来定义列对齐方式，例如 {rcl}
                // 当前的 MTMathListBuilder 不支持解析这个参数。
                // 这是一个高级功能，需要扩展 MTMathListBuilder.readEnvironment()
                // 来读取并传递这个对齐字符串。
                
                // 简化版实现：假设默认对齐
                // 我们需要一个方法来解析 {lcr} 参数
                // let alignments = parseAlignments(envParameter) // 伪代码
                // for i in 0..<alignments.count {
                //     table.set(alignment: alignments[i], forColumn: i)
                // }
                
                // 目前，我们可以暂时将其视为一个居中对齐的表格
                table.interColumnSpacing = 18 // 1em
                for i in 0..<table.numColumns {
                    table.set(alignment: .center, forColumn: i)
                }
                return table
            } else {
                let message = "Unknown environment \(env)"
                error = NSError(domain: MTParseError, code: MTParseErrors.invalidEnv.rawValue, userInfo: [NSLocalizedDescriptionKey:message])
                return nil
            }
        }
        return nil
    }
}
