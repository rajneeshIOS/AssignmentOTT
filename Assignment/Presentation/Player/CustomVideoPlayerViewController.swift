//
//  CustomVideoPlayerViewController.swift
//  Assignment
//
//  Created by Rajneesh Singh on 20/10/26.
//

import UIKit
import AVFoundation

class CustomVideoPlayerViewController: UIViewController {
    var isSeeking = false
    var player: AVPlayer!
    let playerLayer = AVPlayerLayer()
    let playPauseButton = UIButton(type: .system)
    let muteButton = UIButton(type: .system)
    let seekSlider = UISlider()
    let closeButton = UIButton(type: .system)
    let eventHandler = PlayerEventHandler()
    var timeObserverToken: Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        setupPlayer()
        setupControls()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(videoDidFinish),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem
        )
    }
    @objc private func videoDidFinish() {
        eventHandler.handle(event: .completed)
        seekSlider.value = 0
        playPauseButton.setImage(UIImage(systemName: "play.fill"),for: .normal)

    }
    func setupPlayer() {
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspect
        view.layer.addSublayer(playerLayer)
        eventHandler.handle(event: .ready)
        Task {
            do {
                let duration = try await player.currentItem?.asset.load(.duration)
                
                await MainActor.run {
                    let seconds = duration?.seconds ?? 0
                    
                    guard seconds.isFinite, seconds > 0 else { return }
                    
                    self.seekSlider.minimumValue = 0
                    self.seekSlider.maximumValue = Float(seconds)
                }
            } catch {
                print("Video duration error:", error)
            }
        }
        timeObserverToken = player.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 1, preferredTimescale: 600),
            queue: .main
        ) { [weak self] time in
            guard let self = self,
                  !self.isSeeking,
                  time.seconds.isFinite else { return }
            
            self.seekSlider.value = Float(time.seconds)
        }
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = view.bounds
    }
    
    func setupControls() {
        playPauseButton.setImage(UIImage(systemName: "pause.fill"),for: .normal)
        muteButton.setImage(UIImage(systemName: "speaker.wave.2.fill"),for: .normal)
        
        playPauseButton.tintColor = .white
        muteButton.tintColor = .white
        
        playPauseButton.addTarget(self,action: #selector(togglePlayPause), for: .touchUpInside)
        
        muteButton.addTarget(self,action: #selector(toggleMute), for: .touchUpInside)
        
        seekSlider.minimumValue = 0
        
        seekSlider.addTarget(self, action: #selector(startSeeking), for: .touchDown)
        seekSlider.addTarget(self, action: #selector(seekVideo), for: .touchUpInside)
        seekSlider.addTarget(self, action: #selector(seekVideo), for: .touchUpOutside)
        seekSlider.addTarget(self, action: #selector(seekVideo), for: .touchCancel)
        
        closeButton.setImage(UIImage(systemName: "xmark"),for: .normal)
        closeButton.tintColor = .white
        closeButton.addTarget(self,action: #selector(closePlayer),for: .touchUpInside)
        [playPauseButton, muteButton, seekSlider, closeButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            playPauseButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 20
            ),
            playPauseButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20
            ),
            
            muteButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -20
            ),
            muteButton.centerYAnchor.constraint(
                equalTo: playPauseButton.centerYAnchor
            ),
            
            seekSlider.leadingAnchor.constraint(
                equalTo: playPauseButton.trailingAnchor, constant: 20
            ),
            seekSlider.trailingAnchor.constraint(
                equalTo: muteButton.leadingAnchor, constant: -20
            ),
            seekSlider.centerYAnchor.constraint(
                equalTo: playPauseButton.centerYAnchor
            ),
            closeButton.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 20
            ),
            closeButton.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 12
            )
        ])
    }
    
    
    @objc private func togglePlayPause() {
        //         restart
        guard let item = player.currentItem else { return }
        
        let duration = item.duration.seconds
        let currentTime = player.currentTime().seconds
        
        if duration.isFinite && duration > 0 && currentTime >= duration {
            player.seek(to: .zero)
        }
        //play pause
        if player.timeControlStatus == .playing {
            player.pause()
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            eventHandler.handle(event: .paused)
        } else {
            player.play()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            eventHandler.handle(event: .started)
        }
    }
    @objc private func toggleMute() {
        player.isMuted.toggle()
        
        let imageName = player.isMuted
        ? "speaker.slash.fill"
        : "speaker.wave.2.fill"
        
        muteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    @objc private func seekVideo() {
        guard let item = player.currentItem else { return }
        
        let duration = item.duration.seconds
        
        guard duration.isFinite, duration > 0 else { return }
        
        let targetSeconds = min(
            max(Double(seekSlider.value), 0),
            duration
        )
        let wasPlaying = player.timeControlStatus == .playing
        let targetTime = CMTime(seconds: targetSeconds,preferredTimescale: 600)
        eventHandler.handle(event: .seeked)
        player.seek(to: targetTime, toleranceBefore: .zero, toleranceAfter: .zero){
            [weak self] finished in
            guard let self = self, finished else { return }
            self.isSeeking = false
            if wasPlaying {
                self.player.play()
            }
        }
    }
    @objc private func startSeeking() {
        isSeeking = true
    }
    @objc private func closePlayer() {
        player.pause()
        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
        
        NotificationCenter.default.removeObserver(self)
        dismiss(animated: true)
    }
}
