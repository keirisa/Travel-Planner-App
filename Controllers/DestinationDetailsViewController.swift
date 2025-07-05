//
//  DestinationDetailsViewController.swift
//  Travel Planner App
//
//  Created by Kate Alyssa Joanna L. de Leon on 4/14/25.
//

import UIKit

class DestinationDetailsViewController: UIViewController {

    var apiDestination: APIDestination!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if self.navigationController?.viewControllers.count == 1 {
            let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissSelf))
            navigationItem.leftBarButtonItem = backButton
        }

        navigationItem.title = apiDestination.name
        navigationItem.titleView?.isHidden = false
        view.backgroundColor = UIColor.systemGroupedBackground

        configureView()
        fetchWeatherData()
        checkIfFavorited()
        applyCenteredLayout()
        favoriteButton.setTitleColor(.white, for: .normal)
        favoriteButton.backgroundColor = .systemBlue
    }


    // MARK: - View Setup
    
    private func applyCenteredLayout() {
        [imageView, nameLabel, categoryLabel, descriptionTextView,
         temperatureLabel, weatherImageView,
         favoriteButton].forEach { $0?.translatesAutoresizingMaskIntoConstraints = false }

        // Weather container (card)
        let weatherCard = UIView()
        weatherCard.translatesAutoresizingMaskIntoConstraints = false
        weatherCard.layer.cornerRadius = 10
        weatherCard.backgroundColor = UIColor.white
        weatherCard.layer.shadowColor = UIColor.black.cgColor
        weatherCard.layer.shadowOpacity = 0.1
        weatherCard.layer.shadowOffset = CGSize(width: 0, height: 2)
        weatherCard.layer.shadowRadius = 4
        view.addSubview(weatherCard)

        weatherCard.addSubview(temperatureLabel)
        weatherCard.addSubview(weatherImageView)

        NSLayoutConstraint.activate([
            // Image View
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            imageView.heightAnchor.constraint(equalToConstant: 220),

            // Name Label
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 25),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // Category Label
            categoryLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            categoryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // Description
            descriptionTextView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 40),
            descriptionTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionTextView.widthAnchor.constraint(equalTo: imageView.widthAnchor),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 90),

            // Weather Card
            weatherCard.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 30),
            weatherCard.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherCard.widthAnchor.constraint(equalToConstant: 160),
            weatherCard.heightAnchor.constraint(equalToConstant: 60),

            // Temperature Label inside card
            temperatureLabel.centerYAnchor.constraint(equalTo: weatherCard.centerYAnchor),
            temperatureLabel.leadingAnchor.constraint(equalTo: weatherCard.leadingAnchor, constant: 16),

            // Weather Icon inside card
            weatherImageView.centerYAnchor.constraint(equalTo: weatherCard.centerYAnchor),
            weatherImageView.trailingAnchor.constraint(equalTo: weatherCard.trailingAnchor, constant: -16),
            weatherImageView.widthAnchor.constraint(equalToConstant: 28),
            weatherImageView.heightAnchor.constraint(equalToConstant: 28),

            // Favorite Button
            favoriteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            favoriteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 220),
            favoriteButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        // Optional polish
        favoriteButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        favoriteButton.setTitleColor(.white, for: .normal)
        favoriteButton.backgroundColor = .systemBlue
        favoriteButton.layer.cornerRadius = 12
    }



    private func configureView() {
        guard let destination = apiDestination else {
            print("APIDestination is nil")
            return
        }

        nameLabel.text = destination.name
        categoryLabel.text = destination.category
        descriptionTextView.text = destination.description

        if let urlString = destination.imageURL, let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.imageView.image = image
                    }
                }
            }.resume()
        }
    }

    // MARK: - Weather Fetch

    private func fetchWeatherData() {
        guard let destination = apiDestination else { return }

        let cityName = destination.name
        let countryCode = "CA"

        Task {
            do {
                let cityWeather = try await WeatherController.shared.fetchCityWeather(for: cityName, countryCode: countryCode)

                DispatchQueue.main.async {
                    self.temperatureLabel.text = cityWeather.temperature

                    WeatherController.shared.fetchImage(for: cityWeather.iconCode) { data in
                        if let data = data {
                            DispatchQueue.main.async {
                                self.weatherImageView.image = UIImage(data: data)
                            }
                        }
                    }
                }
            } catch {
                print("Failed to fetch weather for \(cityName): \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.temperatureLabel.text = "N/A"
                }
            }
        }
    }

    // MARK: - Favorites Handling

    private func checkIfFavorited() {
        guard let username = UserDefaults.standard.string(forKey: "currentUser"),
              let user = CoreDataManager.shared.findUser(username: username) else {
            return
        }

        let favorites = CoreDataManager.shared.getFavoriteDestinations(for: user)
        let isFavorited = favorites.contains { $0.id == apiDestination.id }
        updateFavoriteButtonUI(isFavorited: isFavorited)
    }

    private func updateFavoriteButtonUI(isFavorited: Bool) {
        if isFavorited {
            favoriteButton.setTitle("Remove", for: .normal)
            favoriteButton.backgroundColor = .red
        } else {
            favoriteButton.setTitle("Save", for: .normal)
            favoriteButton.backgroundColor = .systemBlue
        }
    }
    
    @objc private func dismissSelf() {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Actions

    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        guard let username = UserDefaults.standard.string(forKey: "currentUser"),
              let user = CoreDataManager.shared.findUser(username: username) else {
            showAlert(message: "User not found")
            return
        }

        let favorites = CoreDataManager.shared.getFavoriteDestinations(for: user)
        let isFavorited = favorites.contains { $0.id == apiDestination.id }

        if isFavorited {
            if let destination = CoreDataManager.shared.findDestination(id: apiDestination.id) {
                CoreDataManager.shared.removeDestinationFromFavorites(destination: destination, for: user)
                updateFavoriteButtonUI(isFavorited: false)
                DispatchQueue.main.async {
                    self.showAlert(message: "Removed from Destination List")
                }
            }
        } else {
            if CoreDataManager.shared.saveDestination(apiDestination: apiDestination, for: user) != nil {
                updateFavoriteButtonUI(isFavorited: true)
                DispatchQueue.main.async {
                    self.showAlert(message: "Destination Saved!")
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(message: "Failed to add to favorites")
                }
            }
        }
    }


    // MARK: - Alerts

    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
