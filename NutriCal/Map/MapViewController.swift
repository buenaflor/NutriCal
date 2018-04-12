//
//  MapViewController.swift
//  NutriCal
//
//  Created by Giancarlo on 31.03.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

import SwiftSpinner
import AMPopTip

final class Annotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        
        super.init()
    }
    
    var region: MKCoordinateRegion {

        // Default
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        return MKCoordinateRegion(center: coordinate, span: span)
    }
}

class MapViewController: UIViewController {
    
    private var locationManager: CLLocationManager!
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "id")
        mapView.delegate = self
        mapView.showsUserLocation = true
        return mapView
    }()

    private let currentLocationButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "current-location").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(currentLocationButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.determineMyCurrentLocation()
//        self.fetchAnnotationData()
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.addAnnotations()
    }
    
    private func addAnnotations() {
        
        let firebaseManager = FirebaseManager()
        
        SwiftSpinner.show("Fetching Map Data")
        
        firebaseManager.fetchRestaurant { (restaurantIdentifiers) in
            restaurantIdentifiers.forEach({ (restaurantIdentifier) in
                
                let name = restaurantIdentifier.restaurant.name
                let street = restaurantIdentifier.restaurant.street
                let postalCode = restaurantIdentifier.restaurant.postalCode
                let city = restaurantIdentifier.restaurant.city
                let address = "\(street), \(postalCode) \(city)"

                let geoCoder = CLGeocoder()
                geoCoder.geocodeAddressString(address) { (placemarks, error) in
                    guard
                        let placemarks = placemarks,
                        let location = placemarks.first?.location
                        else {
                            print("not location found")
                            return
                    }

                    print("latitude: \(location.coordinate.latitude), longitude: \(location.coordinate.longitude)")
                    let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                    let annotation = Annotation(coordinate: coordinate, title: name, subtitle: "Burger & Drinks")
                    
                    self.mapView.addAnnotation(annotation)
                }
                
            })
            SwiftSpinner.hide()
        }
        
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        
        let distanceRightButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(distanceRightButtonItemTapped))
        self.navigationItem.rightBarButtonItem = distanceRightButtonItem
        
        self.configureConstraints()
    }
    
    private func fetchAnnotationData() {
//        let coordinate = CLLocationCoordinate2D(latitude: 37.7955, longitude: -122.3937)
//        let annotation = Annotation(coordinate: coordinate, title: "Ferry Building", subtitle: "San Francisco")
//        mapView.addAnnotation(annotation)
//        mapView.setRegion(annotation.region, animated: true)
    }
    
    private func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    private func configureConstraints() {
        self.view.add(subview: self.mapView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.bottomAnchor.constraint(equalTo: p.safeAreaLayoutGuide.bottomAnchor)
            ]}
        
        self.view.add(subview: self.currentLocationButton) { (v, p) in [
            v.bottomAnchor.constraint(equalTo: p.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            v.widthAnchor.constraint(equalToConstant: 40),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -30),
            v.heightAnchor.constraint(equalToConstant: 40)
            ]}
        
        self.view.bringSubview(toFront: self.currentLocationButton)
    }
    
    @objc private func currentLocationButtonTapped() {
        self.locationManager.startUpdatingLocation()
    }
    
    @objc private func distanceRightButtonItemTapped() {
        
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        
        let coordinate = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000)
        let currentLocationAnnotation = Annotation(coordinate: coordinate, title: "Current Location", subtitle: "Location")

        mapView.setRegion(region, animated: true)
        
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }

}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("Radius:", mapView.currentRadius())
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        let foodDetailViewController = FoodDetailViewController()
//        navigationController?.pushViewController(foodDetailViewController, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        else {
            guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "id", for: annotation) as? MKMarkerAnnotationView else { return MKAnnotationView() }
            
            annotationView.animatesWhenAdded = true
            annotationView.titleVisibility = .adaptive
            
            return annotationView
        }
    }
}

extension MKMapView {
    
    func topCenterCoordinate() -> CLLocationCoordinate2D {
        return self.convert(CGPoint(x: self.frame.size.width / 2.0, y: 0), toCoordinateFrom: self)
    }
    
    func currentRadius() -> Double {
        let centerLocation = CLLocation(latitude: self.centerCoordinate.latitude, longitude: self.centerCoordinate.longitude)
        let topCenterCoordinate = self.topCenterCoordinate()
        let topCenterLocation = CLLocation(latitude: topCenterCoordinate.latitude, longitude: topCenterCoordinate.longitude)
        return centerLocation.distance(from: topCenterLocation)
    }
    
}


