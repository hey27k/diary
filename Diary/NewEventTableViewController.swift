import UIKit

class NewEventTableViewController: UITableViewController {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var dateStartLabel: UILabel!
    @IBOutlet weak var dateStartPicker: UIDatePicker!
    @IBOutlet weak var dateEndLabel: UILabel!
    @IBOutlet weak var dateEndPicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    var dateStartPickerHidden = true
    var dateEndPickerHidden = true
    let dateStartLabelIndexPath = IndexPath(row: 0, section: 1)
    let dateStartPickerIndexPath = IndexPath(row: 1, section: 1)
    let dateEndLabelIndexPath = IndexPath(row: 2, section: 1)
    let dateEndPickerIndexPath = IndexPath(row: 3, section: 1)
    let descriptionView = IndexPath(row: 0, section: 2)
    
    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDateEndPicker()
        updateDateLabels(date: dateStartPicker.date)
        updateSaveButtonState()
    }
    
    func updateDateLabels(date: Date) {
        dateStartLabel.text = dateFormatter.string(from: dateStartPicker.date)
        dateEndLabel.text = dateFormatter.string(from: dateEndPicker.date)
    }
    
    func setDateEndPicker() {
        let calendar = Calendar.current
        let addOneHour = calendar.date(byAdding: .hour, value: 1, to: dateStartPicker.date)
        dateEndPicker.date = addOneHour!
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDateLabels(date: sender.date)
    }
    
    func updateSaveButtonState() {
        let shouldEnableSaveButton = titleField.text?.isEmpty == false
        saveButton.isEnabled = shouldEnableSaveButton
    }
    
    @IBAction func returnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func textEditingChange(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case dateStartPickerIndexPath where dateStartPickerHidden == true:
            return 0
        case dateEndPickerIndexPath where dateEndPickerHidden == true:
            return 0
        case descriptionView:
            return 200
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath {
        case dateStartLabelIndexPath:
            dateStartPickerHidden.toggle()
            tableView.beginUpdates()
            tableView.endUpdates()
        case dateEndLabelIndexPath:
            dateEndPickerHidden.toggle()
            tableView.beginUpdates()
            tableView.endUpdates()
        default:
            break
        }
        
        if dateEndPickerHidden == true {
            let cell = tableView.cellForRow(at: dateEndLabelIndexPath)
            cell?.layer.cornerRadius = 10
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else { return }
        
        let id = UUID()
        let name = titleField.text!
        let dateStart = dateStartPicker.date
        let dateEnd = dateEndPicker.date
        let description = descriptionTextView.text
        
        event = Event(id: id, dateStart: dateStart, dateEnd: dateEnd, name: name, description: description ?? "")
    }

}