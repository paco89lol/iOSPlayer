//

import Foundation
import UIKit
import AVKit
import MediaPlayer

class PlayerView: UIControl, PlayerBarDelegate, PlayerHeaderViewDelegate {
    
    private var player: AVPlayer! {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    // Override UIView property
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    var playerHeaderView: PlayerHeaderView!
    /* bottom bar */
    var playerBar: PlayerBar!
    /* message view */
    var messageView: PlayerSettingMessageView!
    /* play option */
    var playerControlPanelView: UIView!
    /**/
    var progressBar: PlayerSlider!
    
    var playerViewLoader: PlayerViewLoader!
    /* Gesture Variables */
    var gestureView: UIView!
    var playerViewVerticalPanGesture: UIGestureRecognizer!
    var playerViewHorizontalPanGesture: UIGestureRecognizer!
    var playerViewTapGesture:UIGestureRecognizer!
    var horizontalPanStartPoint: CGPoint?
    
    // Timers
    var timerToHidePlayerControlPanelView: Timer?
    var timerToUpdatePlayerBar: Timer?
    
    /* try to hide the system volume view */
    var volumeView: MPVolumeView!
    /* sound value before Mute */
    var soundValueBeforeMute: Float!
    /* observer for the status change of a player currentItem */
    var playerStopObserver: NSKeyValueObservation?
    var playerStallingObserver: NSKeyValueObservation?
    var readyToPlayObserver: NSKeyValueObservation?
    
    // Flags
    /**/
    var isPlayingBeforeSeek: Bool!
    
    weak var delegate: PlayerViewDelegate?
    
    
    /* Those variables will move to other class later */
    var activityIndicatorView: UIActivityIndicatorView!
    var pauseButton: UIButton!
    var playButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    deinit {
        timerToUpdatePlayerBar?.invalidate()
        timerToUpdatePlayerBar = nil
    }
    
    private func commonInit() {
        player = AVPlayer(playerItem: nil)
        
        playerLayer.videoGravity = .resizeAspect
        backgroundColor = UIColor.black
        
        volumeView = MPVolumeView()
        soundValueBeforeMute = AVAudioSession.sharedInstance().outputVolume
        isPlayingBeforeSeek = true
        
        initPlayerHeaderView()
        initPlayerBar()
        initMessageView()
        initProgressBar()
        initPlayerControlPanelView()
        initGestureView()
        initPlayerViewLoader()
        
        createTimerToUpdatePlayerBar()
        
        // PlayerHeaderView
        playerHeaderView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(playerHeaderView)
        playerHeaderView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        playerHeaderView.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor, constant: 3).isActive = true
        playerHeaderView.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor, constant: -3).isActive = true
        playerHeaderView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // PlayerBar
        playerBar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(playerBar)
        playerBar.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        playerBar.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor, constant: 3).isActive = true
        playerBar.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor, constant: -3).isActive = true
        playerBar.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // ProgressBar
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(progressBar)
        progressBar.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        progressBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        progressBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        progressBar.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
        // MessageView
        messageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(messageView)
        messageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        messageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        messageView.widthAnchor.constraint(equalToConstant: 110).isActive = true
        messageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // GestureView
        gestureView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(gestureView)
        gestureView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        gestureView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        gestureView.topAnchor.constraint(equalTo: playerHeaderView.bottomAnchor, constant: 0).isActive = true
        gestureView.bottomAnchor.constraint(equalTo: playerBar.topAnchor, constant: 0).isActive = true
        
        // PlayerControlPanelView
        playerControlPanelView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(playerControlPanelView)
        playerControlPanelView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        playerControlPanelView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        playerControlPanelView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        playerControlPanelView.widthAnchor.constraint(equalToConstant: 170).isActive = true
        
        playerViewLoader.translatesAutoresizingMaskIntoConstraints = false
        addSubview(playerViewLoader)
        playerViewLoader.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        playerViewLoader.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        playerViewLoader.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        playerViewLoader.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        playerViewLoader.showNothing()
        
        playerHeaderView.isHidden = true
        playerHeaderView.hideBackButton(true)
        messageView.isHidden = true
        playerControlPanelView.isHidden = true
        playerBar.isHidden = true
        progressBar.isHidden = false
    }
    
    private func initPlayerHeaderView() {
        playerHeaderView = PlayerHeaderView()
        playerHeaderView.delegate = self
    }
    
    private func initPlayerBar() {
        playerBar = PlayerBar()
        playerBar.delegate = self
    }
    
    private func initMessageView() {
        messageView = PlayerSettingMessageView()
        messageView.titleLabel.font = UIFont.systemFont(ofSize: 10)
    }
    
    private func initPlayerControlPanelView() {
        playerControlPanelView = UIView()
        playerControlPanelView.backgroundColor = UIColor.clear
        
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        playerControlPanelView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        stackView.centerXAnchor.constraint(equalTo: playerControlPanelView.centerXAnchor, constant: 0).isActive = true
        stackView.centerYAnchor.constraint(equalTo: playerControlPanelView.centerYAnchor, constant: 0).isActive = true
        
        let rewindButton = UIButton()
        rewindButton.setImage(UIImage(named: "icon_player_rewind")?.scale(with: CGSize(width: 40, height: 40))?.withRenderingMode(.alwaysTemplate), for: .normal)
        rewindButton.addTarget(self, action: #selector(playRewind(_:)), for: .touchUpInside)
        playButton = UIButton()
        playButton.setImage(UIImage(named: "icon_player_play")?.scale(with: CGSize(width: 40, height: 40))?.withRenderingMode(.alwaysTemplate), for: .normal)
        playButton.addTarget(self, action: #selector(play(_:)), for: .touchUpInside)
        
        activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.stopAnimating()
        
        pauseButton = UIButton()
        pauseButton.setImage(UIImage(named: "icon_player_pause")?.scale(with: CGSize(width: 40, height: 40))?.withRenderingMode(.alwaysTemplate), for: .normal)
        pauseButton.addTarget(self, action: #selector(pause(_:)), for: .touchUpInside)
        let forwardButton = UIButton()
        forwardButton.setImage(UIImage(named: "icon_player_forward")?.scale(with: CGSize(width: 40, height: 40))?.withRenderingMode(.alwaysTemplate), for: .normal)
        forwardButton.addTarget(self, action: #selector(playForward(_:)), for: .touchUpInside)
        
        let views:[UIView] = [rewindButton, playButton, activityIndicatorView, pauseButton, forwardButton]
        
        for view in views {
            view.tintColor = UIColor.white
            stackView.addArrangedSubview(view)
            view.tintColor = UIColor.white
            view.translatesAutoresizingMaskIntoConstraints = false
            view.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
            view.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        }
    
    }
    
    private func initProgressBar() {
        progressBar = PlayerSlider()
        progressBar.setView(with: PlayerSlider.Configuration(minimumTrackTintColor: UIColor.green, maximumTrackTintColor: UIColor.gray, progressTintColor: UIColor.lightGray, backgroundColor: UIColor.clear))
        progressBar.setThumbImage(UIImage(), for: .normal)
        progressBar.isUserInteractionEnabled = false
    }
    
    private func initGestureView() {
        gestureView = UIView()
        playerViewHorizontalPanGesture = PanDirectionGestureRecognizer(direction: .horizontal, target: self, action: #selector(horizontalPanGestureCallBack(_:)))
        gestureView.addGestureRecognizer(playerViewHorizontalPanGesture)
        
        playerViewVerticalPanGesture = PanDirectionGestureRecognizer(direction: .vertical, target: self, action: #selector(verticalPanGestureCallBack(_:)))
        gestureView.addGestureRecognizer(playerViewVerticalPanGesture)
        
        playerViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureCallBack(_:)))
        gestureView.addGestureRecognizer(playerViewTapGesture)
    }
    
    private func initPlayerViewLoader() {
        playerViewLoader = PlayerViewLoader()
    }
    
    func observeReadyToPlay() {
        
        guard let player = player else {
            fatalError()
        }
        guard let currentItem = player.currentItem else {
            fatalError()
        }
        
        readyToPlayObserver = currentItem.observe(\.status, options: [.new, .old], changeHandler: { [unowned self] (observedCurrentItem, change) in
            print("\(currentItem.status.rawValue)")
            if observedCurrentItem.status == AVPlayerItem.Status.readyToPlay {
                self.playerViewLoader.hide(true)
                print("readyToPlay")
            } else if observedCurrentItem.status == AVPlayerItem.Status.failed {
                self.playerViewLoader.showFailure()
                print("failed")
            }
        })
    }
    
    func observePlayerStalling() {
    
        if let currentItem = player?.currentItem {
            playerStallingObserver = currentItem.observe(\.isPlaybackLikelyToKeepUp, options: [.new, .old], changeHandler: { [unowned self] (observedCurrentItem, change) in
                if observedCurrentItem.isPlaybackLikelyToKeepUp {
                    self.activityIndicatorView.stopAnimating()
                    if self.isPlayingBeforeSeek {
                        self.playButton.isHidden = true
                        self.pauseButton.isHidden = false
                    } else {
                        self.pauseButton.isHidden = true
                        self.playButton.isHidden = false
                    }
//                    print("no stalling")
                } else {
                    self.playButton.isHidden = true
                    self.pauseButton.isHidden = true
                    self.activityIndicatorView.startAnimating()
//                    print("stalling")
                }
            })
            
        }

    }
    
    func createTimerToUpdatePlayerBar() {
        timerToUpdatePlayerBar = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createTimerToUpdatePlayerBarHandler), userInfo: nil, repeats: true)
    }
    
    
    @objc func createTimerToUpdatePlayerBarHandler() {
        if let currentTime = self.player?.currentItem?.currentTime(), let duration = self.player?.currentItem?.duration {
            let currentSeconds = CMTimeGetSeconds(currentTime)
            let seconds = (Int64(currentSeconds) % 3600) % 60
            let minutes = (Int64(currentSeconds) % 3600) / 60
            let hours = Int64(currentSeconds) / 3600
            
            let timeTextBlock = { (number: Int64) -> String in
                return number < 10 ? "0\(number)" : "\(number)"
            }
            
            self.playerBar.setTimeLabel(currentTime: "\(timeTextBlock(hours)):\(timeTextBlock(minutes)):\(timeTextBlock(seconds))")
            
            let sliderCurrentPlayValue = currentSeconds / CMTimeGetSeconds(duration)
            self.playerBar.setCurrentPlayValue(Float(sliderCurrentPlayValue))
            self.progressBar.setCurrentPlayValue(Float(sliderCurrentPlayValue))
        } else {
            self.playerBar.setTimeLabel(currentTime: "00:00:00")
            self.playerBar.setCurrentPlayValue(0.0)
            self.progressBar.setCurrentPlayValue(0.0)
        }
        
        if let firstTimeRange = self.player?.currentItem?.loadedTimeRanges.first, let duration = self.player?.currentItem?.duration {
            let timeRange = firstTimeRange.timeRangeValue
            let startSeconds = CMTimeGetSeconds(timeRange.start)
            let durationSeconds = CMTimeGetSeconds(timeRange.duration)
            let totalLoadedSeconds = startSeconds + durationSeconds
            
            let sliderBufferedValue = totalLoadedSeconds / CMTimeGetSeconds(duration)
            self.playerBar.setBufferedValue(Float(sliderBufferedValue))
            self.progressBar.setBufferedValue(Float(sliderBufferedValue))
        } else {
            self.playerBar.setBufferedValue(0.0)
            self.progressBar.setBufferedValue(0.0)
        }
    }
    
    // Gestures
    
    @objc func horizontalPanGestureCallBack(_ recognizer: UIPanGestureRecognizer) {

        var result: Bool = false
        
        repeat {
            guard let currentItem = player?.currentItem else { break }
            if CMTimeGetSeconds(currentItem.duration).isNaN { break }
            
            hidePlayerDetail()
            
            let duration = Int64(CMTimeGetSeconds(currentItem.duration))
            let current = Int64(CMTimeGetSeconds(currentItem.currentTime()))
            
            switch recognizer.state {
            case .began:
                horizontalPanStartPoint = recognizer.location(in: gestureView)
            case .possible: break
            case .changed:
                guard let horizontalPanStartPoint = horizontalPanStartPoint else { return }
                let startX = horizontalPanStartPoint.x
                let changeX = recognizer.location(in: gestureView).x
                let total = abs(startX - changeX) / 2
                
                if(changeX > startX) {
                    // forward
                    var time: Int64
                    if (current + Int64(total)) > duration {
                        time = duration
                    } else {
                        time = current + Int64(total)
                    }
                    
                    messageView.imageView.image = UIImage(named: "icon_player_forward")
                    messageView.titleLabel.text = "\(PlayerView.secondToPlayerBarTime(timeSeconds: time))/\(PlayerView.secondToPlayerBarTime(timeSeconds: duration))"
                } else {
                    // rewind
                    var time: Int64
                    if (current - Int64(total)) < 0 {
                        time = 0
                    } else {
                        time = current - Int64(total)
                    }
                    
                    messageView.imageView.image = UIImage(named: "icon_player_rewind")
                    messageView.titleLabel.text = "\(PlayerView.secondToPlayerBarTime(timeSeconds: time))/\(PlayerView.secondToPlayerBarTime(timeSeconds: duration))"
                }
                
                messageView.isHidden = false
            case .ended:
                messageView.isHidden = true
                guard let horizontalPanStartPoint = horizontalPanStartPoint else { return }
                let startX = horizontalPanStartPoint.x
                let changeX = recognizer.location(in: gestureView).x
                let seconds = Int(abs(startX - changeX) / 2)
                if(changeX > startX) {
                    forward(second: seconds)
                } else {
                    rewind(second: seconds)
                }
            case .cancelled: break
            case .failed: break
            @unknown default:
                return
            }
            result = true
        } while false
        
        if !result {
            horizontalPanStartPoint = nil
            messageView.isHidden = true
            messageView.titleLabel.text = nil
            messageView.imageView.image = nil
        }
        
    }
    
    @objc func verticalPanGestureCallBack(_ recognizer: UIPanGestureRecognizer) {
        
        hidePlayerDetail()
        
        let point = recognizer.location(in: gestureView)
        var isLeft: Bool
        
        if point.x > gestureView.bounds.width / 2 {
            isLeft = false
        } else {
            isLeft = true
        }
        
        let isUp = recognizer.translation(in: gestureView).y <= 0
        switch recognizer.state {
        case .began: break
        case .possible: break
        case .changed:
            if isLeft {
                let piece: CGFloat = 0.05
                if isUp {
                    UIScreen.main.brightness += piece
                } else {
                    UIScreen.main.brightness -= piece
                }
            } else {
                let piece: Float = 0.02
                if isUp {
                    changeVolume(changeValue: piece)
                } else {
                    changeVolume(changeValue: -piece)
                }
            }
            
        case .ended: break
        case .cancelled: break
        case .failed: break
        default:
            return
        }
    }
    
    @objc func tapGestureCallBack(_ recognizer: UITapGestureRecognizer) {
        if !playerControlPanelView.isHidden {
            UIView.transition(with: self, duration: 0.5, options: .transitionCrossDissolve, animations: { [unowned self] in
                self.hidePlayerDetail()
            })
            timerToHidePlayerControlPanelView?.invalidate()
        } else {
            UIView.transition(with: self, duration: 0.5, options: .transitionCrossDissolve, animations: { [unowned self] in
                self.showPlayerDetail()
            })
            startToCountHideVideoPlayerController()
        }
    }
    
    // END Gestures
    
    func showPlayerDetail() {
        playerHeaderView.isHidden = false
        playerControlPanelView.isHidden = false
        playerBar.isHidden = false
        progressBar.isHidden = true
    }
    
    func hidePlayerDetail() {
        playerHeaderView.isHidden = true
        playerControlPanelView.isHidden = true
        playerBar.isHidden = true
        progressBar.isHidden = false
    }
    
    func startToCountHideVideoPlayerController() {
        timerToHidePlayerControlPanelView?.invalidate()
        timerToHidePlayerControlPanelView = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(startToCountHideVideoPlayerControllerHandler), userInfo: nil, repeats:  false)
    }
    
    @objc func startToCountHideVideoPlayerControllerHandler() {
        UIView.transition(with: self, duration: 0.5, options: .transitionCrossDissolve, animations: { [unowned self] in
            self.hidePlayerDetail()
        })
    }
    
    // Delegate: - PlayerBarDelegate
    
    func playerBarFullScreen() {
        delegate?.playerViewFullScreen()
        playerHeaderView.hideBackButton(false)
    }
    
    func playerBarNormalScreen() {
        delegate?.playerViewNormalScreen()
        playerHeaderView.hideBackButton(true)
    }
    
    func playerBarMute() {
        mute()
    }
    
    func playerBarUnmute() {
        unmute()
    }
    
    func playerSliderOnPan(value: Float) {
        timerToHidePlayerControlPanelView?.invalidate()
        if let duration = player?.currentItem?.duration {
            let currentExpectedSeconds = CMTimeGetSeconds(duration) * Float64(value)
            if currentExpectedSeconds.isNaN || currentExpectedSeconds .isInfinite {
                playerBar.setTimeLabel(currentTime: "00:00:00")
                playerBar.setBufferedValue(0.0)
                progressBar.setBufferedValue(0.0)
                return
            }
            let seconds = (Int64(currentExpectedSeconds) % 3600) % 60
            let minutes = (Int64(currentExpectedSeconds) % 3600) / 60
            let hours = Int64(currentExpectedSeconds) / 3600
            
            let timeTextBlock = { (number: Int64) -> String in
                return number < 10 ? "0\(number)" : "\(number)"
            }
            
            playerBar.setTimeLabel(currentTime: "\(timeTextBlock(hours)):\(timeTextBlock(minutes)):\(timeTextBlock(seconds))")
            playerBar.setBufferedValue(0.0)
            progressBar.setBufferedValue(0.0)
        } else {
            playerBar.setTimeLabel(currentTime: "00:00:00")
            playerBar.setBufferedValue(0.0)
            progressBar.setBufferedValue(0.0)
        }
    }
    
    func playerSliderOnTouchUp(value: Float) {
        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            if totalSeconds.isNaN || totalSeconds.isInfinite { return }
            let seekTime = CMTime(value: CMTimeValue(Float64(value) * totalSeconds), timescale: 1)
            player?.pause()
            player?.seek(to: seekTime, completionHandler: { [unowned self] (success) in
                if success && self.isPlayingBeforeSeek {
                    self.play()
                }
                self.createTimerToUpdatePlayerBar()
            })
        }
        startToCountHideVideoPlayerController()
    }

    func playerSliderOnTouchDown(value: Float) {
        timerToUpdatePlayerBar?.invalidate()
    }
    
    // End Delegate: - PlayerBarDelegate
    
    // Delegate: - PlayerHeaderViewDelegate
    
    func playerHeaderViewOnClickBackButton() {
        playerHeaderView.hideBackButton(true)
        playerBar.setFullScreenButton(flag: true)
        delegate?.playerViewNormalScreen()
    }
    
    func playerHeaderViewOnClickShareButton() {
        delegate?.playerViewShare()
    }
    
    // End Delegate: - PlayerHeaderViewDelegate
    
    func setTitle(_ title: String) {
        playerHeaderView.setTitle(title)
    }
    
    @objc func playRewind(_ sender: UIButton) {
        rewind(second: 15)
        startToCountHideVideoPlayerController()
    }
    
    @objc func playForward(_ sender: UIButton) {
        forward(second: 15)
        startToCountHideVideoPlayerController()
    }
    
    @objc func play(_ sender: UIButton) {
        if let _ = player {
            play()
//            playButton.isHidden = true
//            pauseButton.isHidden = false
            startToCountHideVideoPlayerController()
        } else {
            fatalError()
        }
    }
    
    @objc func pause(_ sender: UIButton) {
        if let _ = player {
            pause()
//            pauseButton.isHidden = true
//            playButton.isHidden = false
            startToCountHideVideoPlayerController()
        } else {
            fatalError()
        }
    }
    
    func rewind(second: Int) {
        if let player = player, let currentTime = player.currentItem?.currentTime() {
            var newTime = CMTimeGetSeconds(currentTime) - Float64(second)
            if newTime <= 0.0 {
                newTime = 0
            }
            player.pause()
            player.seek(to: CMTime(value: CMTimeValue(newTime), timescale: 1), completionHandler: { (success) in
                if success && self.isPlayingBeforeSeek {
                    self.play()
                }
            })
        } else {
            fatalError()
        }
    }
    
    func forward(second: Int) {
//        let second = 15
        if let player = player, let currentTime = player.currentItem?.currentTime(), let duration = player.currentItem?.duration {
            let total = CMTimeGetSeconds(duration)
            var newTime = CMTimeGetSeconds(currentTime) + Float64(second)
            if newTime > total {
                newTime = total
            }
            player.pause()
            player.seek(to: CMTime(value: CMTimeValue(newTime), timescale: 1), completionHandler: { (success) in
                if success && self.isPlayingBeforeSeek {
                    self.play()
                }
            })
        } else {
            fatalError()
        }
    }
    
    func play() {
        if let player = player {
            isPlayingBeforeSeek = true
            player.play()
            playButton.isHidden = true
            pauseButton.isHidden = false
        } else {
            isPlayingBeforeSeek = false
        }
    }
    
    func pause() {
        isPlayingBeforeSeek = false
        player?.pause()
        pauseButton.isHidden = true
        playButton.isHidden = false
    }
    
    func replaceCurrentItem(with playerItem: AVPlayerItem?) {
        DispatchQueue.main.async { [unowned self] in
            if let readyToPlayObserver = self.readyToPlayObserver {
                readyToPlayObserver.invalidate()
                self.readyToPlayObserver = nil
            }
            
            if let playerStallingObserver = self.playerStallingObserver {
                playerStallingObserver.invalidate()
                self.playerStallingObserver = nil
            }
            self.player?.replaceCurrentItem(with: playerItem)
            self.playerViewLoader.hide(false)
            if let _ = playerItem {
                self.playerViewLoader.showWaitingToPlay()
                self.observeReadyToPlay()
                self.observePlayerStalling()
                self.play()
            } else {
                self.playerViewLoader.showNothing()
            }
        }
    }
    
    func getPlayer() -> AVPlayer {
        return player
    }
}

