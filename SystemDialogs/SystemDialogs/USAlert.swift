//
//  USAlert.swift
//  SystemDialogs
//
//  Created by Albertus Liberius on 14/07/2019.
//  Copyright © 2019 Albertus Liberius. All rights reserved.
//

import Foundation
#if canImport(AppKit)
import Cocoa
#elseif os(watchOS)
import WatchKit
#else
import UIKit

fileprivate extension UIView{
    static private func findParentResponder(responder: UIResponder) -> UIViewController?{
        if responder is UIViewController{
            return responder as? UIViewController
        }else{
            if let next = responder.next{
                return findParentResponder(responder: next)
            }else{
                return nil
            }
        }
    }
    var viewController: UIViewController?{
        return UIView.findParentResponder(responder: self)
    }
}

#endif

protocol USAlertActionProtocol{
    associatedtype OriginType
    var origin : OriginType? {get}
    typealias Handler = (() -> Void)
    var handler: Handler? {get}
    typealias Style = USAlertActionStyle
    var style: Style {get}
    var title: String {get}
    static var canDisable : Bool {get}
    var isEnabled: Bool {get set}
    
    init(title: String, style: Style, handler: Handler?)
}

#if canImport(AppKit)
enum USAlertActionStyle{
    case `default`
    case cancel
    case destructive
}
#elseif os(watchOS)
typealias USAlertActionStyle = WKAlertActionStyle
#else
typealias USAlertActionStyle = UIAlertAction.Style
#endif

protocol USAlertProtocol{
    associatedtype Action: USAlertActionProtocol
    func addAction(_ action: Action)
    var actions: [Action] {get}
    var preferredAction: Action? {get set}
    
    var title: String? {get}
    var message: String? {get}
    typealias Style = USAlertStyle
    var style: Style {get}
    
    func present(host: Any?)
    
    init(title: String?, message: String?, style: Style)
}

enum USAlertStyle{
    case sheet
    case appModal
    case `default`
}

class USAlertAction: USAlertActionProtocol{
    
    #if canImport(AppKit)
    typealias OriginType = NSButton
    #elseif os(watchOS)
    typealias OriginType = WKAlertAction
    #else
    typealias OriginType = UIAlertAction
    #endif
    
    public fileprivate(set) var origin: OriginType? = nil
    let handler: Handler?
    let style: Style
    let title: String
    
    #if os(watchOS)
    static let canDisable: Bool = false
    var isEnabled: Bool{
        get{
            return true
        }set(newValue){}
    }
    #else
    static let canDisable: Bool = true
    var isEnabled: Bool = true{
        didSet{
            origin?.isEnabled = self.isEnabled
        }
    }
    #endif
    
    required init(title: String, style: Style = .default, handler: Handler? = nil)
    {
        self.handler = handler
        self.style = style
        self.title = title
    }
    
