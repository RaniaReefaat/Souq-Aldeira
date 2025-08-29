//
//  ContactUSViewController.swift
//  Celebration
//
//  Created by rania refaat on 11/10/2023.
//

import UIKit

class ContactUSViewController: BaseController {

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var notesTV: UITextView!

    @IBOutlet weak var instaButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var snapButton: UIButton!
    @IBOutlet weak var tikTokButton: UIButton!
    @IBOutlet weak var contactLinksStackView: UIStackView!
    @IBOutlet weak var phoneLabel: UILabel!


    private var startTextView = false

    private lazy var viewModel: SettingsViewModel = {
        SettingsViewModel(coordinator: coordinator)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesTV.delegate = self
        notesTV.text = AppStrings.notesMessage.message
        setTitle(AppStrings.contactUS.message)
        bind()
        notesTV.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)

    }
    @IBAction func instaButtonTapped(_ sender: UIButton) {
        if let url = URL(string: viewModel.contactsData.instagram ?? "") {
            openURL(url)
        }
    }
    @IBAction func twitterButtonTapped(_ sender: UIButton) {
        if let url = URL(string: viewModel.contactsData.twitter ?? "") {
            openURL(url)
        }
    }
    @IBAction func snapButtonTapped(_ sender: UIButton) {
        if let url = URL(string: viewModel.contactsData.snapchat ?? "") {
            openURL(url)
        }
    }
    @IBAction func tiktokButtonTapped(_ sender: UIButton) {
        if let url = URL(string: viewModel.contactsData.tiktok ?? "") {
            openURL(url)
        }
    }
    @IBAction func whatsAppButtonTapped(_ sender: UIButton) {
        openWhatsApp(withPhoneNumber: viewModel.contactsData.phone ?? "", messageText: nil)

    }
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        
        var name = nameTF.text ?? ""
        var email = emailTF.text ?? ""
        var message: String?
        
        if startTextView && !notesTV.text.isNilOrEmpty {
            message = notesTV.text ?? ""
        }
        var body = ContactUSBody(
            name : name,
            email : email,
            message : message
        )
        Task {
         await viewModel.sendContactUS(body: body)
        }
    }
    private func openURL(_ url: URL) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
extension ContactUSViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if startTextView == false{
            startTextView = true
            notesTV.text = nil
        }
        notesTV.textColor = .mainBlack
    }
    func textViewDidChange(_ textView: UITextView) {
        if startTextView != false{
        }

    }
    func textViewDidEndEditing(_ textView: UITextView) {

        if notesTV.text == nil || notesTV.text == ""{
            notesTV.text = AppStrings.notesMessage.message
            notesTV.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            startTextView = false
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            // Allow the newline character to be added to the text view
            return true
        }
        return true
    }
}
extension ContactUSViewController{
    func messageSendSuccessfully() {
        emailTF.text = nil
        nameTF.text = nil
        notesTV.text = AppStrings.notesMessage.message
        notesTV.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        startTextView = false
    }
    
    func setContactsData() {

        let data = viewModel.contactsData
        print(data)
        let snapchat = data.snapchat ?? ""
        let tiktok = data.tiktok ?? ""
        let twitter = data.twitter ?? ""
        let instagram = data.instagram ?? ""

        if snapchat.isEmpty {
            snapButton.isHidden = true
        }else{
            snapButton.isHidden = false
        }
        
        if tiktok.isEmpty {
                tikTokButton.isHidden = true
        }else{
            tikTokButton.isHidden = false
        }
        
        if instagram.isEmpty {
            instaButton.isHidden = true
        }else{
            instaButton.isHidden = false
        }
        
        if twitter.isEmpty {
            twitterButton.isHidden = true
        }else{
            twitterButton.isHidden = false
        }
        
        if snapchat.isEmpty && tiktok.isEmpty && twitter.isEmpty && instagram.isEmpty {
            contactLinksStackView.isHidden = true
        }else{
            contactLinksStackView.isHidden = false
        }
        phoneLabel.text = viewModel.contactsData.phone
    }
}
// MARK: Binding
extension ContactUSViewController {
    private func bind() {
        bindLoadingIndicator()
        bindReloadData()
        getContactData()
        bindSendContact()
    }
    func getContactData() {
        Task {
            await viewModel.getContacts()
        }
    }
    private func bindLoadingIndicator() {
        viewModel.$loadingIndicator.sink { [weak self] state in
            guard let self else { return }
            handleScreenState(state)
        }.store(in: &cancellable)
    }
    private func bindReloadData() {
        viewModel.$getContacts.sink { [weak self] state in
            guard let self else { return }
            setContactsData()
        }.store(in: &cancellable)
    }
    private func bindSendContact() {
        viewModel.$sendContacts.sink { [weak self] message in
            guard let self , (message != nil) else { return }
            showAlert(with: message ?? "", title: .success)
            messageSendSuccessfully()
        }.store(in: &cancellable)
    }
}
