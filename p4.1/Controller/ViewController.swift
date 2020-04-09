//
//  ViewController.swift
//  p4.1
//
//  Created by Merouane Bellaha on 18/03/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    // MARK: - @IBOutlet
   
    @IBOutlet private weak var gridView: UIView!
    @IBOutlet private var plusButtons: [UIButton]!
    @IBOutlet private var layoutButtons: [UIButton]!
    
    // MARK: - Properties
    
    private let imagePickerController = UIImagePickerController()
    private var swipeGestureRecognizer: UISwipeGestureRecognizer?
    
    // MARK: - viewLifeCycle
    
    // Contains general settings which must be executed immediatly after the view loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        plusButtons.forEach { $0.imageView?.contentMode = .scaleAspectFill }

        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePickerController.allowsEditing = true
        
        swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(gridViewTranslate))
        swipeGestureRecognizer?.addTarget(self, action: #selector(presentActivityController))
        guard let swipeGestureRecognizer = swipeGestureRecognizer else { return }
        view.addGestureRecognizer(swipeGestureRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleSwipeDirection), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - @IBAction
    
    /// Adapt the gridView layout and the layoutButtons state depending on user choice.
    @IBAction private func layoutButtonTapped(_ sender: UIButton) {
        let tag = sender.tag
        layoutButtons.forEach { $0.tag == tag ? ($0.isSelected = true) : ($0.isSelected = false) }
        plusButtons.forEach { $0.tag == tag ? ($0.isHidden = true) : ($0.isHidden = false) }
    }
    
    /// Present the imagePickerController.
    @IBAction private func plusButtonTapped(_ sender: UIButton) {
        plusButtons.forEach { $0.isSelected = false }
        sender.isSelected = true
        present(imagePickerController, animated: true)
    }

    // MARK: - Methods
    
    /// HandleSwipeDirection depending on device orientation.
    @objc
    private func handleSwipeDirection() {
        if UIDevice.current.orientation == .landscapeRight  ||  UIDevice.current.orientation == .landscapeLeft {
            swipeGestureRecognizer?.direction = .left
        } else {
            swipeGestureRecognizer?.direction = .up
        }
    }
    
    /// gridView animation depending on device orientation.
    @objc
    private func gridViewTranslate() {
        if UIDevice.current.orientation == .landscapeRight  ||  UIDevice.current.orientation == .landscapeLeft {
            UIView.animate(withDuration: 0.5, animations: {
                self.gridView.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.gridView.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height)
            })
        }
    }

    /// Set and present the activityController.
    @objc
    private func presentActivityController() {
        let activityController = UIActivityViewController(activityItems: [gridView.image], applicationActivities: nil)
        present(activityController, animated: true)
        activityController.completionWithItemsHandler = { _, _, _, _ in
            UIView.animate(withDuration: 0.5) {
                self.gridView.transform = .identity
            }
        }
    }
}

    // MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate Method

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /// imagePickerController update chosenImage on the gridView if needed, then dismiss.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any] ) {
        if let chosenImage = info[.editedImage] as? UIImage {
            plusButtons.forEach {
                guard $0.state == .selected else { return }
                $0.setImage(chosenImage, for: .normal)
            }
        }
        dismiss(animated: true)
    }
}