extension PlayerView {
    
    static func secondToPlayerBarTime(timeSeconds: Int64) -> String {
        let seconds = (timeSeconds % 3600) % 60
        let minutes = (timeSeconds % 3600) / 60
        let hours = timeSeconds / 3600
        
        let timeTextBlock = { (number: Int64) -> String in
            return number < 10 ? "0\(number)" : "\(number)"
        }
        
        return "\(timeTextBlock(hours)):\(timeTextBlock(minutes)):\(timeTextBlock(seconds))"
    }
    
    func changeVolume(changeValue: Float) {
        for subview in self.volumeView.subviews {
            if subview.description.contains("MPVolumeSlider") == true {
                let slider = subview as! UISlider
                slider.isContinuous = false
                slider.value += changeValue
                soundValueBeforeMute = slider.value
                break
            }
        }
    }
    
    func mute() {
        for subview in self.volumeView.subviews {
            if subview.description.contains("MPVolumeSlider") == true {
                let slider = subview as! UISlider
                slider.isContinuous = false
                soundValueBeforeMute = slider.value
                slider.value = 0
                break
            }
        }
    }
    
    func unmute() {
        for subview in self.volumeView.subviews {
            if subview.description.contains("MPVolumeSlider") == true {
                let slider = subview as! UISlider
                slider.isContinuous = false
                slider.value = soundValueBeforeMute
                break
            }
        }
    }
}

protocol PlayerViewDelegate: AnyObject {
    func playerViewFullScreen()
    func playerViewNormalScreen()
    func playerViewShare()
}
