//
//  ProtoBodyExtension.swift
//  Client
//
//  Created by Paul Pinter on 25.04.23.
//

import Foundation
import Logging
import Shared

extension ProtoBody {
  func toJSONString() -> String? {
    let msg = self.createMsg()

    do {
      let json = try JSONEncoder().encode(msg)
      return String(data: json, encoding: .utf8)
    }
    catch {
      return nil
    }
  }
}

extension String {
  func toProtoMsg() -> ProtocolMsg? {
    let data = self.data(using: .utf8)!
    let decoder = JSONDecoder()
    do {
      let msg = try decoder.decode(ProtocolMsg.self, from: data)
      return msg
    }
    catch {
      return nil
    }
  }

}
