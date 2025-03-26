//
//  CocktailCell.swift
//  cocktail formula
//
//  Created by Максим on 26.03.2025.
//

import UIKit

class CocktailCell: UITableViewCell {
    
    @IBOutlet weak var cellCocktailImage: UIImageView!
    @IBOutlet weak var cellCocktailName: UILabel!
    @IBOutlet weak var cellBaseSpirits: UILabel!
    @IBOutlet weak var cellStrength: UILabel!
    
    var cocktail: CocktailEntity? {
        didSet {
            cocktailConfiguration()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        cellCocktailImage.layer.cornerRadius = cellCocktailImage.frame.size.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func cocktailConfiguration() {
        guard let cocktail else { return }
        cellCocktailName.text = cocktail.cocktailName
        cellBaseSpirits.text = cocktail.baseSpirits
        cellStrength.text = cocktail.strength
        
        let imageURL = URL.documentsDirectory.appending(components: cocktail.cocktailImage ?? "").appendingPathExtension("png")
        cellCocktailImage.image = UIImage(contentsOfFile: imageURL.path)
    }

}
