//
//  NewCocktailViewController.swift
//  cocktail formula
//
//  Created by Максим on 27.03.2025.
//

import UIKit
import PhotosUI

class NewCocktailViewController: UIViewController {
    
    @IBOutlet weak var cocktailImageName: UIImageView!
    @IBOutlet weak var cocktailNameField: UITextField!
    @IBOutlet weak var cocktailBaseSpiritField: UITextField!
    @IBOutlet weak var cocktailStrengthField: UITextField!
    @IBOutlet weak var cocktailFlavourField: UITextField!
    @IBOutlet weak var cocktailDietaryField: UITextField!
    @IBOutlet weak var addCocktailButton: UIButton!
    
    
    private let manager = DatabaseManager()
    private var imageSelectedByUser: Bool = false
    
    var cocktail: CocktailEntity?
    var pickerViewBaseSpirit = UIPickerView()
    var pickerViewStrength = UIPickerView()
    var pickerViewFlavour = UIPickerView()
    var pickerViewDietary = UIPickerView()
    
    var baseSpiritArray = ["Абсент", "Аквавит", "Арак", "Бурбон", "Вермут", "Вино", "Виски", "Водка", "Газировка", "Граппа", "Джин", "Игристое", "Кальвадос", "Кашас", "Коньяк", "Кофе", "Ликер", "Мескаль", "Молоко", "Пиво", "Писко", "Ром", "Саке", "Самбука", "Соджу", "Содовая", "Сок", "Текила", "Херес", "Чай"]
    var strengthArray = ["Безалкогольный", "Крепкий", "Слабоалкогольный"]
    var flavourArray = ["Горький", "Кислый", "Кофейный", "Мятный"]
    var dietaryArray = ["Диетический", "Не диетический"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        pickerViewBaseSpirit.delegate = self
        pickerViewStrength.delegate = self
        pickerViewFlavour.delegate = self
        pickerViewDietary.delegate = self
        pickerViewBaseSpirit.tag = 1
        pickerViewStrength.tag = 2
        pickerViewFlavour.tag = 3
        pickerViewDietary.tag = 4
        fieldsInputView()

    }

}

extension NewCocktailViewController {
    
    func configuration() {
        uiconfiguration()
        addGesture()
        userDetaliConfiguration()
        
    }
    
    func uiconfiguration() {
        cocktailImageName.layer.cornerRadius = cocktailImageName.frame.size.width / 2
        cocktailImageName.clipsToBounds = true
        
    }
    
