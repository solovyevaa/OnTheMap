//
//  TableViewController.swift
//  On The Map
//
//  Created by Anna Solovyeva on 12/08/2020.
//  Copyright © 2020 Anna Solovyeva. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        OnTheMapAPI.getStudentLocation { (results, error) in
            StudentModel.studentsList = results
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    
    // TABLE VIEWS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentModel.studentsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        let student = StudentModel.studentsList[indexPath.row]
        cell.textLabel?.text = "\(student.firstName) \(student.lastName)"
        cell.detailTextLabel?.text = student.mediaURL
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = StudentModel.studentsList[indexPath.row]
        UIApplication.shared.open(URL(string: cell.mediaURL)!, options: [:], completionHandler: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // ADD BUTTON PRESSED
    @IBAction func addButtonPressed(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier:"AddLocationViewController")
        present(controller!, animated: true, completion: nil)
    }
    
    
    @IBAction func reloadButtonPressed(_ sender: Any) {
        tableView.reloadData()
        print("Table View is reloaded")
    }
    
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        OnTheMapAPI.deleteSessionId(completion: handleStudentLocationResponse(success:error:))
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func handleStudentLocationResponse(success: Bool, error: Error?) {
        if success {
            print("Session is deleted")
        } else {
            let alert = UIAlertController(title: "Error", message: "Deleting of session is failed", preferredStyle: UIAlertController.Style.alert)
            let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                    {
                        (UIAlertAction) -> Void in
                    }
                    alert.addAction(alertAction)
                    present(alert, animated: true)
                    {
                        () -> Void in
                    }
        }
    }
    
}
