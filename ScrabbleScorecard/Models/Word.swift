//
//  Word.swift
//  ScrabbleScorecard
//
//  Created by Steven Chen on 2020-06-08.
//  Copyright © 2020 Steven Chen. All rights reserved.
//

import SwiftUI
import CoreLocation

struct Word: Hashable, Codable, Identifiable {
    var id: Int
    var word: String
    var rawScore: Int
    var multiplier: Int
}
