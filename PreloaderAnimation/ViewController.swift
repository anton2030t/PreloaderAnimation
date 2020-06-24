//
//  ViewController.swift
//  PreloaderAnimation
//
//  Created by Anton Larchenko on 24.06.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var line1 = Line1()
    var line2 = Line2()
    var line3 = Line3()
    var line4 = Line4()
    
    let iziImage = UIImageView(image: UIImage(named: "izi"))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPreloader()
        setupIzi()
    }
    
    private func setupPreloader() {
        line4 = Line4(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        line4.center = view.center
        view.addSubview(line4)
        line4.startAnimating()
        
        line3 = Line3(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        line3.center = view.center
        view.addSubview(line3)
        line3.startAnimating()
        
        line2 = Line2(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        line2.center = view.center
        view.addSubview(line2)
        line2.startAnimating()
        
        line1 = Line1(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        line1.center = view.center
        view.addSubview(line1)
        line1.startAnimating()
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

