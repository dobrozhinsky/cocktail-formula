//
//  CocktailsListViewController.swift
//  cocktail formula
//
//  Created by Максим on 26.03.2025.
//

import UIKit

class CocktailsListViewController: UIViewController {
    
    @IBOutlet weak var cocktailTableView: UITableView!
    
    private var cocktails: [CocktailEntity] = []
    private let manager = DatabaseManager()
    
    var selectedCocktailName: String?
    var selectedCocktailImage: String?
    var selectedBaseSpirits: String?
    var selectedStrength: String?
    var selectedDietary: String?
    var selectedFlavour: String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cocktailTableView.register(UINib(nibName: "CocktailCell", bundle: nil), forCellReuseIdentifier: "CocktailCell")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cocktails = manager.fetchUsers()
        cocktailTableView.reloadData()
    }
    
    @IBAction func addCoctailTap(_ sender: Any) {
        addUpdateCocktailNavigation()
        
        
    }
    
    func addUpdateCocktailNavigation(cocktail: CocktailEntity? = nil) {
        
        guard let newCocktailVC = self.storyboard?.instantiateViewController(withIdentifier: "NewCocktailViewController") as? NewCocktailViewController else { return }
        newCocktailVC.cocktail = cocktail
        navigationController?.pushViewController(newCocktailVC, animated: true)
        
    }

}

extension CocktailsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cocktails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CocktailCell") as? CocktailCell else { return UITableViewCell() }
        let cocktail = cocktails[indexPath.row]
        cell.cocktail = cocktail
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCocktailName = cocktails[indexPath.row].cocktailName
        selectedCocktailImage = cocktails[indexPath.row].cocktailImage
        selectedBaseSpirits = cocktails[indexPath.row].baseSpirits
        selectedStrength = cocktails[indexPath.row].strength
        selectedFlavour = cocktails[indexPath.row].flavour
        selectedDietary = cocktails[indexPath.row].dietary
        self.performSegue(withIdentifier: "selectedCocktail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectedCocktail"{
            
            if let selectedCocktailVC = segue.destination as? SelectedCocktailViewController {
                selectedCocktailVC.cocktailName = selectedCocktailName
                selectedCocktailVC.cocktailImage = selectedCocktailImage
                selectedCocktailVC.baseSpirits = selectedBaseSpirits
                selectedCocktailVC.strength = selectedStrength
                selectedCocktailVC.flavour = selectedFlavour
                selectedCocktailVC.dietary = selectedDietary
            }
            
        }
        
    }
    
}

extension CocktailsListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let update = UIContextualAction(style: .normal, title: "Update") { _, _, _ in
            self.addUpdateCocktailNavigation(cocktail: self.cocktails[indexPath.row])
        }
        update.backgroundColor = .systemIndigo

        let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            self.manager.deleteCocktail(cocktailEntity: self.cocktails[indexPath.row])
            self.cocktails.remove(at: indexPath.row)
            self.cocktailTableView.reloadData()
        }

        return UISwipeActionsConfiguration(actions: [delete, update])
    }

}
