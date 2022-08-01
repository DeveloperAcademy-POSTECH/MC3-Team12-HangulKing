//
//  QuizViewController.swift
//  HangulTop
//
//  Created by kimjimin on 2022/07/25.
//
import UIKit
import AVFoundation

class QuizViewController: UIViewController {
    var quizs = [[String]]()
    var answers = [String]()
    var selectedButton: UIButton?
    var pageNum = 0
    
    @IBOutlet weak var quizPage: UIView!
    @IBOutlet weak var lastPage: UIView!
    @IBOutlet var answerButtons: [UIButton]!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var quizIndex: UILabel!
    @IBOutlet weak var progressBar: PlainHorizontalProgressBar!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var checkbutton: UIButton!
    @IBOutlet weak var quizCount: UILabel!
    var count: Int = 0
    //MARK: - 버튼액션
    @IBAction func buttonAction(_ sender: UIButton) {
        checkbutton.setTitleColor(.black, for: .normal)
        for button in buttons {
            if button == sender {
                selectedButton = button
                button.layer.borderWidth = 5
                button.layer.borderColor = UIColor(r: 107, g: 203, b: 159).cgColor
            } else {
                button.layer.borderWidth = 0
            }
        }
    }
    
    @IBAction func checkbuttonAction(_ sender: Any) {
        if selectedButton != nil {
            if selectedButton?.titleLabel?.text == answers[pageNum] {
                selectedButton = nil
                checkbutton.backgroundColor = UIColor(r: 107, g: 203, b: 159)
                checkbutton.setTitle("Correct!", for: .normal)
                selectedButton?.backgroundColor = UIColor(r: 107, g: 203, b: 159)
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer) in
                    self.pageNum += 1
                    self.progressBar.progress += 0.1
                    self.quizUpdate()
                    self.buttonReset()
                }
            } else {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
                checkbutton.backgroundColor = UIColor(r: 237, g: 123, b: 115)
                checkbutton.setTitle("Try again...", for: .normal)
                selectedButton?.layer.borderColor = UIColor(r: 237, g: 123, b: 115).cgColor
                selectedButton?.backgroundColor =  UIColor(r: 237, g: 123, b: 115)
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer) in
                    self.buttonReset()
                }
            }
        }
    }
    
    @IBAction func finishButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: - 페이지 업데이트
    func quizUpdate() {
        if pageNum == 10 {
            quizPage.isHidden = true
            lastPage.isHidden = false
            var count: Int
            if(UserDefaults.standard.value(forKey: "solCount") == nil){
                count = 0
            }else{
                count = UserDefaults.standard.value(forKey: "solCount") as! Int
            }
            count = count + 1
            UserDefaults.standard.set(count, forKey: "solCount")
            if(UserDefaults.standard.value(forKey: "solCount") == nil){
                count = 0
            }else{
                count = UserDefaults.standard.value(forKey: "solCount") as! Int
            }
            quizCount.text = "지금까지 푼 문제는 \(count * 10)문제 입니다."
        } else {
            for i in 0..<4 {
                buttons[i].setTitle(quizs[pageNum][i], for: .normal)
            }
            if pageNum == 0 || pageNum == 1 || pageNum == 2 {
                level.text = "lv 1. Vowel"
            } else if pageNum == 7 || pageNum == 8 || pageNum == 9 {
                level.text = "lv 3. Batchim"
            } else {
                level.text = "lv 2. Consonant"
            }
            quizIndex.text = "\(pageNum+1) / 10"
        }
    }
    
    func buttonReset() {
        selectedButton = nil
        checkbutton.setTitle("Check", for: .normal)
        checkbutton.backgroundColor = UIColor(r: 209, g: 209, b: 209)
        checkbutton.setTitleColor(UIColor(r: 235, g: 235, b: 235), for: .normal)
        for button in buttons {
            button.layer.borderWidth = 0
            button.backgroundColor = .white
        }
    }
    @IBAction func speakQuizs(_ sender: UIButton) {
        let synthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: sender.titleLabel?.text ?? "")
        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        
        utterance.rate = 0.6
        synthesizer.speak(utterance)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quizPage.isHidden = false
        lastPage.isHidden = true
        pageNum = 0
        quizs.append(quizGenerator(1))
        quizs.append(quizGenerator(1))
        quizs.append(quizGenerator(1))
        quizs.append(quizGenerator(2))
        quizs.append(quizGenerator(2))
        quizs.append(quizGenerator(2))
        quizs.append(quizGenerator(2))
        quizs.append(quizGenerator(3))
        quizs.append(quizGenerator(3))
        quizs.append(quizGenerator(3))
        for i in 0..<quizs.count {
            answers.append(contentsOf: quizs[i].pick(1))
        }
        for i in 0..<quizs.count {
            answerButtons[i].setTitle(answers[i], for: .normal)
            answerButtons[i].layer.shadowColor = UIColor.black.cgColor
            answerButtons[i].layer.shadowOffset = CGSize(width: 0, height: 2)
            answerButtons[i].layer.shadowOpacity = 0.3
            
        }
        for i in 0..<4 {
            buttons[i].setTitle(quizs[0][i], for: .normal)
            buttons[i].layer.shadowColor = UIColor.black.cgColor
            buttons[i].layer.shadowOffset = CGSize(width: 0, height: 2)
            buttons[i].layer.shadowOpacity = 0.3
        }
        if(UserDefaults.standard.value(forKey: "solCount") == nil){
            count = 0
        }else{
            count = UserDefaults.standard.value(forKey: "solCount") as! Int
        }
        quizCount.text = "지금까지 푼 문제는 \(count * 10)문제 입니다."
    }
    
    func quizGenerator(_ level: Int) -> [String] {
        let consonants = ["\u{1100}", "\u{110f}", "\u{1101}", "\u{1102}", "\u{1103}", "\u{1110}", "\u{1105}", "\u{1104}",  "\u{1106}", "\u{1107}", "\u{1111}", "\u{1108}", "\u{1109}", "\u{110c}", "\u{110e}", "\u{110d}", "\u{110a}",  "\u{110b}", "\u{1112}"]
        let vowels = ["ㅡ", "ㅣ", "ㅏ", "ㅓ", "ㅗ", "ㅜ", "ㅑ", "ㅕ", "ㅛ", "ㅠ", "ㅐ", "ㅔ", "ㅒ", "ㅖ", "ㅘ", "ㅚ", "ㅙ", "ㅝ", "ㅟ", "ㅞ", "ㅢ"]
        let batchims = [["\u{11a8}", "\u{11bf}", "\u{11a9}", "\u{11aa}", "\u{11b0}"], ["\u{11ab}", "\u{11ac}", "\u{11ad}"], ["\u{11ae}", "\u{11ba}", "\u{11bb}", "\u{11bd}", "\u{11be}", "\u{11c0}", "\u{11c2}"], ["\u{11af}", "\u{11b2}", "\u{11b3}", "\u{11b4}", "\u{11b6}"], ["\u{11b7}", "\u{11b1}"], ["\u{11b8}", "\u{11c1}", "\u{11b9}", "\u{11b5}"], ["\u{11bc}"]]
        
        var quizArray = [String]()
        if level == 1 {
            var vowel = vowels.pick(4)
            while (vowel.contains("ㅔ") && vowel.contains("ㅐ")) || (vowel.contains("ㅒ") && vowel.contains("ㅖ")) || (vowel.contains("ㅚ") && vowel.contains("ㅙ")) || (vowel.contains("ㅚ") && vowel.contains("ㅞ")) || (vowel.contains("ㅙ") && vowel.contains("ㅞ")) {
                vowel = vowels.pick(4)
            }
            return vowel
        }
        if level == 2 {
            let consonant = consonants.pick(4)
            let vowel = vowels.pick(4)
            for i in 0..<4 {
                quizArray.append(combination(consonant: consonant[i], vowel: vowel[i]))
            }
            return quizArray
        }
        if level == 3 {
            let consonant = consonants.pick(1)
            let vowel = vowels.pick(4)
            let batchimCandidate = batchims.pick(4)
            var batchim = [String]()
            for i in 0..<4 {
                batchim.append(batchimCandidate[i].pick(1)[0])
            }
            for i in 0..<4 {
                quizArray.append(combination(consonant: consonant[0], vowel: vowel[i], batchim: batchim[i]))
            }
            return quizArray
        }
        return quizArray
    }
    
    func combination(consonant: String, vowel: String) -> String {
        let consonantIndex = (UnicodeScalar(consonant)?.value ?? 0x1100) - 0x1100
        let vowelIndex = (UnicodeScalar(vowel)?.value ?? 0x314f) - 0x314f
        
        let resultUni = ((consonantIndex * 21) + vowelIndex) * 28 + 0xAC00
        let resultStr = String(UnicodeScalar(resultUni)!)
        
        return resultStr
    }
    
    func combination(consonant: String, vowel: String, batchim: String) -> String {
        let consonantIndex = (UnicodeScalar(consonant)?.value ?? 0x1100) - 0x1100
        let vowelIndex = (UnicodeScalar(vowel)?.value ?? 0x314f) - 0x314f
        let batchimIndex = (UnicodeScalar(batchim)?.value ?? 0x11a7) - 0x11a7
        
        let resultUni = ((consonantIndex * 21) + vowelIndex) * 28 + batchimIndex + 0xAC00
        let resultStr = String(UnicodeScalar(resultUni)!)
        
        return resultStr
    }
    @IBAction func speakAnswer(_ sender: Any) {
        let synthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: answers[pageNum])
        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        
        utterance.rate = 0.6
        synthesizer.speak(utterance)
    }
}
//MARK: - 익스텐션
extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

extension Array {
    func pick(_ n: Int) -> [Element] {
        let shuffledIndices = indices.shuffled().prefix(upTo: n)
        return shuffledIndices.map {self[$0]}
    }
}

@IBDesignable
class PlainHorizontalProgressBar: UIView {
    @IBInspectable var color: UIColor? = .white
    var progress: CGFloat = 0.1 {
        didSet { setNeedsDisplay() }
    }
    
    override func draw(_ rect: CGRect) {
        let progressRect = CGRect(origin: .zero, size: CGSize(width: rect.width*progress, height: rect.height))
        let progressLayer = CALayer()
        progressLayer.frame = progressRect
        
        layer.addSublayer(progressLayer)
        progressLayer.backgroundColor = color?.cgColor
    }
}
