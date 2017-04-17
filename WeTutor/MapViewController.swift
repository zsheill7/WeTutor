

import UIKit
import MapKit
import SCLAlertView
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    var locationToShow: CLLocationCoordinate2D!

    @IBOutlet weak var mapView: MKMapView!
    
   // @IBOutlet weak var directionsTableView: DirectionsTableView!
   // @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet var segmentedControl:UISegmentedControl!
    
    var currentRoute:MKRoute?
    let locationManager = CLLocationManager()
    var currentPlacemark:CLPlacemark?
    var currentTransportType = MKDirectionsTransportType.automobile

    var activityIndicator: UIActivityIndicatorView?
    var locationArray: [(textField: UITextField?, mapItem: MKMapItem?)]!
    

    
    func displayAlert(_ title: String, message: String) {
        SCLAlertView().showInfo(title, subTitle: message)
        
    }
//test commit
    var test = 0
    
    
    
    @IBAction func openInMaps(_ sender: Any) {
        
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: locationToShow, addressDictionary:nil))
        mapItem.name = self.navigationController?.title
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    

  override func viewDidLoad() {
    super.viewDidLoad()

    //directionsTableView.contentInset = UIEdgeInsetsMake(-36, 0, -20, 0)
   // addActivityIndicator()
  // calculateSegmentDirections(0, time: 0, routes: [])
    
    segmentedControl.isHidden = true
    segmentedControl.addTarget(self, action: #selector(showDirection), for: .valueChanged)
    
    // Request for a user's authorization for location services
    mapView.delegate = self
    locationManager.requestAlwaysAuthorization()
    
    locationManager.requestWhenInUseAuthorization()
    let status = CLLocationManager.authorizationStatus()
    locationManager.delegate = self
    locationManager.startUpdatingLocation()
    if status == CLAuthorizationStatus.authorizedWhenInUse {
        print("authorized")
        mapView.showsUserLocation = true
    }
    
    if locationToShow != nil {

        mapView.setCenter(locationToShow, animated: true)
    } else {
        //self.displayAlert(title: "", message: "This address may not be ")
        print("location to show = nil")
    }

    let zoomRegion = MKCoordinateRegionMakeWithDistance(locationToShow, 15000, 15000)
    mapView.setRegion(zoomRegion, animated: true)

    let annotation = MKPointAnnotation()
    annotation.coordinate = locationToShow
    mapView.addAnnotation(annotation)
  }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        // Reuse the annotation if possible
        var annotationView:MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        }
        
        let leftIconView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 53, height: 53))
       // leftIconView.image = UIImage(named: restaurant.image)
        annotationView?.leftCalloutAccessoryView = leftIconView
        
        // Pin color customization
        if #available(iOS 9.0, *) {
            annotationView?.pinTintColor = UIColor.orange
        }
        
        annotationView?.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)
        
        return annotationView
    }
    
    func addActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: UIScreen.main.bounds)
        activityIndicator?.activityIndicatorViewStyle = .whiteLarge
        activityIndicator?.backgroundColor = view.backgroundColor
        activityIndicator?.startAnimating()
        view.addSubview(activityIndicator!)
    }
    
    @IBAction func showDirection(_ sender: Any) {
    
        print("inside showDirection")
        segmentedControl.isHidden = false
        
        switch segmentedControl.selectedSegmentIndex {
            case 0: currentTransportType = MKDirectionsTransportType.automobile
            case 1: currentTransportType = MKDirectionsTransportType.walking
            default: break
        }
        
        
        
        print("before placemark")
        guard let currentPlacemark = currentPlacemark else {
            return
        }
        print("after placemark")
        
        let directionRequest = MKDirectionsRequest()
        
        // Set the source and destination of the route
        directionRequest.source = MKMapItem.forCurrentLocation()
        let destinationPlacemark = MKPlacemark(placemark: currentPlacemark)
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.transportType = currentTransportType
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate { (routeResponse, routeError) -> Void in
            print("directions.calculate { ")
            guard let routeResponse = routeResponse else {
                print("routeResponse else")
                if let routeError = routeError {
                    print("Error: \(routeError)")
                }
                return
            }
            print("after let routeResponse")
            let route = routeResponse.routes[0]
            self.currentRoute = route
            self.mapView.removeOverlays(self.mapView.overlays)
            self.mapView.add(route.polyline, level: MKOverlayLevel.aboveRoads)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
            print("in map")
        }
        
        directionRequest.transportType = MKDirectionsTransportType.automobile
        directionRequest.transportType = currentTransportType
    }
    
    func showRoute(_ routes: [MKRoute], time: TimeInterval) {
        var directionsArray = [(startingAddress: String, endingAddress: String, route: MKRoute)]()
        for index in 0..<routes.count {
            plotPolyline(routes[index])
           // directionsArray += [(startingAddress: locationArray[index].textField?.text!, endingAddress: locationArray[index+1].textField?.text!, route: routes[index])]
        }
        //displayDirections(directionsArray)
        //printTimeToLabel(time)
    }
    
    func plotPolyline(_ route: MKRoute) {
        
        mapView.add(route.polyline)
        
        if mapView.overlays.count == 1 {
            mapView.setVisibleMapRect(route.polyline.boundingMapRect,
                                      edgePadding: UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0),
                                      animated: false)
        } else {
            let polylineBoundingRect =  MKMapRectUnion(mapView.visibleMapRect,
                                                       route.polyline.boundingMapRect)
            mapView.setVisibleMapRect(polylineBoundingRect,
                                      edgePadding: UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0),
                                      animated: false)
        }
    }
    /*func displayDirections(_ directionsArray: [(startingAddress: String, endingAddress: String, route: MKRoute)]) {
        directionsTableView.directionsArray = directionsArray
        directionsTableView.delegate = directionsTableView
        directionsTableView.dataSource = directionsTableView
        directionsTableView.reloadData()
    }
    */
    func calculateSegmentDirections(_ index: Int,
                                    time: TimeInterval, routes: [MKRoute]) {
        
        let request: MKDirectionsRequest = MKDirectionsRequest()
        request.source = locationArray[index].mapItem
        request.destination = locationArray[index+1].mapItem
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate (completionHandler: {
            (response: MKDirectionsResponse?, error: NSError?) in
            if let routeResponse = response?.routes {
                let quickestRouteForSegment: MKRoute =
                    routeResponse.sorted(by: {$0.expectedTravelTime <
                        $1.expectedTravelTime})[0]
                
                var timeVar = time
                var routesVar = routes
                
                routesVar.append(quickestRouteForSegment)
                timeVar += quickestRouteForSegment.expectedTravelTime
                
                if index+2 < self.locationArray.count {
                    self.calculateSegmentDirections(index+1, time: timeVar, routes: routesVar)
                } else {
                    self.showRoute(routesVar, time: timeVar)
                    self.hideActivityIndicator()
                }
            } else if let _ = error {
                let alert = UIAlertController(title: nil,
                                              message: "Directions not available.", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK",
                                             style: .cancel) { (alert) -> Void in
                                                self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(okButton)
                self.present(alert, animated: true,
                             completion: nil)
            }
            } as! MKDirectionsHandler)
    }
    
    func hideActivityIndicator() {
        if activityIndicator != nil {
            activityIndicator?.removeFromSuperview()
            activityIndicator = nil
        }
    }

   /* func printTimeToLabel(_ time: TimeInterval) {
        let timeString = time.formatted()
        totalTimeLabel.text = "Total Time: \(timeString)"
    }
    */
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = (currentTransportType == .automobile) ? UIColor.blue : UIColor.orange
        renderer.lineWidth = 3.0
        
        return renderer
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        let center = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        var geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(center) { (placemarks, error) in
            // Process Response
            //self.processResponse(withPlacemarks: placemarks, error: error)
            self.currentPlacemark = placemarks?[0]
        }
    }
    
   
    
    

  @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
}
