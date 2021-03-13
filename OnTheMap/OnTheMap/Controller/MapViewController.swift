//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Alexander Brown on 3/5/21.
//

import Foundation
import UIKit
import MapKit

/**
* This view controller demonstrates the objects involved in displaying pins on a map.
*
* The map is a MKMapView.
* The pins are represented by MKPointAnnotation instances.
*
* The view controller conforms to the MKMapViewDelegate so that it can receive a method
* invocation when a pin annotation is tapped. It accomplishes this using two delegate
* methods: one to put a small "info" button on the right side of each pin, and one to
* respond when the "info" button is tapped.
*/

class MapViewController: UIViewController, MKMapViewDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    // The map. See the setup in the Storyboard file. Note particularly that the view controller
    // is set up as the map view's delegate.
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        self.navigationItem.title = "On The Map"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: .done, target: self, action: #selector(logout))
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "icon_addpin"), style: .plain, target: self, action: #selector(addPin)), UIBarButtonItem(image: UIImage(named: "icon_refresh"), style: .plain, target: self, action: #selector(refresh))]
        self.refresh()
    }
        
    @objc func refresh() {
            OnTheMapClient.getStudentLocation(completion: self.handleGetLocation(success:error:))
        }
    
    @objc func logout() {
        OnTheMapClient.logout {
            DispatchQueue.main.async {
              self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func addPin() {
        self.performSegue(withIdentifier: "getLocation2", sender: nil)
    }
    
    func handleGetLocation(success: Bool, error: Error?) {
                //setGetLocation(false)
                if (success) {
                    self.clear_pins()
                    self.drawMap()
                }
                else {
                    showGetLocationFailure(message: error?.localizedDescription ?? "")
                }
            }
    
        func showGetLocationFailure(message: String) {
            let alertVC = UIAlertController(title: "Unable To Download Student Information", message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVC, animated:true)
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        let ipvc = segue.destination as! InformationPostingViewController
        ipvc.segueIdentifier = "unwindtomap"
    }
    
    @IBAction func unwindToMap(segue:UIStoryboardSegue) { }
    
     func drawMap() {
        
        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [MKPointAnnotation]()
        
        for i in 0..<OnTheMapModel.studentInformation.count

        {
                    let lat = CLLocationDegrees(OnTheMapModel.studentInformation[i].latitude as! Double)
                    let long = CLLocationDegrees(OnTheMapModel.studentInformation[i].longitude as! Double)
                    
                    // The lat and long are used to create a CLLocationCoordinates2D instance.
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    let first = OnTheMapModel.studentInformation[i].firstName as! String
                    let last = OnTheMapModel.studentInformation[i].lastName as! String
                    let mediaURL = OnTheMapModel.studentInformation[i].mediaURL as! String
        
                    // Here we create the annotation and set its coordiate, title, and subtitle properties
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    
                    // Finally we place the annotation in an array of annotations.
                    annotations.append(annotation)
                }
                
                // When the array is complete, we add the annotations to the map.
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
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
    
    // Remove Old Pins
    func clear_pins() {
      for _annotation in self.mapView.annotations {
         self.mapView.removeAnnotation(_annotation)
      }
    }

}

