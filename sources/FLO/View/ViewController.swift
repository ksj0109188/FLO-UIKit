//
//  ViewController.swift
//  FLO
//
//  Created by 김성준 on 4/15/24.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var playView: PlayInfoView = {
        let playView = PlayInfoView()
        playView.translatesAutoresizingMaskIntoConstraints = false
        
        return playView
    }()
    
    lazy var playControlView: PlayControlView = {
        let playControlView = PlayControlView()
        playControlView.translatesAutoresizingMaskIntoConstraints = false
        
        return playControlView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        view.addSubviews(playView, playControlView)
    }
    
    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            playView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            playView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            playView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            playView.heightAnchor.constraint(equalTo: safeArea.heightAnchor),
            
            playControlView.topAnchor.constraint(equalTo: playView.bottomAnchor),
            playControlView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            playControlView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            playControlView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            playControlView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.5)
        ])
    }
    
}

@available(iOS 17.0, *)
#Preview {
    ViewController()
}
