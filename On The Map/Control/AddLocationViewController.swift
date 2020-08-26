//
//  AddLocationViewController.swift
//  On The Map
//
//  Created by Anna Solovyeva on 13/08/2020.
//  Copyright © 2020 Anna Solovyeva. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var adressTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    
    
    @IBAction func findLocation(_ sender: Any) {
        getCoordinateFrom(address: adressTextField.text!) { coordinate, error in
            guard let coordinate = coordinate, error == nil else { return }
            DispatchQueue.main.async {
                StudentModel.latitude = coordinate.latitude
                StudentModel.longitude = coordinate.longitude
                print(coordinate)
            }
        }
        DispatchQueue.main.async {
            StudentModel.location = self.adressTextField.text!
            StudentModel.mediaUrl = self.linkTextField.text!
            print(StudentModel.location)
        }
        
        let controller = storyboard?.instantiateViewController(withIdentifier:"AddMapLocationViewController")
        present(controller!, animated: true, completion: nil)
    }
    
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}


func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
    CLGeocoder().geocodeAddressString(address) { placemarks, error in
        completion(placemarks?.first?.location?.coordinate, error)
    }
}
