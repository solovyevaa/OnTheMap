//
//  MapViewController.swift
//  On The Map
//
//  Created by Anna Solovyeva on 12/08/2020.
//  Copyright © 2020 Anna Solovyeva. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    // MAP VIEW
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        OnTheMapAPI.getStudentLocation { (results, error) in
            StudentModel.studentsList = results
        
        var annotations = [MKPointAnnotation]()
        
        for location in results {
            let longitude = CLLocationDegrees(location.longitude)
            let latitude = CLLocationDegrees(location.latitude)
            let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let mediaURL = location.mediaURL
            let firstName = location.firstName
            let lastName = location.lastName
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = "\(firstName) \(lastName)"
            annotation.subtitle = mediaURL
            annotations.append(annotation)
            
        }
        DispatchQueue.main.async {
            self.mapView.addAnnotations(annotations)
        }
        }
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
    
    
    // ACTIONS WITH BUTTONS
    @IBAction func addButtonPressed(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier:"AddLocationViewController")
        present(controller!, animated: true, completion: nil)
    }
    
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        viewDidLoad()
        print("The view is refreshed")
    }
    
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
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
