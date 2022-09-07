//
//  StringExtension.swift
//  HangulTop
//
//  Created by Seulki Lee on 2022/09/07.
//

import Foundation
 
extension String {
  var localized: String {
    return NSLocalizedString(self, comment: "")
  }
}
