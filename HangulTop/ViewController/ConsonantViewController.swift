//
//  ConsonantViewController.swift
//  HangulTop
//
//  Created by kimjimin on 2022/07/18.
//
import UIKit
import AVFoundation

class ConsonantViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate, AVAudioPlayerDelegate, AVAudioRecorderDelegate{
    //녹음 재생 관련 변수들
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    var audioPlayer : AVAudioPlayer!
    var audioFile : URL!
    var audioRecorder : AVAudioRecorder!
    var isRecording = false
    
    //페이지 카운트 변수
    var pageNum = 0
    var indexCount: Int = 0
    //메인 버튼 글자 배열
    let syllableArray = [[["ㅡ", "ㅣ"], ["ㅏ", "ㅓ", "ㅗ", "ㅜ"], ["ㅑ", "ㅕ", "ㅛ", "ㅠ"], ["ㅐ", "ㅔ", "ㅒ", "ㅖ"], ["ㅘ", "ㅚ", "ㅙ", "ㅝ", "ㅟ", "ㅞ", "ㅢ"]],[["\u{1100}","\u{110f}","\u{1101}"], ["\u{1102}","\u{1103}","\u{1110}","\u{1105}","\u{1104}"], ["\u{1106}", "\u{1107}","\u{1111}","\u{1108}"], ["\u{1109}","\u{110c}","\u{110e}","\u{110d}","\u{110a}"], ["\u{110b}","\u{1112}"]],[["\u{11a8}", "\u{11bf}", "\u{11a9}", "\u{11aa}", "\u{11b0}"],["\u{11ab}", "\u{11ac}", "\u{11ad}"], ["\u{11ae}", "\u{11ba}", "\u{11bb}", "\u{11bd}", "\u{11be}", "\u{11c0}", "\u{11c2}"], ["\u{11af}", "\u{11b2}", "\u{11b3}", "\u{11b4}", "\u{11b6}"], ["\u{11b7}", "\u{11b1}"], ["\u{11b8}", "\u{11c1}", "\u{11b9}", "\u{11b5}"], ["\u{11bc}"]]]
    //자음 공부시 보이는 모음 배열
    let vowelArray = ["ㅡ", "ㅣ", "ㅏ", "ㅓ", "ㅗ", "ㅜ", "ㅑ", "ㅕ", "ㅛ", "ㅠ", "ㅐ", "ㅔ", "ㅒ", "ㅖ", "ㅘ", "ㅚ", "ㅙ", "ㅝ", "ㅟ", "ㅞ", "ㅢ"]
    //설명 배열
    var explanationArray = [["ㅡ always goes below the consonant,\nwhereas ㅣ goes to the right.", "One · is added to the basic vowel.", "Two · were added to the basic vowel.", "· and ㅣwere added to the basic vowel.", "Two vowels are combined into one!\nRead them quickly in order."],["","","","",""],["","","","","","",""]]
    //페이지 컨트롤에 표시되는 배열
    var pageArray = [["", "ㅣ", "ㅏ", "ㅑ", "ㅐ", "ㅘ", ""], ["", "ㄱ", "ㄴ", "ㅁ", "ㅅ", "ㅇ", ""], ["ㄱ", "ㄴ", "ㄷ", "ㄹ", "ㅁ", "ㅂ", "ㅇ"]]
    var defaultLetter: [String] = ["으", "가", "악"]
    
    @IBOutlet var button1: [UIButton]!
    @IBOutlet var button2: [UIButton]!
    @IBOutlet var button3: [UIButton]!
    @IBOutlet var button4: [UIButton]!
    @IBOutlet var button5: [UIButton]!
    @IBOutlet var button7: [UIButton]!
    var buttons = [[UIButton]]()
    
    @IBOutlet var buttonSets: [UIView]!
    var currentButtonSet = [UIButton]()
    
    @IBOutlet var pages: [UIButton]!
    @IBOutlet weak var mainLetter: UILabel!
    @IBOutlet weak var vowelCollection: UICollectionView!
    @IBOutlet weak var explanationView: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    
    func initPage() {
        cleanButtonSet()
        currentButtonSet.removeAll()
        setButtonLayout()
        setPageControl()
        setInitalMainLetter()
        setExplanation()
        setInfo()
        currentButtonSet[0].backgroundColor = UIColor(named: "study-button")
        vowelCollection.flashScrollIndicators()
    }
    
