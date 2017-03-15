//
//  RecordViewController.swift
//  Pitch Perfect
//
//  Created by Aqib on 2/27/17.
//  Copyright © 2017 com.aqibshah. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController, AVAudioRecorderDelegate {
  @IBOutlet weak var recordingLabel: UILabel!
  @IBOutlet weak var recordButton: UIButton!
  @IBOutlet weak var stopButton: UIButton!
  var audioRecorder: AVAudioRecorder!

  override func viewDidLoad() {
    super.viewDidLoad()
    setButtonsState(isRecording: false);
  }

  @IBAction func recordAudio(_ sender: Any) {
    setButtonsState(isRecording: true);

    // Get document directory for storing audio and combine with file name
    let dirPath = NSSearchPathForDirectoriesInDomains(
      .documentDirectory, .userDomainMask, true
    )[0] as String
    let recordingName = "recordedVoice.wav"
    let pathArray = [dirPath, recordingName]
    let filePath = URL(string: pathArray.joined(separator: "/"))

    // Set up recording session
    // AVAudioSession - Wrapper for audio hardware on device
    // Shared instance, because only one pair of audio hardware on device
    let session = AVAudioSession.sharedInstance()
    try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)

    // Actually record audio
    try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
    audioRecorder.delegate = self;
    audioRecorder.isMeteringEnabled = true
    audioRecorder.prepareToRecord()
    audioRecorder.record()
  }

  @IBAction func stopRecording(_ sender: Any) {
    setButtonsState(isRecording: false);

    audioRecorder.stop()
    let audioSession = AVAudioSession.sharedInstance()
    try! audioSession.setActive(false)
  }

  func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    flag
    ? performSegue(withIdentifier: "toPlayback", sender: audioRecorder.url)
    : print("Failed to record!")
  }

  func setButtonsState(isRecording: Bool) -> Void {
    recordingLabel.text =
      isRecording ? "Recording in Progress" : "Tap to Record"
    recordButton.isEnabled = !isRecording;
    stopButton.isEnabled = isRecording;
  }

  // Set up (or "prepare") PlaybackViewController before segue is performed
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toPlayback" {
      let playbackViewController = segue.destination as! PlaybackViewController
      let recordedAudioURL = sender as! URL
      playbackViewController.recordedAudioURL = recordedAudioURL;
    }
  }

}
