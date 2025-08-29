//
//  ProductSliderCollectionViewCell.swift
//  Najat
//
//  Created by rania refaat on 28/07/2024.
//

import UIKit
import AVFoundation
import AVKit

class ProductSliderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var videoImageView: UIImageView!

    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    var isMuted: Bool = false
    
    var muteTapped: (()-> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPlayerLayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPlayerLayer()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Reset player when reusing the cell
        pauseVideo()
        playerLayer?.removeFromSuperlayer()
    }
    private func setupPlayerLayer() {
        //        videoPlayerLayer.videoGravity = .resize
        //        if let imageView = imageView {
        //        }
        
        //        isMuted.toggle()
        isMuted = false
        
        player?.isMuted = isMuted
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //        videoPlayerLayer.frame = imageView.bounds
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func muteButtonTapped(_ sender: UIButton) {
        muteTapped?()
    }
    func configCell(media: Media){
        let isImage = media.isImage ?? false
        if isImage {
            imageView.load(with: media.file)
            muteButton.isHidden = true
            videoImageView.isHidden = true
        }else{
//            muteButton.isHidden = false
            videoImageView.isHidden = false

            let file = media.file ?? ""
            let urlString = file.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) ?? ""
            
            guard let videoURL = URL(string: urlString) else{return}
            
            do {
                self.getThumbnailFromVideo(url: videoURL) { thumbnailImage in
                    if let image = thumbnailImage {
                        DispatchQueue.main.async {
                            self.imageView.image = image
                        }
                    } else {
                        print("Failed to generate thumbnail")
                    }
                }
            } catch {
                print("Error converting video to data: \(error)")
            }
        }
        
    }
    func playVideo(media: Media) {
        let file = media.file ?? ""
        let urlString = file.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        guard let videoURL = URL(string: urlString) else{return}
        player = AVPlayer(url: videoURL)
        playerLayer = AVPlayerLayer(player: player)
        
        // Set the player layer frame to match the image view bounds
        playerLayer?.frame = imageView.bounds
        playerLayer?.videoGravity = .resize
        
        // Add the player layer to the image view
        if let playerLayer = playerLayer {
            imageView.layer.addSublayer(playerLayer)
        }
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback, options: [])
        try? AVAudioSession.sharedInstance().setActive(true)
        muteButton.setImage( UIImage(named: "unmute") , for: .normal)
        player?.isMuted = false
        player?.play()
    }
    
    func pauseVideo() {
        player?.pause()
        player = nil
    }
    func toggleMute() {
        isMuted.toggle()
        player?.isMuted = isMuted
        if isMuted {
            muteButton.setImage(UIImage(named: "mute"), for: .normal)
        }else{
            muteButton.setImage( UIImage(named: "unmute") , for: .normal)
        }
    }
}
extension ProductSliderCollectionViewCell {
    func getThumbnailFromVideo(url: URL, completion: @escaping (UIImage?) -> Void) {
        let asset = AVAsset(url: url)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImageGenerator.appliesPreferredTrackTransform = true
        
        // Generate thumbnail at the 1-second mark
        let time = CMTime(seconds: 1, preferredTimescale: 60)
        assetImageGenerator.generateCGImagesAsynchronously(forTimes: [NSValue(time: time)]) { _, cgImage, _, result, error in
            if let cgImage = cgImage, result == .succeeded {
                let thumbnail = UIImage(cgImage: cgImage)
                completion(thumbnail)
            } else {
                print("Failed to generate thumbnail: \(String(describing: error))")
                completion(nil)
            }
        }
    }
}