    @IBAction func infoButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "InfoModal", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "InfoModal" {
            let destinationVC = segue.destination as! InformationModalViewController
            destinationVC.pageCount = pageNum
        }
    }
    
    func setInfo() {
        if(indexCount == 1){
            infoButton.isHidden = false
        }else{
            infoButton.isHidden = true
        }
        
    }
    
    @IBAction func changePage(_ sender: UIButton) {
        if indexCount == 2 {
            pageNum = sender.tag
        } else {
            pageNum = sender.tag - 1
        }
        initPage()
    }
    
    @IBAction func buttonSelected(_ sender: UIButton) {
        let mainUni = UnicodeScalar(defaultLetter[indexCount])?.value
        let buttonUni = UnicodeScalar(sender.titleLabel!.text ?? "ㄱ")?.value ?? 0x1100
        if buttonUni < 0x1113 { //자음일때
            let uni = buttonUni - 0x1100
            let vowelUni = ((mainUni ?? 0xac01) - 0xac00) / 28 % 21
            let batUni = ((mainUni ?? 0xac01) - 0xac00) % 28
            let letter = ((uni * 21) + vowelUni) * 28 + batUni + 0xAC00
            defaultLetter[indexCount] = String(UnicodeScalar(letter)!)
        }
        else if buttonUni < 0x11c3 { //받침일때
            let uni = buttonUni - 0x11a7
            let conUni = ((mainUni ?? 0xac01) - 0xac00) / 28 / 21
            let vowelUni = ((mainUni ?? 0xac01) - 0xac00) / 28 % 21
            let letter = ((conUni * 21) + vowelUni) * 28 + uni + 0xAC00
            defaultLetter[indexCount] = String(UnicodeScalar(letter)!)
        }
        else { //모음일때
            let uni = buttonUni - 0x314f
            let conUni = ((mainUni ?? 0xac01) - 0xac00) / 28 / 21
            let batUni = ((mainUni ?? 0xac01) - 0xac00) % 28
            let letter = ((conUni * 21) + uni) * 28 + batUni + 0xAC00
            defaultLetter[indexCount] = String(UnicodeScalar(letter)!)
        }
        mainLetter.text = defaultLetter[indexCount]
        pronounce(defaultLetter[indexCount])
        cleanButtonSet()
        sender.backgroundColor = UIColor(named: "study-button")
    }
    
    @IBOutlet weak var prevButton: UIButton!
    
    //이전 버튼
    @IBAction func prevPage(_ sender: Any) {
        if pageNum > 0 {
            pageNum -= 1
            initPage()
        }
    }
    
    //다음 버튼
    @IBAction func nextPage(_ sender: Any) {
        if pageNum < syllableArray[indexCount].count {
            pageNum += 1
        }
        if pageNum == syllableArray[indexCount].count { //성공 뷰
            switch indexCount {
            case 0:
                UserDefaults.standard.set(true, forKey: "isVowel")
            case 1:
                UserDefaults.standard.set(true, forKey: "isConsonant")
            case 2:
                UserDefaults.standard.set(true, forKey: "isBatchim")
            default:
                print("")
            }
            guard let vc =  storyboard?.instantiateViewController(identifier: "ConsonantEndViewController") as? ConsonantEndViewController else
            { return }
            vc.data = indexCount
            self.navigationController!.pushViewController(vc, animated: true)
        } else {
            initPage()
        }
    }
    
    //페이지가 바뀔 때 마다 설명 변경
    func setExplanation() {
        explanationView.text = explanationArray[indexCount][pageNum]
    }
    
    //배열의 0번째 아이템을 보여줌
    func setInitalMainLetter() {
        let mainUni = UnicodeScalar(defaultLetter[indexCount])?.value
        let buttonUni = UnicodeScalar(syllableArray[indexCount][pageNum][0])?.value ?? 0x1100
        if(buttonUni < 0x1113){ //자음일때
            let uni = buttonUni - 0x1100
            let vowelUni = ((mainUni ?? 0xac01) - 0xac00) / 28 % 21
            let batUni = ((mainUni ?? 0xac01) - 0xac00) % 28
            let letter = ((uni * 21) + vowelUni) * 28 + batUni + 0xAC00
            defaultLetter[indexCount] = String(UnicodeScalar(letter)!)
        }
        else if(buttonUni < 0x11c3){ //받침일때
            let uni = buttonUni - 0x11a7
            let conUni = ((mainUni ?? 0xac01) - 0xac00) / 28 / 21
            let vowelUni = ((mainUni ?? 0xac01) - 0xac00) / 28 % 21
            let letter = ((conUni * 21) + vowelUni) * 28 + uni + 0xAC00
            defaultLetter[indexCount] = String(UnicodeScalar(letter)!)
        }
        else{ //모음일때
            let uni = buttonUni - 0x314f
            let conUni = ((mainUni ?? 0xac01) - 0xac00) / 28 / 21
            let batUni = ((mainUni ?? 0xac01) - 0xac00) % 28
            let letter = ((conUni * 21) + uni) * 28 + batUni + 0xAC00
            defaultLetter[indexCount] = String(UnicodeScalar(letter)!)
        }
        mainLetter.text = defaultLetter[indexCount]
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vowelArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! CollectionViewCell
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: -1, height: 1)
        cell.layer.shadowOpacity = 0.3
        cell.cellButton.setTitle(vowelArray[indexPath.row], for: .normal)
        cell.cellButton.addTarget(self, action: #selector(getVowel(sender:)), for: .touchUpInside)
        cell.cellButton.addTarget(self, action: #selector(selectCellByButton(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func selectCellByButton(sender: UIButton) {
        let indexOfCell = vowelArray.firstIndex(of: sender.titleLabel?.text ?? "ㅏ")
        vowelCollection.selectItem(at: IndexPath(row: indexOfCell!, section: 0), animated: false, scrollPosition: .top)
    }
    
    @objc func getVowel(sender: UIButton){
        let mainUni = UnicodeScalar(defaultLetter[indexCount])?.value
        let buttonUni = UnicodeScalar(sender.titleLabel!.text ?? "ㅏ")?.value ?? 0x1100
        let uni = buttonUni - 0x314f
        let conUni = ((mainUni ?? 0xac01) - 0xac00) / 28 / 21
        let batUni = ((mainUni ?? 0xac01) - 0xac00) % 28
        let letter = ((conUni * 21) + uni) * 28 + batUni + 0xAC00
        
        defaultLetter[indexCount] = String(UnicodeScalar(letter)!)
        mainLetter.text = defaultLetter[indexCount]
        pronounce(defaultLetter[indexCount])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttons = [button1, button2, button3, button4, button5, button7]
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        indexCount = appDelegate?.infos.indexCount ?? 0
        mainLetter.text = defaultLetter[indexCount]
        for i in 0..<pages.count {
            pages[i].setTitle(pageArray[indexCount][i], for: .normal)
        }
        setButtonLayout()
        setPageControl()
        vowelCollection.selectItem(at: IndexPath(row: vowelArray.firstIndex(of: "ㅏ")!, section: 0), animated: false, scrollPosition: .top)
        currentButtonSet[0].backgroundColor = UIColor(named: "study-button")
        setInfo()
        selectAudioFile()
        setRecordButton()
        if indexCount == 0 {
            vowelCollection.isHidden = true
            explanationView.isHidden = false
        } else {
            vowelCollection.isHidden = false
            explanationView.isHidden = true
        }
        if !isRecording { // 재생 모드일 때(녹음 모드가 아니라면)
            initplay()
        } else { // 녹음 모드일 때
            initRecord()
        }
        playButton.isHidden = true
        explanationView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        vowelCollection.flashScrollIndicators()
    }
    
    func setPageControl() {
        if pageNum == 0 {
            prevButton.isHidden = true
        } else {
            prevButton.isHidden = false
        }
        if indexCount == 2 {
            for page in pages{
                page.setTitleColor(.gray, for: .normal)
            }
            pages[pageNum].setTitleColor(.black, for: .normal)
        } else {
            for page in pages {
                page.setTitleColor(.gray, for: .normal)
            }
            pages[pageNum + 1].setTitleColor(.black, for: .normal)
        }
    }
    
    func setButtonLayout() {
        for buttonSet in buttonSets {
            buttonSet.isHidden = true
        }
        let currentArray = syllableArray[indexCount][pageNum]
        var index = 0
        if currentArray.count == 7 {
            index = currentArray.count - 2
        } else {
            index = currentArray.count - 1
        }
        buttonSets[index].isHidden = false
        for i in 0..<buttons[index].count {
            buttons[index][i].setTitle(currentArray[i], for: .normal)
        }
        currentButtonSet = buttons[index]
        for button in currentButtonSet {
            button.setShadow()
        }
    }
    
    func cleanButtonSet() {
        for button in currentButtonSet {
            button.backgroundColor = .white
        }
    }
    
    // 발음 듣기
    func pronounce(_ letter: String) {
        let synthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: letter)
        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        
        let audioSession = AVAudioSession.sharedInstance() //녹음 및 재생이 점유하고 있는 오디오 다시 가져오기
        try! audioSession.setCategory(
            AVAudioSession.Category.playback,
            options: AVAudioSession.CategoryOptions.mixWithOthers
        )
        utterance.volume = 30
        utterance.rate = 0.4
        synthesizer.speak(utterance)
    }
    
    // 재생 모드와 녹음 모드에 따라 다른 파일을 선택
    func selectAudioFile() {
        if !isRecording { // 재생 모드일 때
            audioFile = Bundle.main.url(forResource: "Sound", withExtension: "mp3")
        } else { // 녹음 모드일 때
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            audioFile = documentDirectory.appendingPathComponent("recordFile.m4a")
        }
    }
    
    // 녹음 모드의 초기화
    func initRecord() {
        let recordSettings = [AVFormatIDKey : NSNumber(value: kAudioFormatAppleLossless as UInt32),
                   AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
                        AVEncoderBitRateKey : 320000,
                      AVNumberOfChannelsKey : 2,
                            AVSampleRateKey : 44100.0 ] as [String : Any]
        do {
            audioRecorder = try AVAudioRecorder(url: audioFile, settings: recordSettings)
        } catch let error as NSError {
            print("Error-initRecord : \(error)")
        }
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled =  true
        audioRecorder.prepareToRecord()
        audioPlayer.volume = 30
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSession.Category.playAndRecord)
        } catch let error as NSError {
            print(" Error-setCategory : \(error)")
        }
        do {
            try session.setActive(true)
        } catch let error as NSError {
            print(" Error-setActive : \(error)")
        }
    }
    
    // 재생 모드의 초기화
    func initplay() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFile)
        } catch let error as NSError {
            print("Error-initPlay : \(error)")
        }
        audioPlayer.delegate = self // audioPlayer의 델리게이트는 self
        audioPlayer.prepareToPlay() // prepareToPlay() 실행
        audioPlayer.volume = 30
    }
    
    // 재생 버튼 클릭
    @IBAction func btnPlayAudio(_ sender: UIButton) {
        initplay()
        audioPlayer.volume = 30
        audioPlayer.play()
    }
    
    // 녹음 버튼 클릭
    @IBAction func btnRecord(_ sender: UIButton) {
        if !isRecording { // 녹음 모드가 아닐 때, 즉 재생 모드일 때
            playButton.isHidden = true
            isRecording = true
            selectAudioFile()
            initRecord()
        } else { // 녹음 모드일 때
            isRecording = false
        }
        
        if isRecording { // 'Recording'이 참일 때 녹음을 시작함
            audioRecorder.record()
            setRecordButton()
            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [self] (timer) in
                if(isRecording != false){
                    self.playButton.isHidden = false
                    self.audioRecorder.stop()
                    self.initplay()
                    self.audioPlayer.play()
                    isRecording = false
                    self.setRecordButton()
                }
                
            }
        } else { // 'Recording'이 거짓일 때 녹음을 중지하고 녹음된 소리를 출력
            setRecordButton()
            audioRecorder.stop()
            initplay()
            audioPlayer.play()
            playButton.isHidden = false
        }
    }
    
    func setRecordButton() {
        let button = UIButton()
        let font = UIFont.systemFont(ofSize: 30)
        let config = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: isRecording ? "stop.fill" :"mic.fill", withConfiguration: config)
        recordButton.setImage(image, for: .normal)

    }
}

extension UIButton {
    func setShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowOpacity = 0.3
    }
}
