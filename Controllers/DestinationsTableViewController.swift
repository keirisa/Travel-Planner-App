//
//  DestinationsTableViewController.swift
//  Travel Planner App
//
//  Created by Kate Alyssa Joanna L. de Leon on 4/14/25.
//

import UIKit

class DestinationsTableViewController: UITableViewController {

    var destinations: [APIDestination] = []

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        title = "Destinations"
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        fetchDestinations()
    }

    // MARK: - Data Fetching

    private func fetchDestinations() {
        APIService.shared.fetchDestinations { [weak self] destinationsResponse, error in
            guard let self = self else { return }

            if let error = error {
                DispatchQueue.main.async {
                    print("DEBUG: Failed to decode destinations: \(error)")
                    self.showAlert(message: "Failed to load destinations.")
                }
                return
            }

            if let destinations = destinationsResponse {
                print("DEBUG: Loaded \(destinations.count) destinations")

                for (index, dest) in destinations.enumerated() {
                    print("🔎 [\(index)] Name: \(dest.name)")
                    print("    → desc: \(dest.description ?? "none")")
                    print("    → img: \(dest.imageURL ?? "none")")
                }

                self.destinations = destinations
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Table View Data Source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return destinations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DestinationCell", for: indexPath) as! DestinationTableViewCell
        let destination = destinations[indexPath.row]

        cell.nameLabel.text = destination.name
        cell.categoryLabel.text = destination.category
        cell.descriptionLabel.text = destination.description ?? "No description"

        if let urlString = destination.imageURL, let url = URL(string: urlString) {
            cell.destinationImageView.image = UIImage(named: "placeholder")

            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.destinationImageView.image = image
                    }
                }
            }.resume()
        } else {
            cell.destinationImageView.image = nil
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDestinationDetails", sender: indexPath)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDestinationDetails" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destination = destinations[indexPath.row]
                let detailsVC = segue.destination as! DestinationDetailsViewController
                detailsVC.apiDestination = destination
            }
        }
    }

    // MARK: - Helper Methods

    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
