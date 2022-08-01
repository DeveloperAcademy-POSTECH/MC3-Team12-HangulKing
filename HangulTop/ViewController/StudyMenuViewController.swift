//
//  StudyMenuViewController.swift
//  HangulTop
//
//  Created by 이주화 on 2022/07/26.
//

import UIKit

class StudyMenuViewController: UIViewController {
    var indexCount = 0
    @IBOutlet weak var vowelButton: UIButton!
    @IBOutlet weak var consonantButton: UIButton!
    @IBOutlet weak var batchimButton: UIButton!
    @IBOutlet weak var topRectangleView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vowelButton.setButtonStyle()
        consonantButton.setButtonStyle()
        batchimButton.setButtonStyle()
//        quizButton.setButtonStyle()
//        HangulButton.setButtonStyle()
    }
    
    override func viewDidLayoutSubviews() {
        topRectangleView.setGradient(color1: .white, color2: .blue)
    }
    
    
    @IBAction func toVowel(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.infos.indexCount = 0
    }
    
    @IBAction func toConsonant(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.infos.indexCount = 1
    }
    
    @IBAction func toBatchim(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.infos.indexCount = 2
    }
}

extension UIButton {
//    self.layer.cornerRadius = 50
    func setButtonStyle() {
        self.layer.masksToBounds = false
//        self.layer.cornerRadius = self.frame.height/2
        self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = 0.25
//        self.layer.shadowRadius = 10
    }
}

//view.setGradient(color1: UIColor.white,color2:UIColor.black)
extension UIView{
    func setGradient(color1:UIColor,color2:UIColor){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor,color2.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.frame = bounds
        layer.addSublayer(gradient)
    }
}
