//
//  ViewController.swift
//  Keyboarder
//
//  Created by Alan Li on 2017-08-09.
//  Copyright © 2017 Alan Li. All rights reserved.
//

import UIKit
import AudioKit

class ViewController: UIViewController {

    @IBOutlet weak var leftHandKeyboard: AKKeyboardView!
    @IBOutlet weak var rightHandKeyboard: AKKeyboardView!
    
    /// The direct sound output for AudioKit.
    fileprivate var outputNode: AKOscillatorBank! {
        get { return AudioKit.output as? AKOscillatorBank }
        set { AudioKit.output = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeSoundBank()
        setupKeyboards(withOutput: outputNode)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Initializing AudioKit output. Does not affect keyboards.
    private func initializeSoundBank() {
        outputNode = AKOscillatorBank()
        assert(AudioKit.output === outputNode)
        AudioKit.start()
    }
    
    /// Sets up the AKKeyboards with responders and properties and attaches to AudioKit.
    private func setupKeyboards(withOutput node: AKOscillatorBank) {
        
        leftHandKeyboard.transform = CGAffineTransform(rotationAngle: CGFloat(GLKMathDegreesToRadians(180)))
        
        let setupKeyboard = {[unowned self] (keyboard: AKKeyboardView) in
            keyboard.octaveCount = 1
            keyboard.polyphonicMode = true
            keyboard.delegate = self
        }
        
        _ = [leftHandKeyboard, rightHandKeyboard].map { setupKeyboard($0) }
        
        leftHandKeyboard.firstOctave = 4
        rightHandKeyboard.firstOctave = 5
    }
}

// MARK: - AKKeyboardDelegate Methods
extension ViewController: AKKeyboardDelegate {
    
    func noteOn(note: MIDINoteNumber) {
        outputNode.play(noteNumber: note, velocity: 80)
    }
    
    func noteOff(note: MIDINoteNumber) {
        outputNode.stop(noteNumber: note)
    }
}