    static var cancelString: String{
        switch Locale.current.languageCode{
        case "ja":                  return "キャンセル"
        case "ko":                  return "취소"
        case "zh", "wuu", "yue":    return "取消"
        case "ii":                  return "ꉃ"
        case "fr":                  return "Annuler"
        case "es", "pt":            return "Cancelar"
        case "ar":                  return "إلغاء"
        case "tr":                  return "İptal"
        case "ru":                  return "Отмена"
        case "uz":                  return "Bekor qilish"
        default:                    return "Cancel"
        }
    }
    static var okString: String{
        switch Locale.current.languageCode{
        case "ko":                  return "확인"
        case "zh", "wuu", "yue":    return "好"
        case "ii":                  return "ꉐ"
        case "ar":                  return "حسنا"
        case "tr":                  return "Tamam"
        default:                    return "OK"
        }
    }
    static var dismissString: String{
        switch Locale.current.languageCode{
        case "ko":                  return "닫기"
        case "ja":                  return "閉じる"
        case "zh", "wuu", "yue":    return "关闭"
        case "ii":                  return "ꈢ₁"
        case "fr":                  return "Fermer"
        case "es":                  return "Cerrar"
        case "pt":                  return "Perto"
        case "ar":                  return "لإغلاق"
        case "tr":                  return "Kapat"
        case "ru":                  return "Закрыть"
        case "uz":                  return "Yopmoq"
        default:                    return "Dismiss"
        }
    }
    static var closeString: String{
        switch Locale.current.languageCode{
        case "ko":                  return "닫기"
        case "ja":                  return "閉じる"
        case "zh", "wuu", "yue":    return "关闭"
        case "ii":                  return "ꈢ₁"
        case "fr":                  return "Fermer"
        case "es":                  return "Cerrar"
        case "pt":                  return "Perto"
        case "ar":                  return "لإغلاق"
        case "tr":                  return "Kapat"
        case "ru":                  return "Закрыть"
        case "uz":                  return "Yopmoq"
        default:                    return "Close"
        }
    }
    static var confirmString: String{
        switch Locale.current.languageCode{
        case "ko":                  return "확인"
        case "ja":                  return "確認"
        case "zh", "wuu", "yue":    return "确认"
        case "ii":                  return "ꍤ"
        case "fr":                  return "Confirmer"
        case "es":                  return "Confirmar"
        case "pt":                  return "Confirme"
        case "sv":                  return "Bekräfta"
        case "ar":                  return "أكد"
        case "uz":                  return "Tasdiqlash"
        case "ru":                  return "Подтвердить"
        default:                    return "Confirm"
        }
    }
    static var notNowString: String{
        switch Locale.current.languageCode{
        case "ko":                  return "지금 안 함"
        case "ja":                  return "今はしない"
        case "zh", "wuu", "yue":    return "以后再说"
        case "es":                  return "Ahora no"
        case "pt":                  return "Agora não"
        case "sv":                  return "Inte nu"
        case "ar":                  return "ليس الان"
        case "ii":                  return "ꀱꇈꉈ"
        case "uz":                  return "Xozir emas"
        case "ru":                  return "Не сейчас"
        default:                    return "Not Now"
        }
    }
    static var allowString: String{
        switch Locale.current.languageCode{
        case "ko": return "허용"
        case "ja": return "許可"
        case "zh", "wuu", "yue": return "允许"
        case "ii": return "ꈌꁧ"
        case "fr": return "Autoriser"
        case "ar":  return "سمح"
        case "uz": return "Ruxsat ber"
        case "ru": return "Разрешать"
        default: return "Allow"
        }
    }
    static var dontAllowString: String{
        switch Locale.current.languageCode{
        case "ko": return "허용하지 않음"
        case "ja": return "許可しない"
        case "zh", "wuu", "yue": return "不允许"
        case "ii": return "ꎝ"
        case "fr": return "Refuser"
        case "ar":  return "لا تسمح"
        case "uz": return "Ruxsat bermang"
        case "ru": return "Не разрешать"
        default: return "Don't Allow"
        }
    }
    static var trustString: String{
        switch Locale.current.languageCode{
        case "ko": return "신뢰"
        case "ja": return "信頼"
        case "zh", "wuu", "yue": return "信任"
        case "fr": return "Se fier"
        case "ii": return "ꉈꊋ"
        case "uz": return "Ishonch"
        case "ru": return "Доверять"
        default: return "Trust"
        }
    }
    static var dontTrustString: String{
        switch Locale.current.languageCode{
        case "ko": return "신뢰하지 않음"
        case "ja": return "信頼しない"
        case "zh", "wuu", "yue": return "不信任"
        case "fr": return "Ne pas se fier"
        case "ii": return "ꀋꉈꊋ"
        case "uz": return "Ishonmang"
        case "ru": return "Не верь"
        default: return "Don't Trust"
        }
    }
    
    static var updateString: String{
        switch Locale.current.languageCode{
        case "ko": return "업데이트"
        case "ja": return "アップデート"
        case "zh", "wuu", "yue": return "更新"
        case "fr": return "Mise à jour"
        case "ii": return "ꀋꉈꊋ"
        case "uz": return "Ishonmang"
        case "ru": return "Не верь"
        default: return "Update"
        }
    }
    
    static var deleteString: String{
        switch Locale.current.languageCode{
        case "zh", "wuu", "yue": return "删除"
        default: return "Delete"
        }
    }
    static func deleteString(items: UInt) -> String{
        let numStr: String = NumberFormatter().string(from: NSNumber(value: items)) ?? String(format:"%d",items)
        
        switch Locale.current.languageCode{
        case "ko": return numStr+"개 삭제"
        case "ja": return numStr+"個削除"
        case "zh", "wuu", "yue": return "删除"+numStr+"项"
        default: return "Delete " + numStr + " items"
        }
    }
    
    
    static let cancel = USAlertAction(title: cancelString, style: .cancel)
    static let ok = USAlertAction(title: okString, style: .default)
    static let dismiss = USAlertAction(title: dismissString, style: .cancel)
    static let close = USAlertAction(title: closeString, style: .cancel)
    static let confirm = USAlertAction(title: confirmString, style: .default)
    static let allow = USAlertAction(title: allowString, style: .default)
    static let dontAllow = USAlertAction(title: dontAllowString, style: .cancel)
    static let trust = USAlertAction(title: trustString, style: .default)
    static let dontTrust = USAlertAction(title: dontTrustString, style: .cancel)
    static let update = USAlertAction(title: updateString, style: .default)

    
}

class USAlert: USAlertProtocol{
    
    typealias Action = USAlertAction
    
