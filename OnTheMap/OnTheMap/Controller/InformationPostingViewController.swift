//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Alexander Brown on 3/8/21.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class InformationPostingViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var myNavigationItem: UINavigationItem!
    
    var segueIdentifier: String = ""
    
    override func viewDidLoad() {
      super.viewDidLoad()
      self.myNavigationItem.title = "Add Location"
      self.myNavigationItem.leftBarButtonItem = UIBarButtonItem(title: "CANCEL", style: .done, target: self, action: #selector(cancel))
        activityIndicator.stopAnimating()
    }

    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           locationTextField.text = ""
           linkTextField.text = ""
           navigationController?.setNavigationBarHidden(false, animated: animated)
       }

        @objc func cancel() {
            self.dismiss(animated: true, completion: nil)
        }
    
    @IBAction func findLocationTapped(_ sender: UIButton) {
        if (self.linkTextField.text != "") {
            setGeocoding(true)
            self.findLocation()
        }
        else {
            self.showFindLocationFailure(message: "Link is Empty")
        }
    }
    
    func findLocation() {
        CLGeocoder().geocodeAddressString((self.locationTextField.text ?? ""), completionHandler: handleFindLocation(placemarks:error:))
    }
    
    func handleFindLocation(placemarks: [CLPlacemark]?, error: Error?) {
        setGeocoding(false)
        if (placemarks != nil) {
            print("Geocoding Successful")
            appDelegate.placemark = placemarks?[0]
            appDelegate.mapString = self.locationTextField.text
            appDelegate.mediaURL = self.linkTextField.text
            self.performSegue(withIdentifier: "tabaddlocation", sender: nil)
        }
        else {
            showFindLocationFailure(message: "Geocoding Failed")
        }
    }
    
    func setGeocoding(_ geocoding: Bool) {
            if geocoding {
                activityIndicator.startAnimating()
            }
            else {
                activityIndicator.stopAnimating()
            }
            //locationTextField.isEnabled = !geocoding
            //linkTextField.isEnabled = !geocoding
            //findLocationButton.isEnabled = !geocoding
        }
    
    func showFindLocationFailure(message: String) {
        let alertVC = UIAlertController(title: "Find Location Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        let alvc = segue.destination as! AddLocationViewController
        alvc.segueIdentifier = segueIdentifier
    }
    
}
