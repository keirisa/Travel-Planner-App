//
//  CreateTripViewController.swift
//  Travel Planner App
//
//  Created by Kate Alyssa Joanna L. de Leon on 4/14/25.
//

import UIKit

class CreateTripViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var trip: Trip?
    var allDestinations: [Destination] = []
    var selectedDestinations: [Destination] = []
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var durationStepper: UIStepper!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var travelModePicker: UIPickerView!
    @IBOutlet weak var destinationsTableView: UITableView!
    
    private let travelModes = ["Car", "Flight", "Train", "Boat"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = trip == nil ? "Create Trip" : "Edit Trip"

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))

        destinationsTableView.delegate = self
        destinationsTableView.dataSource = self
        travelModePicker.delegate = self
        travelModePicker.dataSource = self

        // Setup constraints
        [nameTextField, startDatePicker, durationLabel, durationStepper, travelModePicker, destinationsTableView].forEach {
            $0?.translatesAutoresizingMaskIntoConstraints = false
            nameTextField.placeholder = "Trip name"
            nameTextField.borderStyle = .roundedRect

            durationLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            durationLabel.textAlignment = .center

            travelModePicker.layer.cornerRadius = 8
            view.addSubview($0!)
        }

        setupConstraints()
        //loadAllDestinations()
        
        if let trip = trip {
            configureForEditingTrip(trip)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadAllDestinations() // refresh the destination list on every appearance
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // Name Text Field
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),

            // Start Date Picker
            startDatePicker.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 40),
            startDatePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // Duration Label (above stepper)
            durationLabel.topAnchor.constraint(equalTo: startDatePicker.bottomAnchor, constant: 40),
            durationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // Duration Stepper (centered below label)
            durationStepper.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: 8),
            durationStepper.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // Travel Mode Picker
            travelModePicker.topAnchor.constraint(equalTo: durationStepper.bottomAnchor, constant: 30),
            travelModePicker.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            travelModePicker.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            travelModePicker.heightAnchor.constraint(equalToConstant: 100),

            // Destinations Table
            destinationsTableView.topAnchor.constraint(equalTo: travelModePicker.bottomAnchor, constant: 20),
            destinationsTableView.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            destinationsTableView.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            destinationsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }

    
    private func loadAllDestinations() {
        // This should fetch all destinations from Core Data or API
        // For now, we'll just use saved destinations
        guard let username = UserDefaults.standard.string(forKey: "currentUser"),
              let user = CoreDataManager.shared.findUser(username: username) else {
            return
        }
        
        allDestinations = CoreDataManager.shared.getFavoriteDestinations(for: user)
        destinationsTableView.reloadData()
    }
    
    private func configureForEditingTrip(_ trip: Trip) {
        nameTextField.text = trip.name
        if let startDate = trip.startDate {
            startDatePicker.date = startDate
        }
        durationStepper.value = Double(trip.duration)
        durationLabel.text = "\(trip.duration) days"
        
        if let travelMode = trip.travelMode,
           let index = travelModes.firstIndex(of: travelMode) {
            travelModePicker.selectRow(index, inComponent: 0, animated: false)
        }
        
        if let destinations = trip.destinations?.allObjects as? [Destination] {
            selectedDestinations = destinations
        }
    }
    
    @IBAction func durationStepperChanged(_ sender: UIStepper) {
        durationLabel.text = "\(Int(sender.value)) days"
    }
    
    @objc private func saveButtonTapped() {
        guard let name = nameTextField.text, !name.isEmpty else {
            showAlert(message: "Please enter a trip name")
            return
        }
        
        guard !selectedDestinations.isEmpty else {
            showAlert(message: "Please select at least one destination")
            return
        }
        
        guard let username = UserDefaults.standard.string(forKey: "currentUser"),
              let user = CoreDataManager.shared.findUser(username: username) else {
            showAlert(message: "User not found")
            return
        }
        
        let travelMode = travelModes[travelModePicker.selectedRow(inComponent: 0)]
        
        if let trip = trip {
            // Update existing trip
            trip.name = name
            trip.startDate = startDatePicker.date
            trip.duration = Int16(durationStepper.value)
            trip.travelMode = travelMode
            
            // Update destinations
            trip.destinations = NSSet(array: selectedDestinations)
            
            do {
                try CoreDataManager.shared.context.save()
                navigationController?.popViewController(animated: true)
            } catch {
                showAlert(message: "Failed to save trip: \(error.localizedDescription)")
            }
        } else {
            // Create new trip
            if CoreDataManager.shared.createTrip(name: name, startDate: startDatePicker.date, duration: Int16(durationStepper.value), travelMode: travelMode, destinations: selectedDestinations, for: user) != nil {
                navigationController?.popViewController(animated: true)
            } else {
                showAlert(message: "Failed to create trip")
            }
        }
    }
    
    // MARK: - Table View Data Source & Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allDestinations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DestinationSelectCell", for: indexPath)
        
        let destination = allDestinations[indexPath.row]
        cell.textLabel?.text = destination.name
        
        if selectedDestinations.contains(where: { $0.id == destination.id }) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let destination = allDestinations[indexPath.row]
        
        if let index = selectedDestinations.firstIndex(where: { $0.id == destination.id }) {
            selectedDestinations.remove(at: index)
        } else {
            selectedDestinations.append(destination)
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: - Picker View Data Source & Delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return travelModes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return travelModes[row]
    }
    
    // MARK: - Helper Methods
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