    func addGesture() {
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(NewCocktailViewController.openGallery))
        cocktailImageName.isUserInteractionEnabled = true
        cocktailImageName.addGestureRecognizer(imageTap)
    }

    func userDetaliConfiguration() {
        if let cocktail {
            addCocktailButton.setTitle("Update", for: .normal)
            navigationItem.title = "Update User"
            cocktailNameField.text = cocktail.cocktailName
            cocktailBaseSpiritField.text = cocktail.baseSpirits
            cocktailStrengthField.text = cocktail.strength
            cocktailFlavourField.text = cocktail.flavour
            cocktailDietaryField.text = cocktail.dietary

            let imageURL = URL.documentsDirectory.appending(components: cocktail.cocktailImage ?? "").appendingPathExtension("png")
            cocktailImageName.image = UIImage(contentsOfFile: imageURL.path)

            imageSelectedByUser = true
        } else {
            navigationItem.title = "Add User"
            addCocktailButton.setTitle("Register", for: .normal)
        }
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        guard let cocktailName = cocktailNameField.text, !cocktailName.isEmpty else {
            openAlert(message: "Введите название коктейля")
            return
        }
        
        guard let cocktailBaseSpirit = cocktailBaseSpiritField.text, !cocktailBaseSpirit.isEmpty else {
            openAlert(message: "Выберите основу коктейля")
            return
        }
        
        guard let cocktailStrength = cocktailStrengthField.text, !cocktailBaseSpirit.isEmpty else {
            openAlert(message: "Выберите градус")
            return
        }
        
        guard let cocktailFlavour = cocktailFlavourField.text, !cocktailBaseSpirit.isEmpty else {
            openAlert(message: "Выберите вкус")
            return
        }
        
        guard let cocktailDietary = cocktailDietaryField.text, !cocktailDietary.isEmpty else {
            openAlert(message: "Не заполнено последнее поле")
            return
        }
        
        if !imageSelectedByUser {
            openAlert(message: "Выберите изображение коктейля")
            return
        }
        
        if let cocktail {
            
            let newCocktail = CocktailModel(
                cocktailName: cocktailName,
                cocktailImage: cocktail.cocktailImage ?? "",
                baseSpirits: cocktailBaseSpirit,
                strength: cocktailStrength,
                dietary: cocktailDietary,
                flavour: cocktailFlavour
            )
            
            manager.updateCocktail(cocktail: newCocktail, cocktailEntity: cocktail)
            saveImageToDocumentDirectory(imageName: newCocktail.cocktailImage)
            
        } else {
            
            let imageName = UUID().uuidString
            let newCocktail = CocktailModel(cocktailName: cocktailName, cocktailImage: imageName, baseSpirits: cocktailBaseSpirit, strength: cocktailStrength, dietary: cocktailDietary, flavour: cocktailFlavour)
            
            saveImageToDocumentDirectory(imageName: imageName)
            manager.addCocktail(newCocktail)
            
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    
    func saveImageToDocumentDirectory(imageName: String) {
        let fileURL = URL.documentsDirectory.appending(components: imageName).appendingPathExtension("png")
        if let data = cocktailImageName.image?.pngData() {
            do {
                try data.write(to: fileURL)
            } catch {
                print("Saving image to Document Directory error:", error)
            }
        }
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: nil, message: "User added", preferredStyle: .alert)
        let okay = UIAlertAction(title: "Okay", style: .default)
        alertController.addAction(okay)
        present(alertController, animated: true)
    }
    
    @objc func openGallery() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1

        let pickerVC = PHPickerViewController(configuration: config)
        pickerVC.delegate = self
        present(pickerVC, animated: true)
    }
    
    
    
}
    

extension NewCocktailViewController {

    func openAlert(message: String){
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okay = UIAlertAction(title: "Okay", style: .default)
        alertController.addAction(okay)
        present(alertController, animated: true)
    }

}

extension NewCocktailViewController: PHPickerViewControllerDelegate {

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                guard let image = image as? UIImage else { return }
                DispatchQueue.main.async {
                    self.cocktailImageName.image = image
                    self.imageSelectedByUser = true
                }
            }
        }
    }
}

extension NewCocktailViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return baseSpiritArray.count
        } else if pickerView.tag == 2 {
            return strengthArray.count
        } else if pickerView.tag == 3 {
            return flavourArray.count
        } else {
            return dietaryArray.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return "\(baseSpiritArray[row])"
        } else if pickerView.tag == 2 {
            return "\(strengthArray[row])"
        } else if pickerView.tag == 3 {
            return "\(flavourArray[row])"
        } else {
            return "\(dietaryArray[row])"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            cocktailBaseSpiritField.text = baseSpiritArray[row]
        } else if pickerView.tag == 2 {
            cocktailStrengthField.text = strengthArray[row]
        } else if pickerView.tag == 3 {
            cocktailFlavourField.text = flavourArray[row]
        } else {
            cocktailDietaryField.text = dietaryArray[row]
        }
    }
    
}

extension NewCocktailViewController {
    
    func fieldsInputView() {
        cocktailBaseSpiritField.inputView = pickerViewBaseSpirit
        cocktailStrengthField.inputView = pickerViewStrength
        cocktailFlavourField.inputView = pickerViewFlavour
        cocktailDietaryField.inputView = pickerViewDietary
    }
    
}
    

