//
//  MapWidgetView.swift
//  Campus-iOS
//
//  Created by Augst Wittgenstein on 30.03.22.
//

import SwiftUI
import MapKit
import CoreLocation
import Alamofire

struct MapWidgetView: UIViewRepresentable {
    @State var zoomOnUser: Bool
    @State var panelPosition: String
    @State var canteens: [Cafeteria]
    @State var selectedCanteenName: String
    @State var selectedAnnotationIndex: Int
        
    let endpoint = EatAPI.canteens
    let sessionManager = Session.defaultSession
    var locationManager = CLLocationManager()
    public let mapView = MKMapView()
    
    let screenHeight = UIScreen.main.bounds.height
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        DispatchQueue.main.async {
            fetchCanteens()
        }
        
        mapView.showsUserLocation = true

        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        focusOnUser(mapView: view)
        focusOnCanteen(mapView: view)
        
        let newCenter = screenHeight/3
        
        if panelPosition == "mid" || panelPosition == "pushMid"{
            view.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: newCenter, right: 0)
        } else if panelPosition == "down" || panelPosition == "pushDown"{
            view.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func focusOnUser(mapView: MKMapView) {
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()

            if let location = self.locationManager.location {
                if zoomOnUser {
                    for i in mapView.selectedAnnotations {
                        mapView.deselectAnnotation(i, animated: true)
                    }
                    selectedCanteenName = ""
                    DispatchQueue.main.async {
                        let locValue: CLLocationCoordinate2D = location.coordinate
                        
                        let coordinate = CLLocationCoordinate2D(
                            latitude: locValue.latitude, longitude: locValue.longitude)
                        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                        let region = MKCoordinateRegion(center: coordinate, span: span)
                        
                        withAnimation {
                            mapView.setRegion(region, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    func focusOnCanteen(mapView: MKMapView) {
        if selectedCanteenName != "" {
            for i in mapView.annotations {
                if i.title == selectedCanteenName {
                    let locValue: CLLocationCoordinate2D = i.coordinate
                    
                    let coordinate = CLLocationCoordinate2D(
                        latitude: locValue.latitude, longitude: locValue.longitude)
                    let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    let region = MKCoordinateRegion(center: coordinate, span: span)
                    
                    mapView.setRegion(region, animated: true)
                    for i in mapView.annotations {
                        if i.title == selectedCanteenName {
                            mapView.selectAnnotation(i, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    func makeCoordinator() -> MapWidgetViewCoordinator {
        MapWidgetViewCoordinator(self)
    }
    
    var allCafs: [Cafeteria] = []
    
    func fetchCanteens() {
            sessionManager.request(endpoint).responseDecodable(of: [Cafeteria].self, decoder: JSONDecoder()) { [self] response in
                var cafeterias: [Cafeteria] = response.value ?? []
                if let currentLocation = self.locationManager.location {
                    cafeterias.sortByDistance(to: currentLocation)
                }
                
                let annotations = cafeterias.map { Annotation(title: $0.name, coordinate: $0.coordinate) }
                
                mapView.addAnnotations(annotations)
                
                canteens = cafeterias
                
                for (index, cafeteria) in canteens.enumerated() {
                    if let queue = cafeteria.queueStatusApi  {
                        sessionManager.request(queue, method: .get).responseDecodable(of: Queue.self, decoder: JSONDecoder()){ [self] response in
                            canteens[index].queue = response.value
                            //canteens = cafeterias
                        }
                    }
                }

                /*var snapshot = NSDiffableDataSourceSnapshot<Section, Cafeteria>()
                snapshot.appendSections([.main])
                snapshot.appendItems(cafeterias, toSection: .main)
                self?.dataSource?.apply(snapshot, animatingDifferences: true)*/
            }
        }
    
    class MapWidgetViewCoordinator: NSObject, MKMapViewDelegate {
        var control: MapWidgetView
            
        init(_ control: MapWidgetView) {
            self.control = control
        }
        
        func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
            control.zoomOnUser = false
            //control.selectedCanteenName = ""
            control.selectedAnnotationIndex = -1
        }
                
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let coordinate = view.annotation?.coordinate {
                let locValue: CLLocationCoordinate2D = coordinate
                
                let coordinate = CLLocationCoordinate2D(
                    latitude: locValue.latitude, longitude: locValue.longitude)
                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                
                mapView.setRegion(region, animated: true)
            }
            
            if let title = view.annotation?.title {
                if !control.canteens.isEmpty {
                    for i in 0...(control.canteens.count - 1) {
                        if title! == control.canteens[i].title {
                            control.selectedAnnotationIndex = i
                            control.panelPosition = "pushMid"
                        }
                    }
                }
            }
        }
    }
}

