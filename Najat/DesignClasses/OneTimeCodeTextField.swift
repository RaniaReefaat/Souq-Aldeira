import UIKit

final class OneTimeCodeTextField: UITextField {

    var didEnterLastDigit: ((String) -> Void)?
        
    private var isConfigured = false
    private var digitLabels = [UILabel]()
    
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(becomeFirstResponder))
        return recognizer
    }()
    
    func configure(with slotCount: Int) {
        guard isConfigured == false else { return }
        isConfigured.toggle()
        configureTextField()
        setupStackView(slotCount: slotCount)
    }
    
    private func setupStackView(slotCount: Int) {
        let labelsStackView = createLabelsStackView(with: slotCount)
        addSubview(labelsStackView)
        
        addGestureRecognizer(tapRecognizer)
        
        NSLayoutConstraint.activate([
            labelsStackView.topAnchor.constraint(equalTo: self.topAnchor),
            labelsStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            labelsStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            labelsStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    private func configureTextField() {
        tintColor = .clear
        textColor = .clear
        keyboardType = .numberPad
        textContentType = .oneTimeCode
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        delegate = self
    }
    
    private func createLabelsStackView(with count: Int) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        for _ in 1 ... count {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.font = .semiBoldFont(of: 24)
            label.textColor = .gray
            label.layer.cornerRadius = 10
            label.layer.borderWidth = 0.5
            label.text = "_"
            label.layer.borderColor = UIColor.gray.cgColor
            label.isUserInteractionEnabled = true
            stackView.addArrangedSubview(label)
            digitLabels.append(label)
        }
        
        return stackView
    }
    
    @objc
    private func textDidChange() {
        
        guard let text = self.text, text.count <= digitLabels.count else { return }
        
        for i in 0 ..< digitLabels.count {
            
            let currentLabel = digitLabels[i]
            
            if i < text.count {
                let index = text.index(text.startIndex, offsetBy: i)
                currentLabel.text = String(text[index])
                currentLabel.textColor = .blue
                currentLabel.layer.borderColor = UIColor.blue.cgColor
            } else {
                currentLabel.text = "_"
                currentLabel.textColor = .gray
                currentLabel.layer.borderColor = UIColor.gray.cgColor
            }
        }
        
        if text.count == digitLabels.count && !text.contains("_") {
            didEnterLastDigit?(text)
        }
    }
    
}

extension OneTimeCodeTextField: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let characterCount = textField.text?.count else { return false }
        return characterCount < digitLabels.count || string == ""
    }
}
