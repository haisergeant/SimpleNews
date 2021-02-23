//
//  ContentCell.swift
//
//  Created by Hai Le Thanh.
//  
//
	
import UIKit

final class ContentCell: UICollectionViewCell, Reuseable, ViewConfigurable {
    private let mainStackView = UIStackView()
    
    private let leftContainer = UIView()
    private let contentImageView = UIImageView()
    private let loadingView = LoadingView()
    
    private let rightContainer = UIView()
    private let rightStackView = UIStackView()
    private let topTitleLabel = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let dateLabel = UILabel()
    private let separator = UIView()
    
    private weak var viewModel: ContentCellViewModel?
    private var shouldAnimate = true
    
    private enum Constant {
        static let separatorHeight: CGFloat = 0.5
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        [mainStackView, leftContainer, contentImageView,
        rightContainer, rightStackView, topTitleLabel,
        titleLabel, subtitleLabel, dateLabel, separator].forEach { $0.disableTranslatesAutoResizing() }
        
        contentView.addSubview(mainStackView)
        contentView.addSubview(separator)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        mainStackView.axis = .horizontal
        mainStackView.spacing = 20
        mainStackView.addArrangedSubview(leftContainer)
        mainStackView.addArrangedSubview(rightContainer)
        
        leftContainer.addSubview(contentImageView)
        NSLayoutConstraint.activate([
            contentImageView.topAnchor.constraint(equalTo: leftContainer.topAnchor),
            contentImageView.bottomAnchor.constraint(lessThanOrEqualTo: leftContainer.bottomAnchor),
            contentImageView.leadingAnchor.constraint(equalTo: leftContainer.leadingAnchor),
            contentImageView.trailingAnchor.constraint(equalTo: leftContainer.trailingAnchor),
            contentImageView.widthAnchor.constraint(equalToConstant: 120),
            contentImageView.widthAnchor.constraint(equalTo: contentImageView.heightAnchor)
        ])
        
        rightStackView.axis = .vertical
        rightStackView.spacing = 4
        rightContainer.addSubview(rightStackView)
        
        NSLayoutConstraint.activate([
            rightStackView.topAnchor.constraint(equalTo: rightContainer.topAnchor),
            rightStackView.leadingAnchor.constraint(equalTo: rightContainer.leadingAnchor),
            rightStackView.trailingAnchor.constraint(equalTo: rightContainer.trailingAnchor),
            rightStackView.bottomAnchor.constraint(lessThanOrEqualTo: rightContainer.bottomAnchor)
        ])
        
        rightStackView.addArrangedSubview(topTitleLabel)
        rightStackView.addArrangedSubview(titleLabel)
        rightStackView.addArrangedSubview(subtitleLabel)
        rightStackView.addArrangedSubview(dateLabel)
        
        topTitleLabel.numberOfLines = 0
        titleLabel.numberOfLines = 0
        subtitleLabel.numberOfLines = 0
        dateLabel.numberOfLines = 0
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        contentImageView.layer.cornerRadius = 8.0
        contentImageView.layer.borderWidth = 0.5
        contentImageView.layer.borderColor = UIColor.appDarkGrey.cgColor
        contentImageView.contentMode = .scaleAspectFill
        contentImageView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separator.widthAnchor.constraint(equalTo: rightContainer.widthAnchor),
            separator.heightAnchor.constraint(equalToConstant: Constant.separatorHeight)
        ])
        
        [topTitleLabel, titleLabel, subtitleLabel, dateLabel].forEach { $0.alpha = 0 }
        [contentImageView].forEach { $0.transform = .init(scaleX: 0, y: 0) }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        shouldAnimate = false
        viewModel?.imageState.valueChanged = nil
        viewModel = nil
        contentImageView.image = nil
    }
    
    func animate(with delay: TimeInterval) {
        guard shouldAnimate else { return }
        let duration = 0.2
        topTitleLabel.animate([.changeAlpha(duration: duration, delay: delay + 0.1, alpha: 1.0)])
        titleLabel.animate([.changeAlpha(duration: duration, delay: delay + 0.2, alpha: 1.0)])
        subtitleLabel.animate([.changeAlpha(duration: duration, delay: delay + 0.3, alpha: 1.0)])
        dateLabel.animate([.changeAlpha(duration: duration, delay: delay + 0.4, alpha: 1.0)])
        contentImageView.animate([.scale(duration: duration, delay: delay, scale: 1.0)])
    }
    
    func resetAnimation() {
        [topTitleLabel, titleLabel, subtitleLabel, dateLabel].forEach { $0.alpha = 1 }
        [contentImageView].forEach { $0.transform = .identity }
    }
    
    func style(topTitleColor: UIColor = Theme.color.contentCellTopTitleColor,
               topTitleFont: UIFont = Theme.font.contentCellTopTitleFont,
               titleColor: UIColor = Theme.color.contentCellTitleColor,
               titleFont: UIFont = Theme.font.contentCellTitleFont,
               subtitleColor: UIColor = Theme.color.contentCellSubtitleColor,
               subtitleFont: UIFont = Theme.font.contentCellSubtitleFont,
               dateColor: UIColor = Theme.color.contentCellDateColor,
               dateFont: UIFont = Theme.font.contentCellDateFont,
               separatorColor: UIColor = Theme.color.contentCellSeparator) {
        topTitleLabel.textColor = topTitleColor
        topTitleLabel.font = topTitleFont
        
        titleLabel.textColor = titleColor
        titleLabel.font = titleFont
        
        subtitleLabel.textColor = subtitleColor
        subtitleLabel.font = subtitleFont
        
        dateLabel.textColor = dateColor
        dateLabel.font = dateFont
        
        separator.backgroundColor = separatorColor
    }
    
    func configure(with viewModel: BaseViewModel) {
        guard let viewModel = viewModel as? ContentCellViewModel else { return }
        self.viewModel = viewModel
        topTitleLabel.text = viewModel.topTitle
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        dateLabel.text = viewModel.dateString
        
        configureImage(with: viewModel.imageState.value)
        viewModel.imageState.valueChanged = { [weak self] state in
            self?.configureImage(with: state)
        }
    }
}

private extension ContentCell {
    func configureImage(with state: ImageState) {
        switch state {
        case .none:
            hideLoading()
            contentImageView.image = nil
        case .loading:
            showLoadinng()
            contentImageView.image = nil
        case .fail:
            hideLoading()
            contentImageView.image = nil
        case .loadedImage(let image):
            hideLoading()
            contentImageView.image = image
        }
    }
    
    func loadImage() {
        // viewModel?.reloadImage()
    }
    
    func showLoadinng() {
        loadingView.showLoading(on: contentImageView)
    }
    
    func hideLoading() {
        loadingView.removeFromSuperview()
    }
}

