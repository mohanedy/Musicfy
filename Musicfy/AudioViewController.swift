//
//  AudioViewController.swift
//  Musicfy
//
//  Created by Mohaned Al-Feky on 8/5/18.
//  Copyright © 2018 mohaned. All rights reserved.
//

import UIKit
import AVFoundation
import Kingfisher
class AudioViewController: UIViewController {
    var imageMedium:String?
    var imageHigh:String?
    var imageTitle:String?
    var player = AVAudioPlayer()
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    var previewURL : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageMedium = imageMedium{
        if let imageMediumURL = URL(string: imageMedium){
        coverImage.kf.setImage(with:imageMediumURL)
        
        }
        }
        if let imageHigh = imageHigh{
            if let imageHighURL = URL(string: imageHigh){
                backgroundImage.kf.setImage(with:imageHighURL)
                
            }
        }
        if let title = imageTitle{
            titleLabel.text = title
        }
        
       downloadFileFromURL(url: URL(string: previewURL!)!)
       
    }
  
    func downloadFileFromURL(url: URL){
        var downloadTask = URLSessionDownloadTask()
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: {
            customURL, response, error in
            
            self.play(url: customURL!)
            
        })
        
        downloadTask.resume()
        
        
    }
    
    func play(url: URL) {
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.play()
            
        }
        catch{
            print(error)
        }
        
        
    }
    @IBOutlet weak var playpausebtn: UIButton!
    @IBAction func playPauseButton(_ sender: Any) {
        if player.isPlaying {
            player.pause()
            playpausebtn.setTitle("Play", for: .normal)
        }
        else{
            player.play()
            playpausebtn.setTitle("Pause", for: .normal)
        }
    }
    
    


}
