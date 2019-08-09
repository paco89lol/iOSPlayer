//

import Foundation
import UIKit

class PlayerViewLoader: UIControl {
    
    public struct Configuration {
        var tintColor: UIColor
        var backgroundColor: UIColor
        public static let `default`: Configuration = Configuration(tintColor: UIColor(red: 255.0/255.0, green: 105.0/255.0, blue: 180.0/255.0, alpha: 1), backgroundColor: UIColor.black.withAlphaComponent(0.5))
    }
    
    var configuration: PlayerViewLoader.Configuration!
    
    var activityIndicatorView: UIActivityIndicatorView!
    var imageView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        
        activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.stopAnimating()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicatorView)
        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        
        imageView = UIImageView()
        imageView.image = UIImage(named: "icon_player_error")?.withRenderingMode(.alwaysTemplate)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        setView(with: Configuration.default)
    }
    
    func setView(with configuration: PlayerViewLoader.Configuration) {
        self.configuration = configuration
        backgroundColor = self.configuration.backgroundColor
        imageView.tintColor = self.configuration.tintColor
        activityIndicatorView.tintColor = self.configuration.tintColor
    }
    
    func showNothing() {
        activityIndicatorView.isHidden = true
        imageView.isHidden = true
    }
    
    func showFailure() {
        activityIndicatorView.isHidden = true
        activityIndicatorView.stopAnimating()
        imageView.isHidden = false
        
    }
    
    func showWaitingToPlay() {
        imageView.isHidden = true
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
    }
    
    func hide(_ isHide: Bool) {
        self.isHidden = isHide
    }
    
    func startLoading() {
        activityIndicatorView.startAnimating()
    }
    
    func stopLoading() {
        activityIndicatorView.stopAnimating()
    }
    
}
