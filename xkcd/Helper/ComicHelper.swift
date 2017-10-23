//
//  ComicHelper.swift
//  xkcd
//
//  Created by Kevin Cleathero on 2017-08-15.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

import Foundation

class ComicHelper {

    class func randomNumber<T : SignedInteger>(inRange range: ClosedRange<T> = 1...6) -> T {
        let length = (range.upperBound - range.lowerBound + 1).toIntMax()
        let value = arc4random().toIntMax() % length + range.lowerBound.toIntMax()
        return T(value)
    }

}
