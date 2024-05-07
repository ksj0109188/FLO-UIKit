//
//  LyricsCell.swift
//  FLO
//
//  Created by 김성준 on 4/20/24.
//

import UIKit

class DetailLyricsCell: UITableViewCell {
    static let reuseIdentifier = String(describing: DetailLyricsCell.self)
    
    private lazy var width: Double = 0.0
    private lazy var lyricsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .black
        setupViews()
        setupConstraints()
    }
    
    func configure(lyrics: String, width: Double) {
        self.width = width
        lyricsLabel.text = lyrics
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubviews(lyricsLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            lyricsLabel.topAnchor.constraint(equalTo: topAnchor),
            lyricsLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            lyricsLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            lyricsLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func highlight() {
        self.lyricsLabel.font = .contentBoldFont
        self.lyricsLabel.textColor = .white
    }
    
    func disHighlight() {
        self.lyricsLabel.font = .contentFont
        self.lyricsLabel.textColor = .gray
    }

}
