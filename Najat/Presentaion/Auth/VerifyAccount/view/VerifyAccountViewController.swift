//
//  VerifyAccountViewController.swift
//  Najat
//
//  Created by rania refaat on 09/06/2024.
//

import UIKit

class VerifyAccountViewController: BaseController {

    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var TF1ContainerView: UIView!
    @IBOutlet weak var TF2ContainerView: UIView!
    @IBOutlet weak var TF3ContainerView: UIView!
    @IBOutlet weak var TF4ContainerView: UIView!
    @IBOutlet weak var TF1LineView: UIView!
    @IBOutlet weak var TF2LineView: UIView!
    @IBOutlet weak var TF3LineView: UIView!
    @IBOutlet weak var TF4LineView: UIView!
    @IBOutlet weak var TF1: UITextField!
    @IBOutlet weak var TF2: UITextField!
    @IBOutlet weak var TF3: UITextField!
    @IBOutlet weak var TF4: UITextField!
    @IBOutlet weak var textFieldsContainerStackView: UIStackView!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    // MARK: Variables
    private var timeLeft: TimeInterval = 60
    private var endTime: Date?
    private  var timer : Timer?
    private var phone: String
    
    private lazy var viewModel: VerifyAccountViewModel = {
        VerifyAccountViewModel(coordinator: coordinator)
    }()
    
    // MARK: Init
    init(phone: String) {
        self.phone = phone
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
        timerIsStarted()
        bind()
        NotificationCenter.default.addObserver(self, selector: #selector(goPrevious), name: Notification.Name("goPrevious"), object: nil)

    }
    @objc func goPrevious() {
        if TF2.isFirstResponder {
            TF1.becomeFirstResponder()
            handleTFDesign(TF: TF1)
        } else if TF3.isFirstResponder {
            TF2.becomeFirstResponder()
            handleTFDesign(TF: TF2)
        } else if TF4.isFirstResponder {
            TF3.becomeFirstResponder()
            handleTFDesign(TF: TF3)
        }
    }
    private func handleTime() {
        endTime = Date().addingTimeInterval(timeLeft)
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        timeLabel.text =  timeLeft.string
    }
    
    @objc func updateTime() {
        if timeLeft > 0 {
            timeLeft = endTime?.timeIntervalSinceNow ?? 0
            timeLabel.text = timeLeft.time
        } else {
            timerIsFinished()
            timeLabel.text = "00:00"
            timer?.invalidate()
        }
    }
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        attemptVerify()

    }
    @IBAction func resendButtonTapped(_ sender: UIButton) {
        attemptResendCode()
    }
}
extension VerifyAccountViewController: UITextFieldDelegate {
    
    func setupTextField() {
        TF1.becomeFirstResponder()
        [TF1, TF2, TF3 , TF4].forEach({$0?.font = UIFont(name: "KalligArb-Regular", size: 30)})
        textFieldsContainerStackView.semanticContentAttribute = .forceLeftToRight
        [TF1, TF2, TF3 , TF4].forEach({$0?.keyboardType = .asciiCapableNumberPad})
        [TF1, TF2, TF3 , TF4].forEach({$0?.delegate = self})
        [TF1, TF2, TF3 , TF4].forEach({$0?.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)})

        handleTFDesign(TF: TF1)
    }
    private func handleTFDesign(TF: UITextField){
        [TF1ContainerView, TF2ContainerView, TF3ContainerView , TF4ContainerView].forEach({$0?.viewBorderColor = #colorLiteral(red: 0.7647058824, green: 0.7647058824, blue: 0.7647058824, alpha: 1)})
        
        [TF1LineView, TF2LineView, TF3LineView , TF4LineView].forEach({$0?.isHidden = true})

        if TF == TF1 {
            TF1ContainerView.viewBorderColor = .mainBlack
            TF1LineView.isHidden = false

        }else if TF == TF2 {
            TF2ContainerView.viewBorderColor = .mainBlack
            TF2LineView.isHidden = false

        }else if TF == TF3 {
            TF3ContainerView.viewBorderColor = .mainBlack
            TF3LineView.isHidden = false

        }else if TF == TF4 {
            TF4ContainerView.viewBorderColor = .mainBlack
            TF4LineView.isHidden = false

        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {//
        let text = textField.text
        if (text?.utf16.count)! == 1{
            switch textField{
            case TF1:
                TF2.becomeFirstResponder()
                TF2.text = nil
                handleTFDesign(TF: TF2)

            case TF2:
                TF3.becomeFirstResponder()
                TF3.text = nil
                handleTFDesign(TF: TF3)

            case TF3:
                TF4.becomeFirstResponder()
                TF4.text = nil
                handleTFDesign(TF: TF4)
            case TF4:
                TF4.resignFirstResponder()
//                [TF1ContainerView, TF2ContainerView, TF3ContainerView , TF4ContainerView].forEach({$0?.viewBorderWidth = 0})
                
                [TF1LineView, TF2LineView, TF3LineView , TF4LineView].forEach({$0?.isHidden = true})

            default:
                break
            }
        }else{
        }
        if !TF1.text.isNilOrEmpty && !TF2.text.isNilOrEmpty && !TF3.text.isNilOrEmpty && !TF4.text.isNilOrEmpty{
            confirmButton.isEnabled = true
            attemptVerify()
        }else{
            confirmButton.isEnabled = false
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    func timerIsStarted() {
        resendButton.isEnabled = false

        timeLeft = 60
        handleTime()
    }
    
    func timerIsFinished() {
        resendButton.isEnabled = true

    }
    
}
extension VerifyAccountViewController {
    
    private func attemptVerify() {
        let text1 = TF1.text ?? ""
        let text2 = TF2.text ?? ""
        let text3 = TF3.text ?? ""
        let text4 = TF4.text ?? ""
        
        let body = VerifyPhoneBody(
            phone: phone,
            code: text1 + text2 + text3 + text4
        )
        
        Task {
            await viewModel.attemptVerify(body:body)
        }
    }
    private func attemptResendCode() {
        Task {
            await viewModel.attemptResendCode(phone:phone)
        }
    }
    
}

// MARK: Binding

extension VerifyAccountViewController {
    private func bind() {
        bindLoadingIndicator()
        bindVerification()
        bindResendCode()

    }
    
    private func bindLoadingIndicator() {
        viewModel.$loadingIndicator.sink { [weak self] state in
            guard let self else { return }
            handleScreenState(state)
        }.store(in: &cancellable)
    }
    
    private func bindVerification() {
        viewModel.verificationState.sink { [weak self] in
            guard let self else { return }
            AppWindowManger.openTabBar()
        }.store(in: &cancellable)
    }
    private func bindResendCode() {
        viewModel.codeResendState.sink { [weak self] in
            guard let self else { return }
            timerIsStarted()
        }.store(in: &cancellable)
    }
}

