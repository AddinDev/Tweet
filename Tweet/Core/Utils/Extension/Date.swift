//
//  Date.swift
//  Tweet
//
//  Created by addin on 17/06/21.
//

import Foundation

extension Date {
  func getFormattedDate(format: String) -> String {
    let dateformat = DateFormatter()
    dateformat.dateFormat = format
    return dateformat.string(from: self)
  }
}
