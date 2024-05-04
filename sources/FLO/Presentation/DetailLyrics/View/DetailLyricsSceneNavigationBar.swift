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
        stackView.distribution = .fillEqually
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
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var signerName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setTitle("X", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dismiss), for: .touchDown)
        
        return button
    }()
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func configure(with song: SongDTO){
        title.text = song.title
        signerName.text = song.singer
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        songInfoStack.addArrangedSubview(title)
        songInfoStack.addArrangedSubview(signerName)
        navigationBarStack.addArrangedSubview(songInfoStack)
        navigationBarStack.addArrangedSubview(dismissButton)
        
        addSubviews(navigationBarStack)
    }
    
    @objc func dismiss() {
        delegate?.dismiss()
    }
}
