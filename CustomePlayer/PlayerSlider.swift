//

import Foundation
import UIKit

class PlayerSlider: UISlider, PlayerSliderOperatable {
    
    public struct Configuration {
        var minimumTrackTintColor: UIColor
        var maximumTrackTintColor: UIColor
        var progressTintColor: UIColor
        var backgroundColor: UIColor
        
        public static let `default`: Configuration = Configuration(minimumTrackTintColor: UIColor(red: 255.0/255.0, green: 105.0/255.0, blue: 180.0/255.0, alpha: 1), maximumTrackTintColor: UIColor.gray.withAlphaComponent(0.5), progressTintColor: UIColor.lightGray.withAlphaComponent(0.8), backgroundColor: UIColor.clear)
    }
    
    var configuration: PlayerSlider.Configuration?
    
    var progressView: UIProgressView!
    var lastSliderValue: Float!
    var debounceTimer: Timer?
    
    weak var delegate: PlayerSliderUpdateDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        lastSliderValue = 0.0
        
        isUserInteractionEnabled = true
        minimumTrackTintColor = PlayerSlider.Configuration.default.minimumTrackTintColor
        maximumTrackTintColor = .clear
        let image = UIImage(named: "icon_slider_thumb")?.scale(with: CGSize(width: 20, height: 20))?.withRenderingMode(.alwaysTemplate)
        setThumbImage(image, for: .normal)
        tintColor = PlayerSlider.Configuration.default.minimumTrackTintColor
        addTarget(self, action: #selector(handlePlayerSliderValueChange(_:)), for: .valueChanged)
        addTarget(self, action: #selector(handlePlayerSliderOnTouchUp(_:)), for: .touchUpInside)
        addTarget(self, action: #selector(handlePlayerSliderOnTouchDown(_:)), for: .touchDown)
        progressView = UIProgressView()
        progressView.isUserInteractionEnabled = false
        progressView.backgroundColor = .clear
        progressView.progressTintColor = PlayerSlider.Configuration.default.progressTintColor
        progressView.trackTintColor = PlayerSlider.Configuration.default.maximumTrackTintColor
        addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        progressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        progressView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 1.7).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        sendSubviewToBack(progressView)
    }
    
    public func setView(with configuration: PlayerSlider.Configuration) {
        self.configuration = configuration
        minimumTrackTintColor = self.configuration?.minimumTrackTintColor
        tintColor = self.configuration?.minimumTrackTintColor
        progressView.progressTintColor = self.configuration?.progressTintColor
        progressView.trackTintColor = self.configuration?.maximumTrackTintColor
        self.backgroundColor = self.configuration?.backgroundColor
    }
    
    @objc func handlePlayerSliderValueChange(_ sender: UISlider) {
        delegate?.playerSliderOnPanValueChange(value: sender.value)
//        lastSliderValue = sender.value
//        debounce(seconds: 0.2, function: { [weak self] in
//            print("\(sender.value)")
//            self?.delegate?.playerSliderOnPanValueChange(value: sender.value)
//        })
    }
    
    @objc func handlePlayerSliderOnTouchUp(_ sender: UISlider) {
        delegate?.playerSliderOnTouchUp(value: sender.value)
    }
    
    @objc func handlePlayerSliderOnTouchDown(_ sender: UISlider) {
        delegate?.playerSliderOnTouchDown(value: sender.value)
    }
    
//    private func debounce(seconds: TimeInterval, function: @escaping () -> Swift.Void ) {
//        debounceTimer?.invalidate()
//        debounceTimer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false, block: { _ in
//            function()
//        })
//    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = super.trackRect(forBounds: bounds)
        newBounds.size.height = 4
        return newBounds
    }
    
    // Interface: - PlayerSliderOperatable
    
    func setBufferedValue(_ value: Float) {
        progressView.setProgress(value, animated: false)
    }
    
    func setCurrentPlayValue(_ value: Float) {
        self.value = value
    }
}

extension UIImage {
    
    func scale(with size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage:UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

public protocol PlayerSliderOperatable {
    func setBufferedValue(_ value: Float)
    func setCurrentPlayValue(_ value: Float)
}


public protocol PlayerSliderUpdateDelegate: AnyObject {
    func playerSliderOnPanValueChange(value: Float)
    func playerSliderOnTouchUp(value: Float)
    func playerSliderOnTouchDown(value: Float)
}
