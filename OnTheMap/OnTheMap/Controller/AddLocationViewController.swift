//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Alexander Brown on 3/10/21.
//

import Foundation
import UIKit
import MapKit

class AddLocationViewController: UIViewController, MKMapViewDelegate {
            
  let appDelegate = UIApplication.shared.delegate as! AppDelegate

   @IBOutlet weak var mapView: MKMapView!
   @IBOutlet weak var myNavigationItem: UINavigationItem!
    
   var newUser: Bool = true
   var firstName: String = ""
   var lastName: String = ""
   var segueIdentifier: String = ""
            
   override func viewDidLoad() {
     super.viewDidLoad()
     mapView.delegate = self
    self.myNavigationItem.title = "Add Location"
    self.myNavigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Add Location", style: .done, target: self, action: #selector(cancel))
    self.drawMap()
    self.getPublicUserInformation()
    }
            
    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finishTapped(_ sender: UIButton) {
        self.createStudentLocation()
    }
            
    func createStudentLocation() {
        OnTheMapClient.createStudentLocation(firstName: firstName, lastName: lastName, mapString: appDelegate.mapString ?? "", mediaURL: appDelegate.mediaURL ?? "", latitude: (appDelegate.placemark?.location!.coordinate.latitude)!, longitude: (appDelegate.placemark?.location!.coordinate.longitude)!, completion: self.handleCreateStudentLocation(success:error:))
    }
    
    func updateStudentLocation() {
        OnTheMapClient.updateStudentLocation(firstName: firstName, lastName: lastName, mapString: appDelegate.mapString ?? "", mediaURL: appDelegate.mediaURL ?? "", latitude: (appDelegate.placemark?.location!.coordinate.latitude)!, longitude: (appDelegate.placemark?.location!.coordinate.longitude)!, completion: self.handleUpdateStudentLocation(success:error:))
    }
    
    func getPublicUserInformation() {
        OnTheMapClient.getPublicUserInformation(completion: self.handleGetPublicUserInformation(response:error:))
    }
    
    func handleCreateStudentLocation(success: Bool, error: Error?) {
      if (success) {
        print("FINISHED CREATE")
        performSegue(withIdentifier: segueIdentifier, sender: self)
        self.dismiss(animated: true, completion: nil)
      }
      else {
        showFailure(failureType: "Unable To Create Student Location", message: error?.localizedDescription ?? "")
      }
    }
    
    func handleUpdateStudentLocation(success: Bool, error: Error?) {
      if (success) {
        print("FINISHED UPDATE")
        performSegue(withIdentifier: segueIdentifier, sender: self)
      }
      else {
         showFailure(failureType: "Unable To Update Student Location", message: error?.localizedDescription ?? "")
      }
    }
    
    func handleGetPublicUserInformation(response: User?, error: Error?) {
      if (response != nil) {
        firstName = response!.firstName
        lastName = response!.lastName
      }
      else {
         showFailure(failureType: "Unable To Get Public Information", message: error?.localizedDescription ?? "")
      }
    }

    func showFailure(failureType: String, message: String) {
        let alertVC = UIAlertController(title: failureType, message: message, preferredStyle: .alert)
         alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
         show(alertVC, sender: nil)
    }
  
    func drawMap() {
                
      // We will create an MKPointAnnotation for each dictionary in "locations". The
      // point annotations will be stored in this array, and then provided to the map view.
      var annotations = [MKPointAnnotation]()
                
      // Here we create the annotation and set its coordiate, title, and subtitle properties
      let annotation = MKPointAnnotation()
      annotation.coordinate = (appDelegate.placemark?.location!.coordinate)!
      annotation.title = appDelegate.mapString
                            
       // Finally we place the annotation in an array of annotations.
       annotations.append(annotation)
                        
       // We add the annotations to the map.
       self.mapView.addAnnotations(annotations)
       }
            
       // MARK: - MKMapViewDelegate

       // Here we create a view with a "right callout accessory view". You might choose to look into other
       // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
       // method in TableViewDataSource.
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

            // This delegate method is implemented to respond to taps. It opens the system browser
            // to the URL specified in the annotationViews subtitle property.
            // This delegate method is implemented to respond to taps. It opens the system browser
            // to the URL specified in the annotationViews subtitle property.
            func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
                //if control == view.rightCalloutAccessoryView {
                    //let app = UIApplication.shared
                    //if let toOpen = view.annotation?.subtitle! {
                        //app.openURL(URL(string: toOpen)!)
                    //}
                //}
            }

}
