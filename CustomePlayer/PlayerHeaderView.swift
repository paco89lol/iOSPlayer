//

import Foundation
import UIKit

class PlayerHeaderView: UIControl {
    
    public struct Configuration {
        var tintColor: UIColor
        var textColor: UIColor
        var backgroundColor: UIColor
        public static let `default`: Configuration = Configuration(tintColor: UIColor.white, textColor: UIColor.white, backgroundColor: UIColor.black.withAlphaComponent(0.5))
    }
    
    var configuration: PlayerHeaderView.Configuration!
    
    var backButton: PlayerButton!
    var titleLabel: UILabel!
    var shareButton: PlayerButton!
    
    weak var delegate: PlayerHeaderViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        backButton = PlayerButton()
        backButton.setImage(UIImage(named: "icon_player_back_left")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        backButton.addTarget(self, action: #selector(handleButtonClickEvent(_:)), for: .touchUpInside)
        backButton.onClickHandler = { [weak self] (sender) in
            self?.delegate?.playerHeaderViewOnClickBackButton()
        }
        
        titleLabel = UILabel()
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        
        
        let labelContentView = UIView()
        labelContentView.translatesAutoresizingMaskIntoConstraints = false
        labelContentView.widthAnchor.constraint(greaterThanOrEqualToConstant: 1).isActive = true
        labelContentView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        labelContentView.addSubview(titleLabel)
        titleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 1).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: labelContentView.leadingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: labelContentView.trailingAnchor, constant: 0).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: labelContentView.centerYAnchor, constant: 0).isActive = true
        
        shareButton = PlayerButton()
        shareButton.setImage(UIImage(named: "icon_player_share")?.withRenderingMode(.alwaysTemplate), for: .normal)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        shareButton.addTarget(self, action: #selector(handleButtonClickEvent(_:)), for: .touchUpInside)
        shareButton.onClickHandler = { [weak self] (sender) in
            self?.delegate?.playerHeaderViewOnClickShareButton()
        }
        
        stackView.addArrangedSubview(backButton)
        stackView.addArrangedSubview(labelContentView)
        stackView.addArrangedSubview(shareButton)
        
        setView(with: Configuration.default)
    }
    
    func setView(with configuration: PlayerHeaderView.Configuration) {
        self.configuration = configuration
        backgroundColor = self.configuration.backgroundColor
        titleLabel.textColor = self.configuration.textColor
        backButton.tintColor = self.configuration.tintColor
        shareButton.tintColor = self.configuration.tintColor
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func hideBackButton(_ isHide: Bool) {
        backButton.isHidden = isHide
    }
    
    @objc func handleButtonClickEvent(_ sender: UIButton) {
        if let button = sender as? PlayerButton {
            button.onClickHandler?(button)
        }
    }
    
}

protocol PlayerHeaderViewDelegate: AnyObject {
    func playerHeaderViewOnClickBackButton()
    func playerHeaderViewOnClickShareButton()
}
