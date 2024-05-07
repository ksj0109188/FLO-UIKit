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
    
    private lazy var sideStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var toggleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(toggleOffImage, for: .normal)
        button.addTarget(self, action: #selector(toggleButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var fillerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
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
        sideStackView.addArrangedSubview(fillerView)
        sideStackView.addArrangedSubview(toggleButton)
        addSubviews(sideStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            sideStackView.topAnchor.constraint(equalTo: topAnchor),
            sideStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            sideStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            sideStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            sideStackView.widthAnchor.constraint(equalTo: widthAnchor),
            sideStackView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            toggleButton.widthAnchor.constraint(equalToConstant: 200),
            toggleButton.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    @objc private func toggleButtonTapped() {
        isToggled.toggle()
        delegate?.isLyricsSelect(isLyricsSelect: isToggled)
    }
}
