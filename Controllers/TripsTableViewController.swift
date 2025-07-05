//
//  TripsTableViewController.swift
//  Travel Planner App
//
//  Created by Kate Alyssa Joanna L. de Leon on 4/14/25.
//

import UIKit

class TripsTableViewController: UITableViewController {
    
    var trips: [Trip] = []
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My Trips"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createTripButtonTapped))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadTrips()
    }
    
    // MARK: - Data Loading
    
    private func loadTrips() {
        guard let username = UserDefaults.standard.string(forKey: "currentUser"),
              let user = CoreDataManager.shared.findUser(username: username) else {
            return
        }
        
        trips = CoreDataManager.shared.getTrips(for: user)
        tableView.reloadData()
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripCell", for: indexPath) as! TripTableViewCell
        let trip = trips[indexPath.row]
        
        cell.nameLabel.text = trip.name
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        cell.dateLabel.text = trip.startDate != nil ? dateFormatter.string(from: trip.startDate!) : "No start date"

        let count = trip.destinations?.count ?? 0
        cell.destinationsCountLabel.text = "\(count) destination\(count == 1 ? "" : "s")"
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showTripDetails", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let trip = trips[indexPath.row]
            CoreDataManager.shared.deleteTrip(trip: trip)
            
            trips.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    
    // MARK: - Actions
    
    @objc private func createTripButtonTapped() {
        performSegue(withIdentifier: "createTrip", sender: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTripDetails" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let trip = trips[indexPath.row]
                let tripDetailsVC = segue.destination as! TripDetailsViewController
                tripDetailsVC.trip = trip
            }
        }
    }
}
