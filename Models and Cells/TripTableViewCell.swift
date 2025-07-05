//
//  TripTableViewCell.swift
//  Travel Planner App
//
//  Created by Kate Alyssa Joanna L. de Leon on 4/14/25.
//

import UIKit

class TripTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var destinationsCountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Font styling
        nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        dateLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        dateLabel.textColor = .gray
        destinationsCountLabel.font = UIFont.systemFont(ofSize: 14)
        destinationsCountLabel.textColor = .systemBlue

        // Disable autoresizing masks
        [nameLabel, dateLabel, destinationsCountLabel].forEach {
            $0?.translatesAutoresizingMaskIntoConstraints = false
        }

        applyConstraints()
    }

    private func applyConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),

            destinationsCountLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4),
            destinationsCountLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            destinationsCountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        dateLabel.text = nil
        destinationsCountLabel.text = nil
    }
}
