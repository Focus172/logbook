//
//  Extensions.swift
//  Logbook
//
//  Created by Evan Stokdyk on 1/10/23.
//  Copyright © 2023 NexThings. All rights reserved.
//

import Foundation
import CommonCrypto
import FirebaseFirestore

extension String {

  /*
  func fromBase64() -> String? {
    guard let data = Data(base64Encoded: self) else {
        return nil
    }

    return String(data: data, encoding: .utf8)
  }

  func toBase64() -> String {
    return Data(self.utf8).base64EncodedString()
  }
   */
  
  func sha256() -> String {
    if let stringData = self.data(using: String.Encoding.utf8) {
      return stringData.sha256()
    }
    return ""
  }
}

extension Data {
  
  public func sha256() -> String{
    return hexStringFromData(input: digest(input: self as NSData))
  }
  
  private func digest(input : NSData) -> NSData {
    let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
    var hash = [UInt8](repeating: 0, count: digestLength)
    CC_SHA256(input.bytes, UInt32(input.length), &hash)
    return NSData(bytes: hash, length: digestLength)
  }
  
  private func hexStringFromData(input: NSData) -> String {
    var bytes = [UInt8](repeating: 0, count: input.length)
    input.getBytes(&bytes, length: input.length)
    
    var hexString = ""
    for byte in bytes {
        hexString += String(format:"%02x", UInt8(byte))
    }
    
    return hexString
  }
}

extension DocumentReference : Identifiable {
  
}

extension Result : Identifiable {
  public var id: ObjectIdentifier {
    ObjectIdentifier(Result.self)
  }
}

extension UserPreview: Identifiable {
  public var id: ObjectIdentifier {
    ObjectIdentifier(UserPreview.self)
  }
}

