//
//  PlayView.swift
//  FLO
//
//  Created by 김성준 on 4/16/24.
//

import UIKit

class PlayInfoView: UIView {
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
        topStackView.spacing = 5.0
        topStackView.alignment = .center
        topStackView.distribution = .equalSpacing
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        
        return topStackView
    }()
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blue
        setupViews()
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    func setupConstraints() {
        let padding: CGFloat = 16
        let viewFrame = bounds
        
        NSLayoutConstraint.activate([
            topInfoView.topAnchor.constraint(equalTo: topAnchor, constant: 20.0),
            topInfoView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.0),
            topInfoView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.0),
//            topInfoView.heightAnchor.constraint(equalToConstant: viewFrame.height/3)
        ])

        NSLayoutConstraint.activate([
            albumCover.topAnchor.constraint(equalTo: topInfoView.bottomAnchor, constant: padding),
            albumCover.widthAnchor.constraint(equalToConstant: viewFrame.width / 2),
            albumCover.heightAnchor.constraint(equalToConstant: viewFrame.height / 2),
            albumCover.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
