//
//  Result.swift
//  MCFBChat
//
//  Created by Gabriel Araujo on 02/12/16.
//
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}
