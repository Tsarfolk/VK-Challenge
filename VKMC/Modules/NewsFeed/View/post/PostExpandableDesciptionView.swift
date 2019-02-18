import UIKit

class PostExpandableDesciptionView: UIView {
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = VKMCFonts.regular(ofSize: 15)
        label.textColor = VKMCColors.blackDescription
        return label
    }()
    private lazy var expandButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(VKMCColors.blueButton, for: .normal)
        button.titleLabel?.font = VKMCFonts.regular(ofSize: 15)
        button.addTarget(self, action: #selector(expandButtonDidTouch), for: .touchUpInside)
        return button
    }()
    
    private let maxNumberOfLines = 8
    private lazy var primaryFont: UIFont = textLabel.font
    private lazy var lineHeight: CGFloat = primaryFont.lineHeight
    var expandButtonHeightConstaint: NSLayoutConstraint?
    
    var expandButtonDidTouchCallback: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func expandButtonDidTouch() {
        expandButtonDidTouchCallback?()
    }
    
    func configure(text: String, shouldExpand: Bool, searchText: String?) {
        if let searchText = searchText {
            let mutable = NSMutableAttributedString(string: text)
            var startIndex = text.startIndex
            while let range = text.range(of: searchText, options: [.diacriticInsensitive, .caseInsensitive], range: startIndex..<text.endIndex) {
                mutable.addAttribute(.backgroundColor, value: VKMCColors.searchSelectColor.withAlphaComponent(0.12), range: NSRange(range, in: searchText))
                mutable.addAttribute(.foregroundColor, value: VKMCColors.searchTextSelectColor, range: NSRange(range, in: searchText))
                startIndex = range.upperBound
            }
            textLabel.attributedText = mutable
        } else {
            textLabel.text = text
        }
        
        guard !shouldExpand else {
            hideExpandButton()
            textLabel.numberOfLines = 0
            return
        }
        
        textLabel.numberOfLines = maxNumberOfLines - 1
        let height = text.height(withConstrainedWidth: frame.width, font: primaryFont)
        let numberOfLines = height / lineHeight
        if Int(numberOfLines) >= maxNumberOfLines {
            showExpandButton()
        } else {
            hideExpandButton()
        }
    }
    
    private func showExpandButton() {
        expandButtonHeightConstaint?.constant = lineHeight
        expandButton.setTitle(LocalizedString.localized(key: .expandText) + "...", for: .normal)
    }
    
    private func hideExpandButton() {
        expandButtonHeightConstaint?.constant = 0
        expandButton.setTitle("", for: .normal)
    }
    
    private func setViews() {
        addSubview(textLabel)
        addSubview(expandButton)
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLabel.leftAnchor.constraint(equalTo: leftAnchor),
            textLabel.topAnchor.constraint(equalTo: topAnchor),
            textLabel.rightAnchor.constraint(equalTo: rightAnchor),
            textLabel.bottomAnchor.constraint(equalTo: expandButton.topAnchor)
            ])
        
        expandButton.translatesAutoresizingMaskIntoConstraints = false
        expandButtonHeightConstaint = expandButton.heightAnchor.constraint(equalToConstant: lineHeight)
        expandButtonHeightConstaint?.isActive = true
        NSLayoutConstraint.activate([
            expandButton.leftAnchor.constraint(equalTo: leftAnchor),
            expandButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            ])
    }
}
