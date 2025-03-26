//
//  CocktailsListViewController.swift
//  cocktail formula
//
//  Created by Максим on 26.03.2025.
//

import UIKit

class CocktailsListViewController: UIViewController {
    
    @IBOutlet weak var cocktailTableView: UITableView!
    
    private var coctails: [CocktailEntity] = []
    private let manager = DatabaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cocktailTableView.register(UINib(nibName: "CocktailCell", bundle: nil), forCellReuseIdentifier: "CocktailCell")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coctails = manager.fetchUsers()
        cocktailTableView.reloadData()
    }
    
}
