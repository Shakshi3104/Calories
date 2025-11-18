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
    /// Advice about dietary
    var dietatySuggestion: String
    /// Advice about exercise
    var exerciseSuggestion: String
    /// Overall comment
    var generalComment: String
}