    #if canImport(AppKit)
    private var origin : NSAlert
    #elseif os(watchOS)
    #else
    private var origin : UIAlertController
    #endif
    
    public private(set) var actions: [Action] = []
    
    func addAction(_ action: USAlertAction){
        #if canImport(AppKit)
        action.origin = self.origin.addButton(withTitle: action.title)
        action.origin?.isEnabled = action.isEnabled
        if action.style == .cancel{
            action.origin?.keyEquivalent = "\u{1b}"
        }
        #elseif os(watchOS)
        action.origin = WKAlertAction(title: action.title, style: action.style, handler: {action.handler?()})
        #else
        action.origin = UIAlertAction(title: action.title, style: action.style, handler: {(uiAction) in action.handler?()})
        action.origin?.isEnabled = action.isEnabled
        self.origin.addAction(action.origin!)
        #endif
        
        actions.append(action)
    }
    var preferredAction: Action? {
        get{
            #if canImport(AppKit)
            return self.actions.first(where: {(action) in action.origin?.keyEquivalent == "\r" && action.origin?.keyEquivalentModifierMask == NSEvent.ModifierFlags()})
            #elseif os(watchOS)
            return nil
            #else
            return self.actions.first(where: {(action) in action.origin === self.origin.preferredAction})
            #endif
        }set(newValue){
            if let action = self.actions.first(where: {(action) in action === newValue}){
                #if canImport(AppKit)
                action.origin?.keyEquivalent = "\r"
                action.origin?.keyEquivalentModifierMask = NSEvent.ModifierFlags()
                #elseif os(watchOS)
                #else
                self.origin.preferredAction = newValue?.origin ?? nil
                #endif
            }
        }
    }
    
    let title: String?
    let message: String?
    let style: Style
    
    required init(title: String? = nil, message: String? = nil, style: Style = .default){
        self.style = style
        self.title = title
        self.message = message
        #if canImport(AppKit)
        origin = NSAlert()
        #elseif os(watchOS)
        #else
        origin = UIAlertController(title: title, message: message, preferredStyle: style == .sheet ? .actionSheet : .alert)
        #endif
    }
    
    var isDestructive: Bool{
        return self.actions.contains(where: {(action) in action.style == .destructive})
    }
    
    func present(host: Any? = nil){
        //MARK: MacOS
        #if canImport(AppKit)
        var isSheet = self.style != .appModal
        var parent : NSWindow? = host as? NSWindow
        if parent == nil{
            if host is NSWindowController{
                parent = (host as? NSWindowController)?.window
            }else if host is NSView{
                parent = (host as? NSView)?.window
            }else{
                parent = nil
            }
        }
        if parent == nil{
            isSheet = false
        }
        let completionHandler: ((NSApplication.ModalResponse) -> Void) = {response in
            var resultNum: Int
            switch response{
            case .alertFirstButtonReturn:
                resultNum = 0
            case .alertSecondButtonReturn:
                resultNum = 1
            default:
                resultNum = response.rawValue - NSApplication.ModalResponse.alertThirdButtonReturn.rawValue + 2
            }
            self.actions[resultNum].handler?()
        }
        if isSheet{
            self.origin.beginSheetModal(for: parent!, completionHandler: completionHandler)
        }else{
            completionHandler(self.origin.runModal())
        }
        
        // MARK: WatchOS
        #elseif os(watchOS)
        var parent: WKInterfaceController? = WKExtension.shared().visibleInterfaceController ?? WKExtension.shared().rootInterfaceController
        if host is WKInterfaceController{
            parent = host as? WKInterfaceController
        }
        let rawActions: [WKAlertAction] = self.actions.map{$0.origin!}
        var num : WKAlertControllerStyle = .actionSheet
        if self.style != .sheet{
            if rawActions.count <= 1{
                num = .alert
            }else if rawActions.count == 2{
                num = .sideBySideButtonsAlert
            }
        }
        parent?.presentAlert(withTitle: self.title, message: self.message, preferredStyle: num, actions: rawActions)
        
        // MARK: iOS iPadOS tvOS
        #else
        var parent: UIViewController? = host as? UIViewController
        if parent == nil{
            parent = (host as? UIView)?.viewController
        }
        if parent == nil{
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.rootViewController = UIViewController()
            window.windowLevel = .alert + 1
            window.makeKeyAndVisible()
            parent = window.rootViewController
        }
        // Reconstruct UIAlertController with new preferredStyle (only for broken part)
        if self.style == .sheet || self.style == .default && self.isDestructive{
            let oldPreferred = self.preferredAction
            self.origin = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            for action in self.actions{
                self.origin.addAction(action.origin!)
            }
            self.origin.preferredAction = oldPreferred?.origin
        }
        parent?.present(self.origin, animated: true, completion: nil)
        
        #endif
        
    }
}
