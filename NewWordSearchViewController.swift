//
//  NewWordSearchViewController.swift
//  NewWordSearch
//
//  Created by 김하은 on 2023/07/23.
//

import UIKit

// 영어로 검색시 연속되는 문자는 괜찮음 (jjj) -> (dkdis) 이렇게 다른 문자 넣으면 이상하게 변환됌.. 한글은 오류안남
// newWordTextField.text로 값 받아올땐 멀쩡한데 TextField 위에서만 그런듯..?
// 최근 검색어 스크롤뷰로 만들어보고 싶어서 setupKeyword로 구현했는데 매번 지우고 다시 그리는게 비효율적 같음..
// 검색 후 텍스트 필드를 지우니까 뭘 검색했는지 헷갈려서 textFieldClick 이벤트 만듬
// placeholder 기능으로 넣을까 했는데 그럼 타이핑하다 지웠을때 이전 단어가 보여서 뭔가 이상함.. 뭐가 더 나은거지??

class NewWordSearchViewController: UIViewController {

    @IBOutlet var newWordTextField: UITextField!
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var keyWordScrollView: UIScrollView!
    
    var keyWordArray = [String]()
    
    let NewWords = [
        "스불재":"스스로 불러온 재앙의 줄임말",
        "좋댓구알":"좋아요, 댓글, 구독, 알림 설정의 줄임말",
        "점메추":"점심 메뉴 추천의 줄임말",
        "갑분싸":"갑자기 분위기가 싸해짐의 줄임말",
        "별다줄":"별걸 다 줄인다의 줄임말"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newWordTextField.attributedPlaceholder = NSAttributedString(string: "신조어를 입력하세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
    }

    @IBAction func textFieldClick(_ sender: UITextField) {
        newWordTextField.text = nil
    }
    
    @IBAction func searchButtonClick(_ sender: UIButton) {
        
        if newWordTextField.text!.count < 2{
            let alert = UIAlertController(title: "알림", message: "한 글자 이상 입력해주세요", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
        }else{
            keyWordArray.insert(newWordTextField.text!, at: 0)
            
            for newWord in NewWords{
                if newWord.key == newWordTextField.text!{
                    textSetting(labelMessage: newWord.value)
                    return
                }
            }
            
            textSetting(labelMessage: "등록된 신조어가 아닙니다")
        }
        view.endEditing(true)
    }
    
    func textSetting(labelMessage: String){
        resultLabel.text = labelMessage
        setupKeyword()
    }
    
    func setupKeyword() {
        
        keyWordScrollView.subviews.forEach({ $0.removeFromSuperview() })
        
        for i in 0..<keyWordArray.count{
            
            let xPos = 80 * i
            let button = UIButton()
            button.layer.cornerRadius = 8
            button.layer.borderColor = UIColor.lightGray.cgColor
            button.layer.borderWidth = 1
            button.setTitle(keyWordArray[i], for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 15)
            button.setTitleColor(UIColor.black, for: .normal)
            button.frame = CGRect(x: xPos, y: 0, width: 70, height: 30)
            button.addTarget(self, action: #selector(keywordButtonTapped(_:)), for: .touchUpInside)
            
            keyWordScrollView.addSubview(button)
            keyWordScrollView.contentSize.width = 80 * CGFloat(i + 1)
        }
    }
    
    @objc func keywordButtonTapped(_ sender: UIButton){
        newWordTextField.text = sender.titleLabel?.text!
        searchButtonClick(searchButton)
    }
    
    @IBAction func returnKeyPress(_ sender: UITextField) {
        searchButtonClick(searchButton)
        view.endEditing(true)
    }
    
    @IBAction func touchViewKeyBoardDown(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
