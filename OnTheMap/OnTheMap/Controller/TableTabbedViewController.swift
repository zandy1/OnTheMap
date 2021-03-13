//
//  TableTabbedViewController.swift
//  OnTheMap
//
//  Created by Alexander Brown on 3/6/21.
//

import Foundation
import UIKit

class TableTabbedViewController: UITableViewController {
    
    override func viewDidLoad() {
      super.viewDidLoad()
      self.tableView.delegate = self
      self.tableView.dataSource = self
      self.navigationItem.title = "On The Map"
      self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: .done, target: self, action: #selector(logout))
      self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "icon_addpin"), style: .plain, target: self, action: #selector(addPin)), UIBarButtonItem(image: UIImage(named: "icon_refresh"), style: .plain, target: self, action: #selector(refresh))]
      refresh()
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
        self.performSegue(withIdentifier: "getLocation", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        let ipvc = segue.destination as! InformationPostingViewController
        ipvc.segueIdentifier = "unwindtotab"
    }
    
    func handleGetLocation(success: Bool, error: Error?) {
                //setGetLocation(false)
                if (success) {
                    self.tableView.reloadData()
                }
                else {
                    showGetLocationFailure(message: error?.localizedDescription ?? "")
                }
            }
    
        /*
        func setGetLocation(_ gettingLocation: Bool) {
                if gettingLocation {
                    activityIndicator.startAnimating()
                }
                else {
                    activityIndicator.stopAnimating()
                }
            }
        */
    
        func showGetLocationFailure(message: String) {
            let alertVC = UIAlertController(title: "Unable To Download Student Information", message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVC, animated:true)
        }
    
    @IBAction func unwindToTab(segue:UIStoryboardSegue) { }
    
    // MARK: - Table view data source

     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OnTheMapModel.studentInformation.count
     }

     
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableTabbedViewCell", for: indexPath)
        let studentInfo = OnTheMapModel.studentInformation[indexPath.row]
        cell.textLabel?.text = studentInfo.firstName + " " + studentInfo.lastName
        cell.detailTextLabel?.text = studentInfo.mediaURL
        cell.imageView?.image = UIImage(named: "icon_pin")
        return cell
     }
     
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentInfo = OnTheMapModel.studentInformation[indexPath.row]
        let app = UIApplication.shared
        if studentInfo.mediaURL != "" {
            app.openURL(URL(string: studentInfo.mediaURL)!)
        }
      }


}
