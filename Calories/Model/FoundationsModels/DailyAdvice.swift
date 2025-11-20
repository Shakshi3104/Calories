//
//  DailyAdvice.swift
//  Calories
//
//  Created by Mac mini M2 Pro on 2025/11/14.
//

import Foundation
import FoundationModels

@available(iOS 26.0, *)
@Generable
struct DailyAdvice {
    /// Overall comment
    var generalComment: String
    /// Advice about dietary
    var dietarySuggestion: String
    /// Advice about exercise
    var exerciseSuggestion: String
}
