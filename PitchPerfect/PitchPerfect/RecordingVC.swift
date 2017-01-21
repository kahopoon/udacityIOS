//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Ka Ho Poon on 22/1/2017.
//  Copyright © 2017 Ka Ho Poon. All rights reserved.
//

import UIKit
import AVFoundation

class RecordingVC: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingButton, stopRecordingButton: UIButton!
    @IBOutlet weak var recordingStatusLabel: UILabel!
    
    let playbackVCSegue = "playbackVCSegue"
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func startRecordingAction(_ sender: Any) {
        uiElementAppearance(recording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecordingAction(_ sender: Any) {
        uiElementAppearance(recording: false)
        
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
    
    func uiElementAppearance(recording: Bool) {
        recordingButton.isEnabled       = !recording
        stopRecordingButton.isEnabled   = recording
        recordingStatusLabel.text       = recording ? "Recording in progress" : "Tap to Record"
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {self.performSegue(withIdentifier: playbackVCSegue, sender: recorder.url)} else {
            print("recoding failed")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == playbackVCSegue {
            let playbackVC = segue.destination as! PlaybackVC
            print((sender as! URL).absoluteString)
            playbackVC.recordedAudioURL = sender as! URL
        }
    }
}

