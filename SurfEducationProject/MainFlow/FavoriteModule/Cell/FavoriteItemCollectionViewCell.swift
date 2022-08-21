//
//  FavoriteItemCollectionViewCell.swift
//  SurfEducationProject
//
//  Created by molexey on 20.08.2022.
//

import UIKit

class FavoriteItemCollectionViewCell: UICollectionViewCell {

    // MARK: - Constants

    private enum Constants {
        static let fillHeartImage = UIImage(named: "heart-fill")
        static let heartImage = UIImage(named: "heart")
    }
    
    // MARK: - Views
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - Events
    
    var didFavoriteTapped: (() -> Void)?
    
    // MARK: - Calculated
    
    var buttonImage: UIImage? {
        return isFavorite ? Constants.fillHeartImage : Constants.heartImage
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.2) {
                self.contentView.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.98, y: 0.98) : .identity
            }
        }
    }
    
    // MARK: - Properties

    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var content: String = "" {
        didSet {
            textLabel.text = content
        }
    }
    
    var date: String = "" {
        didSet {
            dateLabel.text = date
        }
    }
    
    var imageUrlInString: String = "" {
        didSet {
            guard let url = URL(string: imageUrlInString) else {
                return
            }
            imageView.loadImage(from: url)
        }
    }
    
    var isFavorite: Bool = false {
        didSet {
            favoriteButton.setImage(buttonImage, for: .normal)
        }
    }

    // MARK: - Actions
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        didFavoriteTapped?()
        isFavorite.toggle()
    }
    
    
    // MARK: - UICollectionViewCell
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureAppearance()
    }

}

// MARK: - Private Methods

private extension FavoriteItemCollectionViewCell {

    func configureAppearance() {
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        
        textLabel.adjustsFontSizeToFitWidth = false
        textLabel.lineBreakMode = .byTruncatingTail
        textLabel.textColor = .black
        textLabel.font = .systemFont(ofSize: 12)
        
        dateLabel.textColor = .lightGray
        dateLabel.font = .systemFont(ofSize: 10, weight: .medium)

        imageView.layer.cornerRadius = 12

        favoriteButton.tintColor = .white
        isFavorite = false
    }

}
