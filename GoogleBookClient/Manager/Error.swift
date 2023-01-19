//
//  Error.swift
//  GoogleBookClient
//
//  Created by Aleksei Grachev on 18/1/23.
//

import Foundation

enum JSONError: Error {
    case InvalidURL(String)
    case InvalidKey(String)
    case InvalidArray(String)
    case InvalidData
    case InvalidImage
    case indexOutOfRange
}
