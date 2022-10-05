//
//  ViewController.swift
//  TheWeather
//
//  Created by Carlos González Martín on 4/10/22.
//

import UIKit
import MapKit

enum Positions: String, CaseIterable {
    case North = "N"
    case South = "S"
    case East = "E"
    case West = "W"
}

class MyPointAnnotation : MKPointAnnotation {
    var place: Place?
}

class ViewController: UIViewController, UITextFieldDelegate, UIAlertViewDelegate {
    
    
    @IBOutlet weak var searchTextView: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var watingView: UIView!
    @IBOutlet weak var containerRecordsView: UIView!
    @IBOutlet weak var tempValueLabel: UILabel!
    @IBOutlet weak var tempTownLabel: UILabel!
    @IBOutlet weak var humidityValueLabel: UILabel!
    @IBOutlet weak var humidityTownLabel: UILabel!
    @IBOutlet weak var windValueLabel: UILabel!
    @IBOutlet weak var windTownLabel: UILabel!
    @IBOutlet weak var rainValueLabel: UILabel!
    @IBOutlet weak var rainTownLabel: UILabel!
    
    
    private var weatherInfo: TheWeatherInfo = TheWeatherInfo()
    private let initialLatitudinalMetres: Double = 700000
    private let initialLongitudinalMetres: Double = 700000
    private var annotations: [MKPointAnnotation] = []
    private var selectPinAvailable: Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Search
        searchTextView.delegate = self
        searchTextView.returnKeyType = .done
        searchTextView.backgroundColor = .white
        searchTextView.layer.cornerRadius = 10
        searchTextView.placeholder = "Search here your town (Paris) or zip code (75001,FR)"
        
        // Map
        mapView.delegate = self
        mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: weatherInfo.centerPlace.latitude, longitude: weatherInfo.centerPlace.longitude), latitudinalMeters: initialLatitudinalMetres, longitudinalMeters: initialLongitudinalMetres), animated: true)
        mapView.addAnnotations(annotations)
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        mapView.isUserInteractionEnabled = true
        
        // Containers
        watingView.isHidden = true
        watingView.layer.cornerRadius=10
        containerRecordsView.layer.cornerRadius=10
        containerRecordsView.isHidden = true
    }
    
    @IBAction func valueChangedSearchTextField(_ sender: UITextField) {
        
        let query:String = sender.text!
        switch Reach().connectionStatus() {
        case ReachabilityStatus.offline:
            self.showErrorAlert(error: "Please enable internet settings")
        default:
            if !query.isEmpty {
                watingView.isHidden = false
                containerRecordsView.isHidden = true
                OpenWeatherMapManager.shared.getTheWeatherInfo(query: query) { result in
                    switch result{
                    case .success(let newWeatherInfo):
                        DispatchQueue.main.async {
                            self.weatherInfo = newWeatherInfo
                            self.updateMap()
                        }
                    case .failure(let error):
                        
                        self.showErrorAlert(error: "\(error)")
                        self.watingView.isHidden = true
                        
                    }
                }
            }

        }
        
    }
    
    private func updateMeasures(){
        
        tempValueLabel.text = String(format: "%.1fºC", weatherInfo.hot_record)
        tempTownLabel.text = weatherInfo.hot_record_town ?? "-"
        humidityValueLabel.text = String(format: "%i%%", weatherInfo.humidity_record)
        humidityTownLabel.text = weatherInfo.humidity_record_town ?? "-"
        windValueLabel.text = String(format: "%.2fkm/h", weatherInfo.wind_record)
        windTownLabel.text = weatherInfo.wind_record_town ?? "-"
        rainValueLabel.text = String(format: "%.2fmm", weatherInfo.rain_record)
        rainTownLabel.text = weatherInfo.rain_record_town ?? "-"
        containerRecordsView.isHidden = false
        
    }
    
    private func updateMap(){
        
        mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: weatherInfo.centerPlace.latitude, longitude: weatherInfo.centerPlace.longitude), latitudinalMeters: initialLatitudinalMetres, longitudinalMeters: initialLongitudinalMetres), animated: true)
        addAnnotations()
        selectPinAvailable = true
        updateMeasures()
        watingView.isHidden = true
        containerRecordsView.isHidden = false
        
    }
    
    private func addAnnotations() {
        
        mapView.removeAnnotations(annotations)
        annotations = []
        let centerPin = MyPointAnnotation()
        centerPin.place = weatherInfo.centerPlace
        centerPin.title = weatherInfo.centerPlace.name
        centerPin.coordinate = CLLocationCoordinate2D(
            latitude: weatherInfo.centerPlace.latitude,
            longitude: weatherInfo.centerPlace.longitude
        )
        annotations.append(centerPin)
        
        // Print 4 close towns
        for position in Positions.allCases {
            
            let place: Place
            switch position {
            case Positions.North:
                place = weatherInfo.northPlace!
            case Positions.South:
                place = weatherInfo.southPlace!
            case Positions.East:
                place = weatherInfo.eastPlace!
            case Positions.West:
                place = weatherInfo.westPlace!
            }
            let newPin = MyPointAnnotation()
            newPin.place = place
            newPin.title = place.name
            newPin.coordinate = CLLocationCoordinate2D(
                latitude: place.latitude,
                longitude: place.longitude
            )
            annotations.append(newPin)
            
        }
        mapView.addAnnotations(annotations)
        
    }
    
    private func showErrorAlert(error: String){
        
        let alert = UIAlertController(title: "Alert!", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .cancel))
        self.present(alert, animated: true)
        
    }
    
}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        let annotation = view.annotation as? MyPointAnnotation
        if let place = annotation?.place {
            selectPinAvailable = false
            watingView.isHidden = false
            containerRecordsView.isHidden = true
            OpenWeatherMapManager.shared.getTheWeatherInfoFromPlace(place: place) { result in
                switch result{
                case .success(let newWeatherInfo):
                    DispatchQueue.main.async {
                        self.weatherInfo = newWeatherInfo
                        self.updateMap()
                    }
                case .failure(let error):
                    
                    self.showErrorAlert(error: "\(error)")
                    self.selectPinAvailable = true
                    self.watingView.isHidden = true
                    
                }
            }
        }
        
    }
    
}
