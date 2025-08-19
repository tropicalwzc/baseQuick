//
//  string+base64.swift
//  baseQuick
//
//  Created by wangzicheng on 2025/8/19.
//

import Foundation
import SwiftUI

public extension String {

    @inlinable
    func fromBase64() -> String? {
        Data(base64Encoded: self)
            .flatMap { String(data: $0, encoding: .utf8) }
    }

    @inlinable
    func toBase64() -> String {
        Data(self.utf8).base64EncodedString()
    }
}
