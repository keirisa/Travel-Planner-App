//
//  TripDetailsViewController.swift
//  Travel Planner App
//
//  Created by Kate Alyssa Joanna L. de Leon on 4/14/25.
//

import UIKit

class TripDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var trip: Trip!

    // MARK: - IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var travelModeLabel: UILabel!
    @IBOutlet weak var destinationsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Trip Details"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTripButtonTapped))

        destinationsTableView.delegate = self
        destinationsTableView.dataSource = self
        destinationsTableView.isScrollEnabled = false
        destinationsTableView.tableFooterView = UIView()

        styleLabels()
        applyConstraints()
        configureView()
    }

    // MARK: - UI Setup

    private func styleLabels() {
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        startDateLabel.font = UIFont.systemFont(ofSize: 16)
        durationLabel.font = UIFont.systemFont(ofSize: 16)
        travelModeLabel.font = UIFont.systemFont(ofSize: 16)
    }

    private func applyConstraints() {
        [nameLabel, startDateLabel, durationLabel, travelModeLabel, destinationsTableView].forEach {
            $0?.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            startDateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
            startDateLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),

            durationLabel.topAnchor.constraint(equalTo: startDateLabel.bottomAnchor, constant: 8),
            durationLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),

            travelModeLabel.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: 8),
            travelModeLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),

            destinationsTableView.topAnchor.constraint(equalTo: travelModeLabel.bottomAnchor, constant: 20),
            destinationsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            destinationsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            destinationsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func configureView() {
        nameLabel.text = trip.name

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        startDateLabel.text = "Start Date: \(trip.startDate != nil ? formatter.string(from: trip.startDate!) : "N/A")"

        durationLabel.text = "Duration: \(trip.duration) days"
        travelModeLabel.text = "Travel Mode: \(trip.travelMode ?? "N/A")"
    }

    // MARK: - Edit Trip

    @objc private func editTripButtonTapped() {
        performSegue(withIdentifier: "editTrip", sender: nil)
    }

    // MARK: - TableView Data Source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trip.destinations?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripDetailCell", for: indexPath)

        if let destinations = trip.destinations?.allObjects as? [Destination], indexPath.row < destinations.count {
            let destination = destinations[indexPath.row]
            cell.textLabel?.text = destination.name
            cell.detailTextLabel?.text = destination.category
        }

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTrip" {
            let createTripVC = segue.destination as! CreateTripViewController
            createTripVC.trip = trip
        }
    }
}
