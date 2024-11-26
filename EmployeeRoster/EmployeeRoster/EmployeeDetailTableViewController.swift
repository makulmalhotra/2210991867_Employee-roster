
import UIKit

protocol EmployeeDetailTableViewControllerDelegate: AnyObject {
    func employeeDetailTableViewController(_ controller: EmployeeDetailTableViewController, didSave employee: Employee)
}

class EmployeeDetailTableViewController: UITableViewController, UITextFieldDelegate,EmployeeTypeDelegate {
    func didSelect(employeeType: EmployeeType) {
        self.employeeType = employeeType
        employeeTypeLabel.text = employeeType.description()
    }
    

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var dobLabel: UILabel!
    @IBOutlet var employeeTypeLabel: UILabel!
    @IBOutlet var saveBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    let nameRow = 0
    let dateOfBirthRow = 1
    let dateOfBirthpickerRow = 2
    weak var delegate: EmployeeDetailTableViewControllerDelegate?
    var employee: Employee?
    var isEditingBirthday : Bool = false{
        didSet{
            tableView.beginUpdates()
            tableView.endUpdates()
            print("did set")
        }
    }
    var employeeType: EmployeeType?
    
    
    @IBAction func dobChanged(_ sender: Any) {
        print(datePicker.date)
        dobLabel.text = formatDate(date: datePicker.date)
    }
    func formatDate(date: Date)-> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isEditingBirthday{
            if indexPath.row == dateOfBirthpickerRow{
                return 186
            }else{
                return 0}}else{
            return 44
        }
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == dateOfBirthRow{
            isEditingBirthday = true
            updateBirthdayPicker()
            tableView.reloadData()
        }else{
            isEditingBirthday = false
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
        updateSaveButtonState()
        updateBirthdayPicker()
    }
    func updateBirthdayPicker(){
        if isEditingBirthday{
            datePicker.isHidden = false
        }else{
            datePicker.isHidden = true
        }
    }
    func updateView() {
        if let employee = employee {
            navigationItem.title = employee.name
            nameTextField.text = employee.name
            
            dobLabel.text = employee.dateOfBirth.formatted(date: .abbreviated, time: .omitted)
            dobLabel.textColor = .label
            employeeTypeLabel.text = employee.employeeType.description()
            employeeTypeLabel.textColor = .label
        } else {
            navigationItem.title = "New Employee"
        }
    }
    
    private func updateSaveButtonState() {
        let shouldEnableSaveButton = nameTextField.text?.isEmpty == false
        saveBarButtonItem.isEnabled = shouldEnableSaveButton
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text else {
            return
        }
        
        let employee = Employee(name: name, dateOfBirth: datePicker.date, employeeType: employeeType ?? .exempt)
        delegate?.employeeDetailTableViewController(self, didSave: employee)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        employee = nil
    }

    @IBAction func nameTextFieldDidChange(_ sender: UITextField) {
        updateSaveButtonState()
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let employeeTypeTableViewController =
//                segue.destination as? EmployeeTypeTableViewController else{ return}; func EmployeeTypeTableViewController;.employeeType =
//                                                                            employee?.employeeType
//        employeeTypeTableViewController.delegate = self
//    }

}
