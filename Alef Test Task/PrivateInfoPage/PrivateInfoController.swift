//
//  ViewController.swift
//  Alef Test Task
//
//  Created by Rostislav on 3/31/21.
//

import UIKit
import SkyFloatingLabelTextField
import CoreData

class PrivateInfoController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var informationView: UIView!
    @IBOutlet weak var addChildButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addChildLabel: UILabel!
    @IBOutlet weak var addUserInfoButton: UIButton!
    
    private let context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var items:[Child] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNameTextField()
        makeSurnameTextField()
        makePatronymicNameTextField()
        makeAgeTextField()
        fetchChildren()
        tableView.dataSource = self
        tableView.delegate = self
        addUserInfoButton.layer.cornerRadius = 10
    }
    
    private func makeNameTextField(){
        let nameTextField = SkyFloatingLabelTextField(frame: CGRect(x: 5, y: 5, width: informationView.bounds.width - 10, height: 45))
        nameTextField.placeholder = "Имя"
        nameTextField.title = "Ваше имя"
        nameTextField.errorColor = UIColor.red
        nameTextField.addTarget(self, action: #selector(nameTextFieldDidChange(_:)), for: .editingChanged)
        informationView.addSubview(nameTextField)
    }
    
    private func makeSurnameTextField(){
        let surnameTextField = SkyFloatingLabelTextField(frame: CGRect(x: 5, y: 55, width: informationView.bounds.width - 10, height: 45))
        surnameTextField.placeholder = "Фамилия"
        surnameTextField.title = "Ваша фамилия"
        surnameTextField.errorColor = UIColor.red
        surnameTextField.addTarget(self, action: #selector(nameTextFieldDidChange(_:)), for: .editingChanged)
        informationView.addSubview(surnameTextField)
    }
    
    private func makePatronymicNameTextField(){
        let patronymicTextField = SkyFloatingLabelTextField(frame: CGRect(x: 5, y: 105, width: informationView.bounds.width - 10, height: 45))
        patronymicTextField.placeholder = "Отчество"
        patronymicTextField.title = "Ваше отчество"
        patronymicTextField.errorColor = UIColor.red
        patronymicTextField.addTarget(self, action: #selector(nameTextFieldDidChange(_:)), for: .editingChanged)
        informationView.addSubview(patronymicTextField)
    }
    
    private func makeAgeTextField(){
        let ageTextField = SkyFloatingLabelTextField(frame: CGRect(x: 5, y: 155, width: informationView.bounds.width - 10, height: 45))
        ageTextField.placeholder = "Возраст"
        ageTextField.title = "Ваш возраст"
        ageTextField.errorColor = UIColor.red
        ageTextField.addTarget(self, action: #selector(ageParentTextFieldDidChange(_:)), for: .editingChanged)
        informationView.addSubview(ageTextField)
    }
    
    @objc func nameTextFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
                if (!text.isValidName) {
                    floatingLabelTextField.errorMessage = "Неправильный ввод"
                }
                else {
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
    }
    
    @objc func ageParentTextFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
                if (!text.isValidParentAge) {
                    floatingLabelTextField.errorMessage = "Неправильный ввод"
                }
                else {
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
    }
    
    func fetchChildren(){
        do {
            let request = Child.fetchRequest() as NSFetchRequest<Child>
            self.items = try context.fetch(request)
            DispatchQueue.main.async {
                self.tableView.reloadData()
                if self.items.isEmpty {
                    self.tableView.isHidden = true
                } else {
                    self.tableView.isHidden = false
                }
                if self.items.count > 4 {
                    self.addChildButton.isHidden = true
                } else {
                    self.addChildButton.isHidden = false
                }
            }
        }
        catch {
            print("Error with updating data")
        }
    }
    
    @IBAction func tappedAddButton(_ sender: UIButton) {
        let addChildAlert = UIAlertController(title: "Добавить ребёнка", message: "Информация", preferredStyle: .alert)
        addChildAlert.addTextField(configurationHandler: {
            textField in
            textField.borderStyle = UITextField.BorderStyle.roundedRect
            textField.placeholder = "Имя"
        })
        addChildAlert.addTextField(configurationHandler: {
            textField in
            textField.borderStyle = UITextField.BorderStyle.roundedRect
            textField.placeholder = "Возраст"
        })
        let addChildButton = UIAlertAction(title: "Добавить", style: .default) { _ in
            let addChildNameTextField = addChildAlert.textFields![0]
            let addChildAgeTextField = addChildAlert.textFields![1]
            let newChild = Child(context: self.context)
            newChild.name = addChildNameTextField.text
            newChild.age = Int16(addChildAgeTextField.text ?? "0") ?? 0
            guard let name = newChild.name else {
                return
            }
            if !name.isValidName  {
                newChild.name = "???"
            }
            do {
                try self.context.save()
            } catch {
                print("Error with the saving data")
            }
            self.fetchChildren()
        }
        let cancelButton = UIAlertAction(title: "Отмена", style: .default, handler: nil)
        addChildAlert.addAction(addChildButton)
        addChildAlert.addAction(cancelButton)
        self.present(addChildAlert, animated: true)
    }
}

extension PrivateInfoController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChildCell", for: indexPath)
            as! ChildTableViewCell
        let child = self.items[indexPath.row]
        cell.nameLabelValue.text = child.name ?? "empty name"
            switch child.age {
            case 2,3,4:
                cell.ageLabelValue.text = String("\(child.age) года")
            case 1:
                cell.ageLabelValue.text = String("\(child.age) год")
            case 5,6,7,8,9,10,11,12,13,14,15,16,17:
                cell.ageLabelValue.text = String("\(child.age) лет")
            default:
                cell.ageLabelValue.text = String("0")
            }
        cell.deleteBlock = {
            self.context.delete(self.items[indexPath.row])
            do {
                try self.context.save()
            } catch {
                print("Error with the saving data in delete")
            }
            self.fetchChildren()
        }
        return cell
    }
}

extension String {

    var isValidName: Bool {
       let RegEx = "[А-Я]{1}[а-я]{1,25}"
       let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
       return Test.evaluate(with: self)
    }
    
    var isValidChildAge: Bool {
       let RegEx = "([1-9]{1})|([1]{1}[0-7]{1})"
       let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
       return Test.evaluate(with: self)
    }
    
    var isValidParentAge: Bool {
       let RegEx = "([1]{1}[8-9]{1})|([2-9]{1}[0-9]{1})"
       let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
       return Test.evaluate(with: self)
    }
}
