//
//  PlayView.swift
//  FLO
//
//  Created by 김성준 on 4/16/24.
//

import UIKit
import Combine

class PlayInfoView: UIView {
    private lazy var subscriptions = Set<AnyCancellable>()
    
    lazy var albumName: UILabel = {
        let label = UILabel()
        label.font = .subTitleFont
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var albumCover: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "photo.circle.fill"))
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.font = .titleBoldFont
        label.textAlignment = .center
        label.textColor = .white
        
        return label
    }()
    
    private lazy var signerName: UILabel = {
        let label = UILabel()
        label.font = .subTitleFont
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var topInfoView: UIStackView = {
        let topStackView = UIStackView()
        topStackView.axis = .vertical
        topStackView.spacing = 5.0
        topStackView.alignment = .center
        topStackView.distribution = .equalSpacing
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        
        return topStackView
    }()
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        topInfoView.addArrangedSubview(title)
        topInfoView.addArrangedSubview(albumName)
        topInfoView.addArrangedSubview(signerName)
        
        addSubviews(topInfoView, albumCover)
    }
    
    func configure(with song: SongDTO){
        albumName.text = song.album
        title.text = song.title
        signerName.text = song.singer
        
        if let url = URL(string: song.image) {
            fetchURLImage(url: url)
        }
    }

    private func fetchURLImage(url: URL) {
        URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: UIImage(systemName: "photo.circle.fill"))
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] image in
                self?.albumCover.image = image
                self?.albumCover.layer.cornerRadius = (self?.albumCover.frame.size.width ?? 0) / 2
                self?.albumCover.layer.masksToBounds = true
                self?.albumCover.contentMode = .scaleToFill
            })
            .store(in: &subscriptions)
    }
    
    func setupConstraints() {
        let safeArea = safeAreaLayoutGuide
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            topInfoView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            topInfoView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            topInfoView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            topInfoView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4)
        ])

        NSLayoutConstraint.activate([
            albumCover.topAnchor.constraint(equalTo: topInfoView.bottomAnchor, constant: padding),
            albumCover.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            albumCover.widthAnchor.constraint(equalToConstant: 150),
            albumCover.heightAnchor.constraint(equalToConstant: 150),
            
        ])
    }
    
}
