//
//  SavedDestinationsCollectionViewController
//  Travel Planner App
//
//  Created by Kate Alyssa Joanna L. de Leon on 4/14/25.
//

import UIKit

class SavedDestinationsViewController: UICollectionViewController {
    
    var destinations: [Destination] = []
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Favorites"
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadFavorites()
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 16

        let padding: CGFloat = 24
        let spacing: CGFloat = layout.minimumInteritemSpacing
        let width = (collectionView.frame.width - padding - spacing) / 2

        layout.itemSize = CGSize(width: width, height: width * 1.5)
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.contentInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }

    
    // MARK: - Data Loading
    
    private func loadFavorites() {
        guard let username = UserDefaults.standard.string(forKey: "currentUser"),
              let user = CoreDataManager.shared.findUser(username: username) else {
            return
        }
        
        destinations = CoreDataManager.shared.getFavoriteDestinations(for: user)
        collectionView.reloadData()
    }
    
    // MARK: - Collection View Data Source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return destinations.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedCell", for: indexPath) as! DestinationCollectionViewCell
        
        let destination = destinations[indexPath.item]
        
        cell.nameLabel.text = destination.name
        
        // Load image asynchronously
        if let imageURL = destination.imageURL, let url = URL(string: imageURL) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.imageView.image = image
                    }
                }
            }.resume()
        }
        
        cell.onDeleteTapped = { [weak self] in
            self?.removeFromFavorites(at: indexPath)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: collectionView.frame.width - 24,
            height: 100 // or calc dynamically
        )
    }
    
    // MARK: - Actions
    
    private func removeFromFavorites(at indexPath: IndexPath) {
        guard destinations.indices.contains(indexPath.item) else {
            print("⚠️ Invalid indexPath.item: \(indexPath.item)")
            return
        }

        guard let username = UserDefaults.standard.string(forKey: "currentUser"),
              let user = CoreDataManager.shared.findUser(username: username) else {
            return
        }

        let destination = destinations[indexPath.item]

        // Remove from Core Data
        CoreDataManager.shared.removeDestinationFromFavorites(destination: destination, for: user)

        // Update data source
        destinations.remove(at: indexPath.item)

        // Avoid crashing when deleting the last cell
        if destinations.isEmpty {
            collectionView.reloadData()
        } else {
            collectionView.deleteItems(at: [indexPath])
        }
    }

}
