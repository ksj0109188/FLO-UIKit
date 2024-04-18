//
//  PlayView.swift
//  FLO
//
//  Created by 김성준 on 4/16/24.
//

import UIKit

class PlayInfoView: UIView {
    private let padding: CGFloat = 16
    
    private lazy var albumName: UILabel = {
        let label = UILabel()
        label.text = Song.dummy.album
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var albumCover: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "photo.circle.fill"))
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 8
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.text = Song.dummy.title
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var signerName: UILabel = {
        let label = UILabel()
        label.text = Song.dummy.singer
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var topInfoView: UIStackView = {
        let topStackView = UIStackView()
        topStackView.axis = .vertical
        topStackView.spacing = 20.0
        topStackView.alignment = .center
        topStackView.distribution = .equalSpacing
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        
        return topStackView
    }()
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setConstraints()
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
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            topInfoView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20.0),
            topInfoView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20.0),
            topInfoView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20.0),
            
            albumCover.topAnchor.constraint(equalTo: self.topInfoView.bottomAnchor, constant: padding),
            albumCover.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            albumCover.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3),
            albumCover.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}

extension PlayInfoView {
    public func configure() {
//        title.text = Song.dummy.title
    }
}
