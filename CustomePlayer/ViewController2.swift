//

import Foundation
import UIKit
import AVKit

class ViewController2: UIViewController, PlayerViewDelegate {
    
//    var player: AVPlayer!
    var playView: PlayerView!
    
    var playerHeightConstraint: NSLayoutConstraint!
    var playerWidthConstraint: NSLayoutConstraint!
    var playerTopConstraint:NSLayoutConstraint!
    var playercenterYConstraint: NSLayoutConstraint?
    
    var isFullScreen: Bool = false
    
    override func viewDidLoad() {
        navigationController?.isNavigationBarHidden = true
        playView = PlayerView()
        playView.delegate = self
        playView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playView)

        playView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playerTopConstraint = playView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80)
        playerTopConstraint.isActive = true
        playerWidthConstraint = playView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        playerWidthConstraint.isActive = true
        playerHeightConstraint = playView.heightAnchor.constraint(equalTo: playView.widthAnchor, multiplier: 9.0/16.0)
        playerHeightConstraint.isActive = true
        
//        let url = URL(string: "https://content.jwplatform.com/manifests/yp34SRmf.m3u8")!
        let url = URL(string: "https://content.jwplatform.com/manifests/yp34SRmf.m3u8")!
        playView.replaceCurrentItem(with: AVPlayerItem(url: url))
        playView.setTitle("nw_protocol_boringssl_get_output_frames(1301) [AudioHAL_Client] AudioHardware.cpp:1210:A")
        playView.play()
//        DispatchQueue.main.asyncAfter(deadline: .now()+5, execute: {
//            self.playView.replaceCurrentItem(with: nil)
//        })
    }
    
    func playerViewFullScreen() {
//        if let keyWindow = UIApplication.shared.keyWindow {
//            let view = UIView(frame: keyWindow.frame)
//
//        }
        fullScreenPlay()
    }
    
    func playerViewNormalScreen() {
        originalScreenPlay()
    }

    override var prefersStatusBarHidden: Bool {
        if isFullScreen {
            return true
        } else {
            return false
        }
    }
    
    func originalScreenPlay() {
        isFullScreen = false
        setNeedsStatusBarAppearanceUpdate()
        self.playerWidthConstraint.isActive = false
        self.playerHeightConstraint.isActive = false
        self.playView.removeConstraint(self.playerWidthConstraint)
        self.playView.removeConstraint(self.playerHeightConstraint)
        
        if let playercenterYConstraint = self.playercenterYConstraint {
            playercenterYConstraint.isActive = false
            self.playView.removeConstraint(playercenterYConstraint)
        }
        
        self.playerTopConstraint.isActive = true
        playerWidthConstraint = playView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        playerWidthConstraint.isActive = true
        playerHeightConstraint = playView.heightAnchor.constraint(equalTo: playView.widthAnchor, multiplier: 9.0/16.0)
        playerHeightConstraint.isActive = true
        
        let affineTransform = CGAffineTransform(rotationAngle: (CGFloat.pi * 0.0 / 180.0))
        self.playView.layer.setAffineTransform(affineTransform)
    }
    
    func fullScreenPlay() {
        isFullScreen = true
        setNeedsStatusBarAppearanceUpdate()
        self.playerTopConstraint.isActive = false
        self.playerWidthConstraint.isActive = false
        self.playerHeightConstraint.isActive = false
        //        self.playerLayerSuperView.removeConstraint(self.playerTopConstraint)
        self.playView.removeConstraint(self.playerWidthConstraint)
        self.playView.removeConstraint(self.playerHeightConstraint)
        
        if let playercenterYConstraint = self.playercenterYConstraint {
            playercenterYConstraint.isActive = false
            self.playView.removeConstraint(playercenterYConstraint)
        }
        
        self.playercenterYConstraint = self.playView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        self.playercenterYConstraint?.isActive = true
        
        self.playerWidthConstraint = self.playView.widthAnchor.constraint(equalTo: self.view/*.safeAreaLayoutGuide*/.heightAnchor)
        self.playerWidthConstraint.isActive = true
        
        self.playerHeightConstraint = self.playView.heightAnchor.constraint(equalTo: self.view/*.safeAreaLayoutGuide*/.widthAnchor)
        self.playerHeightConstraint.isActive = true
        
        let affineTransform = CGAffineTransform(rotationAngle: (CGFloat.pi * 90.0 / 180.0))
        self.playView.layer.setAffineTransform(affineTransform)
    }
    
    func playerViewShare() {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}
