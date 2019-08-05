//
//  USAlertDefaultActions.swift
//  SystemDialogs
//
//  Created by Albertus Liberius on 04/08/2019.
//  Copyright © 2019 Albertus Liberius. All rights reserved.
//

import Foundation


extension String{
    var 받침: Bool{
        let separado = CharacterSet.controlCharacters.union(.punctuationCharacters).union(.whitespacesAndNewlines)
        let 껍질벗음 = self.trimmingCharacters(in: separado)
        let 마지막단어 = 껍질벗음.components(separatedBy: separado).last
        let 마지막자모: UInt32? = 마지막단어?.decomposedStringWithCompatibilityMapping.last?.unicodeScalars.last?.value
        guard let _ = 마지막자모 else{
            return false
        }
        return UInt32(0x11A8)...UInt32(0x11FF) ~= 마지막자모!
    }
}


extension USAlertAction{
    static func activateString(item: String) -> String{
        switch Locale.current.languageCode{
        case "ja": return "を" + activateString
        case "ko":
            if item.받침{
                return "을 " + activateString
            }else{
                return "를 " + activateString
            }
        default: return activateString + " " + item
        }
    }
    static func deactivateString(item: String) -> String{
        switch Locale.current.languageCode{
        case "ja": return "を" + deactivateString
        case "ko":
            if item.받침{
                return "을 " + activateString
            }else{
                return "를 " + activateString
            }
        default: return deactivateString + " " + item
        }
    }
}
