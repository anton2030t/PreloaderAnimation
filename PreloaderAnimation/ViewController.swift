//
//  ViewController.swift
//  PreloaderAnimation
//
//  Created by Anton Larchenko on 24.06.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var preloader = Preloader()
    let iziImage = UIImageView(image: UIImage(named: "izi"))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPreloader()
        setupIzi()
    }
    
    private func setupPreloader() {
        preloader = Preloader(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        preloader.center = view.center
        view.addSubview(preloader)
        preloader.startAnimating()
    }

    private func setupIzi() {
        view.addSubview(iziImage)
        iziImage.translatesAutoresizingMaskIntoConstraints = false
        iziImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        iziImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        iziImage.heightAnchor.constraint(equalToConstant: 240).isActive = true
        iziImage.widthAnchor.constraint(equalToConstant: 240).isActive = true
    }
    
}

