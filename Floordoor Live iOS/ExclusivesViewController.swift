//
//  ExclusivesViewController.swift
//  Floordoor Live iOS
//
//  Created by Allan Pichardo on 12/13/16.
//  Copyright © 2016 Floordoor Records. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ExclusivesViewController: UIViewController, CLLocationManagerDelegate {
    

    
    @IBOutlet weak var venueNameLabel: UILabel!
    @IBOutlet weak var venueImage: UIImageView!
    @IBOutlet weak var venueMap: MKMapView!
    @IBOutlet weak var venueLayout: UIView!
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLayout: UIView!
    
    var locationManager: CLLocationManager = CLLocationManager()
    var location: CLLocation?
    var venue: VenueResponse?
    private let rationaleNotAtShow = "It seems that you're not currently at a Floordoor show. If you think this is an error, make sure the location is enabled on your phone and try again."
    private let rationaleNoPermission = "Floordoor Live doesn't have your permission to access your location. You can change this in your phone's settings."

    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLayout.isHidden = true
        venueLayout.isHidden = true
        activityIndicator.isHidden = false
        
        if isLocationPermissionAvailable(){
            
            locationManager.delegate = self
            
            if isLocationPermissionRequired(){
                requestPermission()
            } else {
                if isLocationAvailable() {
                    getLocationFix()
                }else{
                    notifyLocationUnavailable(errorText: rationaleNotAtShow)
                }
            }
        } else {
            notifyLocationUnavailable(errorText: rationaleNoPermission)
        }

    }
    
    @IBAction func retryClicked(_ sender: Any) {
        viewDidLoad()
    }
    
    private func isLocationPermissionRequired() -> Bool {
        return CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined
    }
    
    private func isLocationPermissionAvailable() -> Bool{
        return CLLocationManager.authorizationStatus() != CLAuthorizationStatus.restricted &&
                CLLocationManager.authorizationStatus() != CLAuthorizationStatus.denied
    }
    
    private func requestPermission(){
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func isLocationAvailable() -> Bool{
        return CLLocationManager.locationServicesEnabled()
    }
    
    private func getLocationFix(){
        locationManager.requestLocation()
    }
    
    private func initVenueSearch(){
        //todo get venue info from server
        Api.getVenue(Coordinates(location: self.location!)) { (response) in
            if response.isSuccess {
                self.venue = response;
                self.displayVenueInfo()
            }else {
                self.notifyLocationUnavailable(errorText: self.rationaleNotAtShow)
            }
        }
    }
    
    private func notifyLocationUnavailable(errorText: String){
        toggleActivityIndicator(isShowing: false)
        errorLayout.isHidden = false
        errorLabel.text = errorText
    }

    private func displayVenueInfo() {
        guard let imageUrl = venue?.imageUrl,
                let name = venue?.name,
                let coords = location?.coordinate else {
            notifyLocationUnavailable(errorText: rationaleNotAtShow)
            return
        }

        let region = MKCoordinateRegionMakeWithDistance(coords, 500, 500)
        let marker = MKPointAnnotation()
        marker.coordinate = coords
        marker.title = name
        venueMap.setRegion(region, animated: false)
        venueMap.addAnnotation(marker)
        
        DispatchQueue.main.async {
            self.venueImage.image = Api.loadImageSynchronouslyFromURLString(imageUrl)
        }

        venueNameLabel.text = name

        venueLayout.isHidden = false
        toggleActivityIndicator(isShowing: false)
    }

    private func toggleActivityIndicator(isShowing: Bool){
        activityIndicator.isHidden = !isShowing
    }
    
    // MARK: - Location
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case CLAuthorizationStatus.authorizedWhenInUse:
            getLocationFix()
            break
        default:
            notifyLocationUnavailable(errorText: rationaleNoPermission)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let message = "The following error occurred while trying to get your location: " + error.localizedDescription
        notifyLocationUnavailable(errorText: message)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.location = locations[0]
        initVenueSearch()
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let downloadsController = segue.destination as! DownloadsTableViewController
        downloadsController.venue = venue!
    }

}
