//
//  AddMapLocationViewController.swift
//  On The Map
//
//  Created by Anna Solovyeva on 17/08/2020.
//  Copyright © 2020 Anna Solovyeva. All rights reserved.
//

import UIKit
import MapKit

class AddMapLocationViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        var annotations = [MKPointAnnotation]()
        
        let longitude = CLLocationDegrees(StudentModel.longitude)
        let latitude = CLLocationDegrees(StudentModel.latitude)
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let mediaURL = StudentModel.mediaUrl
        let firstName = "Anna"
        let lastName = "Solovyeva"
            
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        annotation.title = "\(firstName) \(lastName)"
        annotation.subtitle = mediaURL
        annotations.append(annotation)
        DispatchQueue.main.async {
            self.mapView.addAnnotations(annotations)
            self.mapView.setCenter(coordinates, animated: true)
        }
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    
    @IBAction func backToAddLocationButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finishButtonTapped(_ sender: Any) {
        OnTheMapAPI.postStudentLocation(location: StudentModel.location, mediaUrl: StudentModel.mediaUrl, latitude: StudentModel.latitude, longitude: StudentModel.longitude, completion: handleStudentLocationResponse(success:error:))
        OnTheMapAPI.putStudentLocation(location: StudentModel.location, mediaUrl: StudentModel.mediaUrl, latitude: StudentModel.latitude, longitude: StudentModel.longitude, completion: handleStudentLocationResponse(success:error:))
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func handleStudentLocationResponse(success: Bool, error: Error?) {
        if success {
            print("Success")
        } else {
            let alert = UIAlertController(title: "Error", message: "Student location is failed", preferredStyle: UIAlertController.Style.alert)
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
