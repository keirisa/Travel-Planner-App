//
//  DestinationCollectionViewCell.swift
//  Travel Planner App
//
//  Created by Kate Alyssa Joanna L. de Leon on 4/14/25.
//

import UIKit

class DestinationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    var onDeleteTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        applyConstraints()
    }
    
    private func setupUI() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.systemGray4.cgColor
        contentView.clipsToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 1
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        deleteButton.setTitle("Remove", for: .normal)
        deleteButton.setTitleColor(.systemRed, for: .normal)
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            // Image (top)
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.85),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.75),
            
            // Name Label (below image)
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 6),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // Delete button (bottom)
            deleteButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
            deleteButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    @objc private func deleteTapped() {
        onDeleteTapped?()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
    }
}
