//
//  Util.swift
//  Swissy
//
//  Created by Tamas Bara on 15.11.18.
//  Copyright © 2018 Tamas Bara. All rights reserved.
//

import Foundation

func delay(closure: @escaping () -> Void, after: DispatchTimeInterval) {
    DispatchQueue.main.asyncAfter(deadline: .now() + after) {
        closure()
    }
}

func main(closure: @escaping () -> Void) {
    
    guard Thread.current.isMainThread == false else {
        closure()
        return
    }
    
    DispatchQueue.main.sync {
        closure()
    }
}
