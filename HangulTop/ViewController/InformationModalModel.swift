//
//  InformationModalModel.swift
//  HangulTop
//
//  Created by Seulki Lee on 2022/07/29.
//

import UIKit

struct InformationModalModel {
    
    let titleArray: [String] = [
        "velarSound".localized, "lingualSound".localized, "labialSound".localized, "dentalSound".localized, "gutturalSound".localized
    ]
    
    let infoArray: [String] = [
        "velarSoundExplanation".localized, "lingualSoundExplanation".localized, "labialSoundExplanation".localized, "dentalSoundExplanation".localized, "gutturalSoundExplanation".localized
    ]
    
    let lettersArray: [[String]] = [
        ["ㄱ", "ㅋ", "ㄲ"], ["ㄴ", "ㄷ", "ㅌ", "ㄹ", "ㄸ"], ["ㅁ", "ㅂ", "ㅍ", "ㅃ"], ["ㅅ", "ㅈ", "ㅊ", "ㅉ", "ㅆ"], ["ㅇ", "ㅎ"]
    ]
    
    let imageArray: [String] = ["ㄱ", "ㄴ", "ㅁ", "ㅅ", "ㅇ"]
}
