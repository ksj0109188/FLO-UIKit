//
//  DetailLyricsSceneSidebarView.swift
//  FLO
//
//  Created by 김성준 on 5/3/24.
//

import UIKit

class DetailLyricsTableSidebarView: UIView {
    weak var delegate: DetailLyricsTableViewDelegate?
    
    private var isToggled: Bool = false {
        didSet {
            updateButtonAppearance()
        }
    }
    
    private lazy var toggleOnImage: UIImage = {
        let configuration = UIImage.SymbolConfiguration(font: UIFont.titleFont)
        let image = UIImage(systemName: "music.note.list", withConfiguration: configuration)?.withTintColor(.buttonColor, renderingMode: .alwaysOriginal)
        
        return image!
    }()
    
    private lazy var toggleOffImage: UIImage = {
        let configuration = UIImage.SymbolConfiguration(font: UIFont.titleFont)
        let image = UIImage(systemName: "list.bullet", withConfiguration: configuration)?.withTintColor(.buttonColor, renderingMode: .alwaysOriginal)
        
        return image!
    }()
    
    private lazy var toggleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(toggleOffImage, for: .normal)
        button.addTarget(self, action: #selector(toggleButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private func updateButtonAppearance() {
        let image = isToggled ? toggleOnImage : toggleOffImage
        toggleButton.setImage(image, for: .normal)
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubviews(toggleButton)
    }
    
    private func setupConstraints() {
        let safeArea = safeAreaLayoutGuide
        let padding = 20.0
        NSLayoutConstraint.activate([
            toggleButton.topAnchor.constraint(equalTo: topAnchor),
            toggleButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            toggleButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: padding),
        ])
    }
    
    @objc private func toggleButtonTapped() {
        isToggled.toggle()
        delegate?.isLyricsSelect(isLyricsSelect: isToggled)
    }
}
