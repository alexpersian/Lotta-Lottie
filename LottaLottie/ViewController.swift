//
//  ViewController.swift
//  LottaLottie
//
//  Created by Alexander Persian on 3/17/17.
//  Copyright © 2017 Alexander Persian. All rights reserved.
//

import Cocoa
import Lottie

// TODO: Move to MVVM structure
// TODO: Add Rx bindings

class ViewController: NSViewController {

    @IBOutlet weak var titleText: NSTextField!
    @IBOutlet weak var fileNameReadout: NSTextField!
    @IBOutlet weak var animationSlider: NSSlider!
    @IBOutlet weak var animationContainer: NSView!

    private var animView = LOTAnimationView()

    override func viewDidLoad() {
        setupAnimationSlider()
        animationContainer.layer?.backgroundColor = .white
    }

    private func setupAnimationSlider() {
        animationSlider.target = self
        animationSlider.action = #selector(updateAnimationProgress)
    }

    private func loadLottieAnimationFrom(file: URL?) {
        guard
            let file = file,
            let anim = LOTAnimationView(contentsOf: file)
            else { return }

        animationContainer.subviews.removeAll()
        setFileNameLabel(file: file)

        animView = anim
        animView.contentMode = LOTViewContentMode.scaleAspectFit
        animView.frame = animationContainer.bounds
        animView.autoresizingMask = [.viewWidthSizable, .viewWidthSizable]
        animationContainer.addSubview(animView)

        animView.loopAnimation = true
        animView.play()
    }

    private func setFileNameLabel(file: URL) {
        guard let fileName = file.absoluteString.components(separatedBy: "/").last else { return }
        fileNameReadout.stringValue = fileName
    }

    dynamic func updateAnimationProgress(sender: NSSlider) {
        animView.animationProgress = CGFloat(animationSlider.floatValue)
    }

    // MARK: IBActions

    @IBAction func openFilePicker(_ sender: NSButton) {
        guard let window = NSApplication.shared().mainWindow else { return }

        let panel = NSOpenPanel()
        let fileTypes = ["json", "JSON"]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowedFileTypes = fileTypes
        panel.message = "Select your After Effects animation file to load in Lottie"
        panel.beginSheetModal(for: window) { (result) in
            if result == NSFileHandlingPanelOKButton {
                self.loadLottieAnimationFrom(file: panel.urls.first)
            }
        }
    }

    @IBAction func playAnimation(_ sender: NSButton) {
        if !animView.isAnimationPlaying {
            animView.play()
        }
    }

    @IBAction func pauseAnimation(_ sender: NSButton) {
        if animView.isAnimationPlaying {
            animView.pause()
        }
    }
}

