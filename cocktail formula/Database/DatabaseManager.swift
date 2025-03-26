//
//  DatabaseManager.swift
//  cocktail formula
//
//  Created by Максим on 26.03.2025.
//

import UIKit
import CoreData

class DatabaseManager {
    
    private var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func addUser(_ cocktail: CocktailModel) {
        let cocktailEntity = CocktailEntity(context: context)
        addUpdateCocktail(cocktailEntity: cocktailEntity, cocktail: cocktail)
    }
    
    func updateCocktail(cocktail: CocktailModel, cocktailEntity: CocktailEntity) {
        addUpdateCocktail(cocktailEntity: cocktailEntity, cocktail: cocktail)
    }
    
    private func addUpdateCocktail(cocktailEntity: CocktailEntity, cocktail: CocktailModel) {
        cocktailEntity.cocktailName = cocktail.cocktailName
        cocktailEntity.cocktailImage = cocktail.cocktailImage
        cocktailEntity.strength = cocktail.strength
        cocktailEntity.flavour = cocktail.flavour
        cocktailEntity.dietary = cocktail.dietary
        cocktailEntity.baseSpirits = cocktail.baseSpirits
    }
    
    func fetchUsers() -> [CocktailEntity] {
        var coctails: [CocktailEntity] = []

        do {
            coctails = try context.fetch(CocktailEntity.fetchRequest())
        }catch {
            print("Fetch cocktail error", error)
        }

        return coctails
    }
    
    func saveContext() {
        do {
            try context.save()
        }catch {
            print("User saving error:", error)
        }
    }

    func deleteUser(cocktailEntity: CocktailEntity) {
        let imageURL = URL.documentsDirectory.appending(components: cocktailEntity.cocktailImage ?? "").appendingPathExtension("png")
        do {
            try FileManager.default.removeItem(at: imageURL)
        }catch {
            print("remove image from DD", error)
        }
        context.delete(cocktailEntity)
        saveContext()
    }
    
}
