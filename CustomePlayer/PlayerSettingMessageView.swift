//

import Foundation
import UIKit

class PlayerSettingMessageView: UIControl {
    
    public struct Configuration {
        var tintColor: UIColor
        var textColor: UIColor
        var backgroundColor: UIColor
        public static let `default`: Configuration = Configuration(tintColor: UIColor(red: 255.0/255.0, green: 105.0/255.0, blue: 180.0/255.0, alpha: 1), textColor: UIColor.white, backgroundColor: UIColor.black.withAlphaComponent(0.5))
    }
    
    var configuration: PlayerSettingMessageView.Configuration!
    
    var imageView: UIImageView!
    var titleLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        
        layer.cornerRadius = 5
        layer.masksToBounds = true
        
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10).isActive = true
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 3).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        
        setView(with: Configuration.default)
    }
    
    func setView(with configuration: PlayerSettingMessageView.Configuration) {
        self.configuration = configuration
        backgroundColor = self.configuration.backgroundColor
        imageView.tintColor = self.configuration.tintColor
        titleLabel.textColor = self.configuration.textColor
    }
    
    
}
