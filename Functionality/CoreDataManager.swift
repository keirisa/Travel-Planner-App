//
//  CoreDataManager.swift
//  Travel Planner App
//
//  Created by Kate Alyssa Joanna L. de Leon on 4/14/25.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    // MARK: - User Operations
    
    func registerUser(username: String, password: String) -> Bool {
        // Check if user already exists
        if findUser(username: username) != nil {
            return false
        }
        
        let user = User(context: context)
        user.username = username
        user.password = password
        
        do {
            try context.save()
            return true
        } catch {
            print("Failed to register user: \(error)")
            return false
        }
    }
    
    func loginUser(username: String, password: String) -> User? {
        let user = findUser(username: username)
        
        if user?.password == password {
            return user
        }
        
        return nil
    }
    
    func findUser(username: String) -> User? {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", username)
        
        do {
            let users = try context.fetch(fetchRequest)
            return users.first
        } catch {
            print("Failed to find user: \(error)")
            return nil
        }
    }
    
    // MARK: - Destination Operations
    
    func saveDestination(apiDestination: APIDestination, for user: User) -> Destination? {
        // Check if destination already exists
        let existingDestination = findDestination(id: apiDestination.id)
        
        let destination: Destination
        
        if let existingDestination = existingDestination {
            destination = existingDestination
        } else {
            destination = Destination(context: context)
            destination.id = apiDestination.id
            destination.name = apiDestination.name
            destination.desc = apiDestination.description
            destination.category = apiDestination.category
            destination.imageURL = apiDestination.imageURL
        }
        
        user.addToFavorites(destination)
        
        do {
            try context.save()
            return destination
        } catch {
            print("Failed to save destination: \(error)")
            return nil
        }
    }
    
    func findDestination(id: String) -> Destination? {
        let fetchRequest: NSFetchRequest<Destination> = Destination.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let destinations = try context.fetch(fetchRequest)
            return destinations.first
        } catch {
            print("Failed to find destination: \(error)")
            return nil
        }
    }
    
    func removeDestinationFromFavorites(destination: Destination, for user: User) {
        user.removeFromFavorites(destination)
        
        do {
            try context.save()
        } catch {
            print("Failed to remove destination from favorites: \(error)")
        }
    }
    
    func getFavoriteDestinations(for user: User) -> [Destination] {
        guard let favorites = user.favorites?.allObjects as? [Destination] else {
            return []
        }
        
        return favorites
    }
    
    // MARK: - Trip Operations
    
    func createTrip(name: String, startDate: Date, duration: Int16, travelMode: String, destinations: [Destination], for user: User) -> Trip? {
        let trip = Trip(context: context)
        trip.name = name
        trip.startDate = startDate
        trip.duration = duration
        trip.travelMode = travelMode
        trip.user = user
        
        for destination in destinations {
            trip.addToDestinations(destination)
        }
        
        do {
            try context.save()
            return trip
        } catch {
            print("Failed to create trip: \(error)")
            return nil
        }
    }
    
    func getTrips(for user: User) -> [Trip] {
        guard let trips = user.trips?.allObjects as? [Trip] else {
            return []
        }
        
        return trips
    }
    
    func deleteTrip(trip: Trip) {
        context.delete(trip)
        
        do {
            try context.save()
        } catch {
            print("Failed to delete trip: \(error)")
        }
    }
}
