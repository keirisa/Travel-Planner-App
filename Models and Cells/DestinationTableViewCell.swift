//
//  DestinationTableViewCell.swift
//  Travel Planner App
//
//  Created by Kate Alyssa Joanna L. de Leon on 4/14/25.
//

import UIKit

class DestinationTableViewCell: UITableViewCell {

    // MARK: - IBOutlets (connected via storyboard)
    @IBOutlet weak var destinationImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Prevent stretched images or glitches
        destinationImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        // Configure image styling
        destinationImageView.contentMode = .scaleAspectFill
        destinationImageView.clipsToBounds = true
        destinationImageView.layer.cornerRadius = 8

        applyConstraints()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        destinationImageView.image = nil
        nameLabel.text = nil
        categoryLabel.text = nil
        descriptionLabel.text = nil
    }

    private func applyConstraints() {
        NSLayoutConstraint.activate([
            // Image View
            destinationImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            destinationImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            destinationImageView.widthAnchor.constraint(equalToConstant: 100),
            destinationImageView.heightAnchor.constraint(equalToConstant: 80),

            // Name Label
            nameLabel.topAnchor.constraint(equalTo: destinationImageView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: destinationImageView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),

            // Category Label
            categoryLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            categoryLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            categoryLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            // Description Label
            descriptionLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
