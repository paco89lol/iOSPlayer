////
////  ViewController.swift
////  TestPlay
////
////  Created by Pakho Yeung on 4/22/19.
////  Copyright © 2019 Pakho Yeung. All rights reserved.
////
//
//import UIKit
//import AVKit
//import MediaPlayer
//
//class ViewController: UIViewController {
//
//    var player: AVPlayer!
//    var playerLayer: AVPlayerLayer!
//    var playerLayerSuperView: UIView!
//    var videoBasicControllBar: UIView!
//    var videoAdvancedControlView: UIView!
//    
//    var playerViewVerticalPanGesture: UIGestureRecognizer!
//    var playerViewHorizontalPanGesture: UIGestureRecognizer!
//    var playerViewTapGesture:UIGestureRecognizer!
//    
//    var fakeCollectionView: UIView!
//    
//    var playerHeightConstraint: NSLayoutConstraint!
//    var playerWidthConstraint: NSLayoutConstraint!
//    var playerTopConstraint:NSLayoutConstraint!
//    var playercenterYConstraint: NSLayoutConstraint?
//    
//    var firstTimeAtScreem = true
//    var isFullScreen: Bool = false
//    var timerToHideVideoBasicController: Timer?
//    
//    var volumeView = MPVolumeView()
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        if firstTimeAtScreem {
//            firstTimeAtScreem = false
//            
//            playerLayer.frame = playerLayerSuperView.bounds
//            player.play()
//            startToCountHideVideoPlayerController()
//        }
//    }
//    
//    func originalScreenPlay() {
//    
//        self.playerWidthConstraint.isActive = false
//        self.playerHeightConstraint.isActive = false
//        self.playerLayerSuperView.removeConstraint(self.playerWidthConstraint)
//        self.playerLayerSuperView.removeConstraint(self.playerHeightConstraint)
//        
//        if let playercenterYConstraint = self.playercenterYConstraint {
//            playercenterYConstraint.isActive = false
//            self.playerLayerSuperView.removeConstraint(playercenterYConstraint)
//        }
//        
//        self.playerTopConstraint.isActive = true
//        playerWidthConstraint = playerLayerSuperView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
//        playerWidthConstraint.isActive = true
//        playerHeightConstraint = playerLayerSuperView.heightAnchor.constraint(equalTo: playerLayerSuperView.widthAnchor, multiplier: 9.0/16.0)
//        playerHeightConstraint.isActive = true
//        
//        let affineTransform = CGAffineTransform(rotationAngle: (CGFloat.pi * 0.0 / 180.0))
//        self.playerLayerSuperView.layer.setAffineTransform(affineTransform)
//    }
//    
//    func fullScreenPlay() {
//        self.playerTopConstraint.isActive = false
//        self.playerWidthConstraint.isActive = false
//        self.playerHeightConstraint.isActive = false
////        self.playerLayerSuperView.removeConstraint(self.playerTopConstraint)
//        self.playerLayerSuperView.removeConstraint(self.playerWidthConstraint)
//        self.playerLayerSuperView.removeConstraint(self.playerHeightConstraint)
//        
//        if let playercenterYConstraint = self.playercenterYConstraint {
//            playercenterYConstraint.isActive = false
//            self.playerLayerSuperView.removeConstraint(playercenterYConstraint)
//        }
//        
//        self.playercenterYConstraint = self.playerLayerSuperView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
//        self.playercenterYConstraint?.isActive = true
//        
//        self.playerWidthConstraint = self.playerLayerSuperView.widthAnchor.constraint(equalTo: self.view/*.safeAreaLayoutGuide*/.heightAnchor)
//        self.playerWidthConstraint.isActive = true
//        
//        self.playerHeightConstraint = self.playerLayerSuperView.heightAnchor.constraint(equalTo: self.view/*.safeAreaLayoutGuide*/.widthAnchor)
//        self.playerHeightConstraint.isActive = true
//        
//        let affineTransform = CGAffineTransform(rotationAngle: (CGFloat.pi * 90.0 / 180.0))
//        self.playerLayerSuperView.layer.setAffineTransform(affineTransform)
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        self.playerLayer.frame = self.playerLayerSuperView.bounds
//    }
//    
//    @objc func fullScreenButtonDidPress(_ sender: Any) {
//        if !isFullScreen {
//            isFullScreen = true
//            fullScreenPlay()
//        } else {
//            isFullScreen = false
//            originalScreenPlay()
//        }
//    }
//    
//    func changeSpeakerSliderPanelControls(changeValue: Float) {
//        for subview in self.volumeView.subviews {
//            if subview.description.contains("MPVolumeSlider") == true {
//                let slider = subview as! UISlider
//                slider.isContinuous = false
//                slider.value += changeValue
//                
//                break
//            }
//        }
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        volumeView.clipsToBounds = true
//        view.addSubview(volumeView)
//        
//        let url = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
//        player = AVPlayer(playerItem: AVPlayerItem(asset: AVAsset(url: url)))
//        playerLayer = AVPlayerLayer(player: player)
//        
////        playerLayer.shouldRasterize = true
////        playerLayer.rasterizationScale = UIScreen.main.scale
////        playerLayer.contentsGravity = .resizeAspect
//        
//        playerLayerSuperView = UIView()
//        playerLayerSuperView.layer.addSublayer(playerLayer)
//        playerLayerSuperView.backgroundColor = UIColor.black
//        view.addSubview(playerLayerSuperView)
//        playerLayerSuperView.translatesAutoresizingMaskIntoConstraints = false
//        playerLayerSuperView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        playerTopConstraint = playerLayerSuperView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)
//        playerTopConstraint.isActive = true
//        playerWidthConstraint = playerLayerSuperView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
//        playerWidthConstraint.isActive = true
//        playerHeightConstraint = playerLayerSuperView.heightAnchor.constraint(equalTo: playerLayerSuperView.widthAnchor, multiplier: 9.0/16.0)
//        playerHeightConstraint.isActive = true
//        
//        let soundButton = UIButton()
//        soundButton.backgroundColor = UIColor.blue
//        
//        let fullScreenButton = UIButton()
//        fullScreenButton.backgroundColor = UIColor.green
//        fullScreenButton.addTarget(self, action: #selector(fullScreenButtonDidPress(_:)), for: .touchUpInside)
//        
//        videoBasicControllBar = { (playerView: UIView, buttons: [UIButton]) -> UIView in
//            let controllBar = UIView()
//            controllBar.layer.cornerRadius = 5
//            controllBar.backgroundColor = UIColor.darkGray.withAlphaComponent(0.7)
//            playerView.addSubview(controllBar)
//            controllBar.translatesAutoresizingMaskIntoConstraints = false
//            controllBar.leadingAnchor.constraint(equalTo: playerView.readableContentGuide.leadingAnchor, constant: 5).isActive = true
//            controllBar.trailingAnchor.constraint(equalTo: playerView.readableContentGuide.trailingAnchor, constant: -5).isActive = true
//            controllBar.heightAnchor.constraint(equalToConstant: 35).isActive = true
//            controllBar.bottomAnchor.constraint(equalTo: playerView.readableContentGuide.bottomAnchor, constant: -2).isActive = true
//            
//            let stackView = UIStackView()
//            stackView.axis = .horizontal
//            stackView.spacing = 8
//            stackView.alignment = .center
//            controllBar.addSubview(stackView)
//            stackView.translatesAutoresizingMaskIntoConstraints = false
//            stackView.leadingAnchor.constraint(equalTo: controllBar.leadingAnchor, constant: 2).isActive = true
//            stackView.trailingAnchor.constraint(equalTo: controllBar.trailingAnchor, constant: -2).isActive = true
//            stackView.heightAnchor.constraint(equalToConstant: 20).isActive = true
//            stackView.centerYAnchor.constraint(equalTo: controllBar.centerYAnchor).isActive = true
//            
//            let currentPlayTimeLabel = UILabel()
//            currentPlayTimeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
//            currentPlayTimeLabel.text = "00:00"
//            currentPlayTimeLabel.font = UIFont.boldSystemFont(ofSize: 14)
//            currentPlayTimeLabel.textAlignment = .right
//            stackView.addArrangedSubview(currentPlayTimeLabel)
//            currentPlayTimeLabel.translatesAutoresizingMaskIntoConstraints = false
//            
//            
//            let slider = UISlider()
//            stackView.addArrangedSubview(slider)
//            slider.translatesAutoresizingMaskIntoConstraints = false
//            slider.minimumTrackTintColor = UIColor.red
//            slider.maximumTrackTintColor = UIColor.white
//            slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
//            slider.widthAnchor.constraint(greaterThanOrEqualToConstant: 1).isActive = true
//
//            slider.addTarget(self, action: #selector(handleSliderChange(_:)), for: .valueChanged)
//            
//            for button in buttons {
//                stackView.addArrangedSubview(button)
//                button.translatesAutoresizingMaskIntoConstraints = false
//                button.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
//                button.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
//            }
//            
//            return controllBar
//        }(playerLayerSuperView, [soundButton, fullScreenButton])
//        
//        let rewindButton = UIButton()
//        rewindButton.setImage(UIImage(named: "icon_player_rewind"), for: .normal)
//        rewindButton.addTarget(self, action: #selector(playRewind(_:)), for: .touchUpInside)
//        
//        let playButton = UIButton()
//        playButton.setImage(UIImage(named: "icon_player_play"), for: .normal)
//        playButton.addTarget(self, action: #selector(play(_:)), for: .touchUpInside)
//        let pauseButton = UIButton()
//        pauseButton.setImage(UIImage(named: "icon_player_pause"), for: .normal)
//        pauseButton.addTarget(self, action: #selector(pause(_:)), for: .touchUpInside)
//        let forwardButton = UIButton()
//        forwardButton.setImage(UIImage(named: "icon_player_forward"), for: .normal)
//        forwardButton.addTarget(self, action: #selector(playForward(_:)), for: .touchUpInside)
//        
//        videoAdvancedControlView = { (playerView: UIView, buttons: [UIButton]) -> UIView in
//            let contentView = UIView()
//            playerView.addSubview(contentView)
//            contentView.translatesAutoresizingMaskIntoConstraints = false
//            contentView.centerXAnchor.constraint(equalTo: playerView.centerXAnchor, constant: 0).isActive = true
//            contentView.centerYAnchor.constraint(equalTo: playerView.centerYAnchor, constant: 0).isActive = true
//            contentView.leadingAnchor.constraint(equalTo: playerView.leadingAnchor, constant: 0).isActive = true
//            contentView.trailingAnchor.constraint(equalTo: playerView.trailingAnchor, constant: 0).isActive = true
//            contentView.heightAnchor.constraint(equalToConstant: 50).isActive = true
//            
////            let verticalStackView = UIStackView()
////            verticalStackView.spacing = 0
////            verticalStackView.axis = .vertical
////            verticalStackView.distribution = .equalSpacing
////            verticalStackView.alignment = .center
////            contentView.addSubview(verticalStackView)
////            verticalStackView.translatesAutoresizingMaskIntoConstraints = false
////            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
////            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
////            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
////            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
//            
//            let stackView = UIStackView()
//            stackView.spacing = 8
//            stackView.axis = .horizontal
//            stackView.distribution = .fill
//            stackView.alignment = .center
//            contentView.addSubview(stackView)
//            stackView.translatesAutoresizingMaskIntoConstraints = false
//            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
//            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
//            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
//            
//            for button in buttons {
//                stackView.addArrangedSubview(button)
//                button.translatesAutoresizingMaskIntoConstraints = false
//                button.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
//                button.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
//            }
//            
//            return contentView
//        }(playerLayerSuperView, [rewindButton, playButton, pauseButton, forwardButton])
//        
//        let playerSlider = PlayerSlider()
//        playerLayerSuperView.addSubview(playerSlider)
//        playerSlider.translatesAutoresizingMaskIntoConstraints = false
//        playerSlider.leadingAnchor.constraint(equalTo: playerLayerSuperView.leadingAnchor, constant: 0).isActive = true
//        playerSlider.trailingAnchor.constraint(equalTo: playerLayerSuperView.trailingAnchor, constant: 0).isActive = true
//        playerSlider.topAnchor.constraint(equalTo: playerLayerSuperView.topAnchor, constant: 60).isActive = true
//        playerSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        
//        playerSlider.setCurrentPlayValue(0.2)
//        playerSlider.setBufferedValue(0.5)
//        
//        _ = { (playerView:UIView, viewController: UIViewController) -> Void in
//            playerViewHorizontalPanGesture = PanDirectionGestureRecognizer(direction: .horizontal, target: viewController, action: #selector(horizontalPanGestureCallBack(_:)))
//            playerView.addGestureRecognizer(playerViewHorizontalPanGesture)
//            
//            playerViewVerticalPanGesture = PanDirectionGestureRecognizer(direction: .vertical, target: viewController, action: #selector(verticalPanGestureCallBack(_:)))
//            playerView.addGestureRecognizer(playerViewVerticalPanGesture)
//            
//            playerViewTapGesture = UITapGestureRecognizer(target: viewController, action: #selector(tapGestureCallBack(_:)))
//            playerView.addGestureRecognizer(playerViewTapGesture)
//        }(playerLayerSuperView, self)
//        
////        let fullScreenButton = UIButton()
////        fullScreenButton.backgroundColor = UIColor.green
////        fullScreenButton.setTitle("full", for: .normal)
////        fullScreenButton.addTarget(self, action: #selector(fullScreenButtonDidPress(_:)), for: .touchUpInside)
////        playerLayerSuperView.addSubview(fullScreenButton)
////        fullScreenButton.translatesAutoresizingMaskIntoConstraints = false
////        fullScreenButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
////        fullScreenButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
////        fullScreenButton.bottomAnchor.constraint(equalTo: playerLayerSuperView.safeAreaLayoutGuide.bottomAnchor, constant: -5).isActive = true
////        fullScreenButton.trailingAnchor.constraint(equalTo: playerLayerSuperView.safeAreaLayoutGuide.trailingAnchor, constant: -5).isActive = true
//        
//        
//        fakeCollectionView = UIView()
//        fakeCollectionView.backgroundColor = UIColor.blue
//        view.addSubview(fakeCollectionView)
//        fakeCollectionView.translatesAutoresizingMaskIntoConstraints = false
//        fakeCollectionView.topAnchor.constraint(equalTo: playerLayerSuperView.bottomAnchor, constant: 0).isActive = true
//        fakeCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
//        fakeCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
//        fakeCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
//        
//        playerLayerSuperView.bringSubviewToFront(fullScreenButton)
//        view.bringSubviewToFront(playerLayerSuperView)
//    }
//    
//    @objc func horizontalPanGestureCallBack(_ recognizer: UIPanGestureRecognizer) {
//        let isUpVolume = recognizer.translation(in: playerLayerSuperView).x > 0
//        let piece: Float = 0.02
//        switch recognizer.state {
//        case .began: break
//            //show view
//        case .possible: break
//        case .changed:
//        if isUpVolume {
//            //changeSpeakerSliderPanelControls(changeValue: piece)
//        } else {
//            //changeSpeakerSliderPanelControls(changeValue: -piece)
//        }
//        case .ended: break
//            //hide view
//        case .cancelled: break
//        case .failed: break
//        default:
//            return
//        }
//    }
//    
//    @objc func verticalPanGestureCallBack(_ recognizer: UIPanGestureRecognizer) {
//        
//        let point = recognizer.location(in: playerLayerSuperView)
//        var isLeft: Bool
//    
//        if point.x > playerLayerSuperView.bounds.width / 2 {
//            isLeft = false
//        } else {
//            isLeft = true
//        }
//    
//        let isUp = recognizer.translation(in: playerLayerSuperView).y <= 0
//        switch recognizer.state {
//        case .began: break
//        case .possible: break
//        case .changed:
//            if isLeft {
//                let piece: Float = 0.02
//                if isUp {
//                    changeSpeakerSliderPanelControls(changeValue: piece)
//                } else {
//                    changeSpeakerSliderPanelControls(changeValue: -piece)
//                }
//            } else {
//                let piece: CGFloat = 0.05
//                if isUp {
//                    UIScreen.main.brightness += piece
//                } else {
//                    UIScreen.main.brightness -= piece
//                }
//            }
//        
//        case .ended: break
//        case .cancelled: break
//        case .failed: break
//        default:
//            return
//        }
//    }
//    
//    @objc func tapGestureCallBack(_ recognizer: UITapGestureRecognizer) {
//        if !videoBasicControllBar.isHidden {
//            videoBasicControllBar.isHidden = true
//            timerToHideVideoBasicController?.invalidate()
//        } else {
//            videoBasicControllBar.isHidden = false
//            startToCountHideVideoPlayerController()
//        }
//        
//    }
//    
//    func startToCountHideVideoPlayerController() {
//        timerToHideVideoBasicController?.invalidate()
//        Timer.scheduledTimer(withTimeInterval: 6, repeats: false, block: {_ in
//            self.videoBasicControllBar.isHidden = true
////            UIView.animate(withDuration: 0.3, animations: {
////                self.videoBasicControllBar.isHidden = true
////            }, completion: nil)
//        })
//    }
//    
//    func avaiableDuration() -> TimeInterval {
//        if let firstTimeRange = player.currentItem?.loadedTimeRanges.first {
//            let timeRange = firstTimeRange.timeRangeValue
//            let startSeconds = CMTimeGetSeconds(timeRange.start)
//            let durationSeconds = CMTimeGetSeconds(timeRange.duration)
//            return startSeconds + durationSeconds
//        } else {
//            return 0
//        }
//    }
//    
//    @objc func handleSliderChange(_ sender: UISlider) {
//        print(sender.value)
//        if let duration = player.currentItem?.duration {
//            let totalSeconds = CMTimeGetSeconds(duration)
//            let value =  Float64(sender.value) * totalSeconds
//            let seekTime = CMTime(value: CMTimeValue(value), timescale: 1)
//            player?.seek(to: seekTime, completionHandler: { (success) in
//                
//            })
//        }
//    }
//    
//    func currentPlayTime(_ time: CMTime) {
//        let total = CMTimeGetSeconds(time)
//        let seconds = Int(total) % 60
//        let minutes = String(format: "%02d", (Int(total) / 60))
//        _ = "\(minutes):\(seconds)"
//    }
//    
//    func trackPlayerProgress() {
//        let interval =  CMTime(value: 1, timescale: 2)
//        player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { [unowned self] (progressTime) in
//            let total = CMTimeGetSeconds(progressTime)
//            let seconds = Int(total) % 60
//            let minutes = String(format: "%02d", (Int(total) / 60))
//            _ = "\(minutes):\(seconds)"
//            
//            if let duration = self.player.currentItem?.duration {
//                let durationSeconds = CMTimeGetSeconds(duration)
//                //slider.value = Float(seconds/durationSeconds)
//            }
//        })
//    }
//    
//    @objc func playRewind(_ sender: UIButton) {
//        let second = 15
//        if let currentTime = self.player.currentItem?.currentTime() {
//            var newTime = CMTimeGetSeconds(currentTime) - Float64(second)
//            if newTime <= 0.0 {
//                newTime = 0
//            }
//            player.seek(to: CMTime(value: CMTimeValue(newTime), timescale: 1))
//        }
//    }
//    
//    @objc func playForward(_ sender: UIButton) {
//        let second = 15
//        if let currentTime = self.player.currentItem?.currentTime() {
//            var newTime = CMTimeGetSeconds(currentTime) + Float64(second)
//            if newTime <= 0.0 {
//                newTime = 0
//            }
//            player.seek(to: CMTime(value: CMTimeValue(newTime), timescale: 1))
//        }
//    }
//    
//    @objc func play(_ sender: UIButton) {
//        player.play()
//    }
//    
//    @objc func pause(_ sender: UIButton) {
//        player.pause()
//    }
//    
//}
//
