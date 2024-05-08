//
//  DetailLyricsSceneNavigationBar.swift
//  FLO
//
//  Created by 김성준 on 5/2/24.
//

import UIKit

final class DetailLyricsSceneNavigationBar: UIView {
    weak var delegate: DetailLyricsSceneViewControllerDelegate?
    
    private lazy var navigationBarStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5.0
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var songInfoStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2.0
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.font = .titleBoldFont
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var signerName: UILabel = {
        let label = UILabel()
        label.font = .subTitleFont
        label.textColor = .gray
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(font: UIFont.titleFont)
        let image = UIImage(systemName: "xmark", withConfiguration: configuration)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(dismiss), for: .touchDown)
        
        return button
    }()
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    func configure(with song: SongDTO){
        title.text = song.title
        signerName.text = song.singer
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        songInfoStack.addArrangedSubview(title)
        songInfoStack.addArrangedSubview(signerName)
        navigationBarStack.addArrangedSubview(songInfoStack)
        navigationBarStack.addArrangedSubview(dismissButton)
        
        addSubviews(navigationBarStack)
    }
    
    private func setupConstraints() {
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            navigationBarStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            navigationBarStack.topAnchor.constraint(equalTo: topAnchor),
            navigationBarStack.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    @objc func dismiss() {
        delegate?.dismiss()
    }
}
