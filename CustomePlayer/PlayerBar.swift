//

import Foundation
import UIKit

class PlayerBar: UIControl, PlayerSliderUpdateDelegate {
    
    public struct Configuration {
        var tintColor: UIColor
        var backgroundColor: UIColor
        public static let `default`: Configuration = Configuration(tintColor: UIColor.white, backgroundColor: UIColor.black.withAlphaComponent(0.5))
    }
    
    var configuration: PlayerBar.Configuration!
    
    private var contentStackView: UIStackView!
    
    private var leftStackView: UIStackView!
    var playerSlider: PlayerSlider!
    private var timeLabelView: UILabel!
    private var rightStackView: UIStackView!
    
    /* quick fix */
    var fullScreenButton: PlayerButton!
    
    weak var delegate: PlayerBarDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        
        configuration = Configuration.default
        
        backgroundColor = configuration.backgroundColor
        
        contentStackView = UIStackView()
        contentStackView.axis = .horizontal
        contentStackView.spacing = 8
        contentStackView.distribution = .fill
        contentStackView.alignment = .center
        self.addSubview(contentStackView)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        contentStackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        let createStackViewBlock = { () -> UIStackView in
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.spacing = 1
            stackView.alignment = .center
            stackView.distribution = .fill
            return stackView
        }
        
        leftStackView = createStackViewBlock()
        contentStackView.addArrangedSubview(leftStackView)
        
        playerSlider = PlayerSlider()
        playerSlider.delegate = self
        playerSlider.setView(with: PlayerSlider.Configuration.default)
        playerSlider.translatesAutoresizingMaskIntoConstraints = false
        playerSlider.widthAnchor.constraint(greaterThanOrEqualToConstant: 1).isActive = true
        playerSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        contentStackView.addArrangedSubview(playerSlider)
        
        timeLabelView = UILabel()
        timeLabelView.textColor = configuration.tintColor
        timeLabelView.text = "00:00:00"
        timeLabelView.textAlignment = .center
        timeLabelView.adjustsFontSizeToFitWidth = true
        timeLabelView.translatesAutoresizingMaskIntoConstraints = false
        timeLabelView.widthAnchor.constraint(lessThanOrEqualToConstant: 50).isActive = true
        timeLabelView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        contentStackView.addArrangedSubview(timeLabelView)
        
        rightStackView = createStackViewBlock()
        contentStackView.addArrangedSubview(rightStackView)
        
        setLeftViews([createSoundButton()])
        
        setRightViews([createFullScreenButton()])
    }
    
    public func setView(with configuration: PlayerBar.Configuration) {
        self.configuration = configuration
        backgroundColor = self.configuration.backgroundColor
        timeLabelView.textColor = self.configuration.tintColor
        leftStackView.arrangedSubviews.forEach({ [unowned self] in
            if let playerButton = $0 as? PlayerButton {
                playerButton.tintColor = self.configuration.tintColor
            }
        })
        rightStackView.arrangedSubviews.forEach({ [unowned self] in
            if let playerButton = $0 as? PlayerButton {
                playerButton.tintColor = self.configuration.tintColor
            }
        })
    }
    
    public func setCurrentPlayValue(_ value: Float) {
        playerSlider.setCurrentPlayValue(value)
    }
    
    public func setBufferedValue(_ value: Float) {
        playerSlider.setBufferedValue(value)
    }
    
    public func setTimeLabel(currentTime: String) {
        timeLabelView.text = "\(currentTime)"
    }
    
    private func createFullScreenButton() -> PlayerButton {
        let button = PlayerButton()
        fullScreenButton = button
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 25).isActive = true
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
        button.tintColor = configuration.tintColor
        button.flag = false
        button.addTarget(self, action: #selector(handlePlayerBarButtonsClickEvent(_:)), for: .touchUpInside)
        button.setImage(UIImage(named: "icon_player_full_screen")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.onClickHandler = { [weak self] (sender) in
            if let sender = sender as? PlayerButton {
                if !sender.flag {
                    sender.flag = true
                    button.setImage(UIImage(named: "icon_player_normal_screen")?.withRenderingMode(.alwaysTemplate), for: .normal)
                    self?.delegate?.playerBarFullScreen()
                } else {
                    sender.flag = false
                    button.setImage(UIImage(named: "icon_player_full_screen")?.withRenderingMode(.alwaysTemplate), for: .normal)
                    self?.delegate?.playerBarNormalScreen()
                }
            }
        }
        return button
    }
    
    private func createSoundButton() -> PlayerButton {
        let button = PlayerButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 25).isActive = true
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
        button.tintColor = configuration.tintColor
        button.flag = false
        button.addTarget(self, action: #selector(handlePlayerBarButtonsClickEvent(_:)), for: .touchUpInside)
        
        button.setImage(UIImage(named: "icon_player_sound")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.onClickHandler = { [weak self] (sender) in
            if let sender = sender as? PlayerButton {
                if !sender.flag {
                    sender.flag = true
                    button.setImage(UIImage(named: "icon_player_sound_muted")?.withRenderingMode(.alwaysTemplate), for: .normal)
                    self?.delegate?.playerBarMute()
                } else {
                    sender.flag = false
                    button.setImage(UIImage(named: "icon_player_sound")?.withRenderingMode(.alwaysTemplate), for: .normal)
                    self?.delegate?.playerBarUnmute()
                }
            }
        }
        
        return button
    }
    
    func setFullScreenButton(flag: Bool) {
        if !flag {
            fullScreenButton.flag = true
            fullScreenButton.setImage(UIImage(named: "icon_player_normal_screen")?.withRenderingMode(.alwaysTemplate), for: .normal)
        } else {
            fullScreenButton.flag = false
            fullScreenButton.setImage(UIImage(named: "icon_player_full_screen")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    @objc func handlePlayerBarButtonsClickEvent(_ sender: UIButton) {
        if let button = sender as? PlayerButton {
            button.onClickHandler?(sender)
        }
    }
    
    private func setLeftViews(_ views: [PlayerButton]) {
        let subViews = leftStackView.arrangedSubviews
        subViews.forEach({
            leftStackView.removeArrangedSubview($0)
        })

        for view in views {
            leftStackView.addArrangedSubview(view)
        }
    }

    private func setRightViews(_ views: [PlayerButton]) {
        let subViews = rightStackView.arrangedSubviews
        subViews.forEach({
            rightStackView.removeArrangedSubview($0)
        })

        for view in views {
            rightStackView.addArrangedSubview(view)
        }
    }
    
    // Delegate: - PlayerSliderUpdateDelegate
    
    func playerSliderOnPanValueChange(value: Float) {
        delegate?.playerSliderOnPan(value: value)
    }
    
    func playerSliderOnTouchUp(value: Float) {
        delegate?.playerSliderOnTouchUp(value: value)
    }
    
    func playerSliderOnTouchDown(value: Float) {
        delegate?.playerSliderOnTouchDown(value: value)
    }
}

protocol PlayerBarDelegate: AnyObject {
    
    func playerBarFullScreen()
    func playerBarNormalScreen()
    func playerBarMute()
    func playerBarUnmute()
    func playerSliderOnPan(value: Float)
    func playerSliderOnTouchUp(value: Float)
    func playerSliderOnTouchDown(value: Float)
}
