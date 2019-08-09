//

import Foundation
import UIKit

protocol PlayerSettingValueUpdataDelegate: AnyObject {
    func onValueChange(_ value: Float)
}

class PlayerSettingView: UIControl {
    
    public struct Configuration {
        var image: UIImage?
        var imageTintColor: UIColor
        var minimumTrackTintColor: UIColor
        var maximumTrackTintColor: UIColor
        var backgroundColor: UIColor

        public static let `default`: Configuration = Configuration(image: nil, imageTintColor: UIColor.blue, minimumTrackTintColor: UIColor.blue, maximumTrackTintColor: UIColor.lightGray, backgroundColor: UIColor.darkGray)
    }
    
    var configuration: PlayerSettingView.Configuration!
    
    var view: UIView!
    var imageView: UIImageView!
    var slider: UISlider!

    var lastSliderValue: Float!
    var debounceTimer: Timer?
    
    weak var playerSettingValueUpdataDelegate: PlayerSettingValueUpdataDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        
        lastSliderValue = 0
        
        self.backgroundColor = PlayerSettingView.Configuration.default.backgroundColor
        
        view = UIView()
        view.layer.cornerRadius = 3
        view.backgroundColor = .clear
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        view.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        imageView = UIImageView()
        imageView.image = PlayerSettingView.Configuration.default.image
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(imageView)
        
        slider = UISlider()
        slider.minimumTrackTintColor = PlayerSettingView.Configuration.default.minimumTrackTintColor
        slider.maximumTrackTintColor = PlayerSettingView.Configuration.default.maximumTrackTintColor
        slider.setThumbImage(UIImage(named: "icon_slider_thumb")?.withRenderingMode(.alwaysTemplate), for: .normal)
        slider.addTarget(self, action: #selector(handleSliderValueChange(_:)), for: .valueChanged)
    }
    
    public func setView(with configuration: PlayerSettingView.Configuration) {
        self.configuration = configuration
        imageView.image = self.configuration.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = self.configuration.imageTintColor
        slider.minimumTrackTintColor = self.configuration.minimumTrackTintColor
        slider.maximumTrackTintColor = self.configuration.maximumTrackTintColor
        self.backgroundColor = self.configuration.backgroundColor
    }
    
    public func setImage(_ image: UIImage?) {
        self.imageView.image = image?.withRenderingMode(.alwaysTemplate)
    }
    
    public func setDelegate(playerSettingValueUpdataDelegate: PlayerSettingValueUpdataDelegate) {
        self.playerSettingValueUpdataDelegate = playerSettingValueUpdataDelegate
    }
    
    /* It would not trigger handleSliderValueChange(sender:) */
    public func setSlider(with value: Float) {
        slider.value = value
    }
    
    @objc func handleSliderValueChange(_ sender: UISlider) {
        lastSliderValue = sender.value
        playerSettingValueUpdataDelegate?.onValueChange(sender.value)
    }
}
