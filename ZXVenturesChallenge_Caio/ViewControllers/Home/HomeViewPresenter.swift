//
//  HomeViewPresenter.swift
//  ZXVenturesChallenge_Caio
//
//  Created by Caio de Souza on 03/04/2018.
//  Copyright © 2018 Caio de Souza. All rights reserved.
//
import CoreLocation

//MARK: - Protocols
protocol HomeView: class{
    func reloadLocations()
    func setLoadingState()
    func finishLoadingState()
    func setEmptyState()
    func presentError(message: String)
    func pushNextViewController()
}

protocol HomeViewPresenter : class{
    func attach(view: HomeView)
    func detachView()
    func updateLocations(forInput text: String)
    func address(forRow row: Int) -> String?
    var numberOfLocations : Int { get }
    func fetchSelectedLocation(row: Int)
    var selectedID : String! { get }
    var selectedTitle: String? { get }
    func setSelectedTitle(title: String)
    
}
//MARK: - Implementation
class HomeViewPresenterImplementation : HomeViewPresenter{

    
    private weak var view : HomeView?
    private var pocDataSource : [PocSearchMethodQuery.Data.PocSearch?]?
    private let gateway : BeerGateway!
    private(set) var selectedID : String!
    var selectedTitle : String?
    
    init() {
        self.gateway = BeerApolloGateway()
    }

    var numberOfLocations : Int{
        return pocDataSource?.count ?? 0
    }
    
    func attach(view: HomeView) {
        self.view = view
    }
    
    func detachView() {
        self.view = nil
    }
    
    func updateLocations(forInput text: String){
        self.view?.setLoadingState()
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(text) { (placemarks, error) in
            defer { self.view?.finishLoadingState() }
            guard let placemarks = placemarks, !placemarks.isEmpty else {
                self.view?.setEmptyState()
                return
            }
            if let firstPlacemarkCoordinate = placemarks.first?.location?.coordinate{
                self.requestPoc(latitude: firstPlacemarkCoordinate.latitude,
                           longitude: firstPlacemarkCoordinate.longitude)
                return
            }
            self.view?.setEmptyState()
        }
    }
    

    
    func address(forRow row: Int) -> String?{
        guard row < self.numberOfLocations else{
            return nil
        }
        return formattedAddress(address: pocDataSource?[row]?.address)
    }
    
    func fetchSelectedLocation(row: Int) {
        guard let _id = pocDataSource?[row]?.id else{
            self.view?.presentError(message: "Unable to Fetch identifier of POC")
            return
        }
        self.selectedID = _id
        self.view?.pushNextViewController()
    }
    
    func setSelectedTitle(title: String){
        self.selectedTitle = title
    }
    
    
    //MARK: Private Methods
    private func formattedAddress(address: PocSearchMethodQuery.Data.PocSearch.Address?) -> String{
        if let _address = address{
            return "\(_address.address1 ?? ""), \(_address.number ?? ""), \(_address.city ?? "")"
        }
        return ""
    }
    
    private func requestPoc(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        gateway.findPOC(latitude: latitude,
                        longitude: longitude)
        { (pocSearchArray, error) in
            self.view?.finishLoadingState()
            guard error == nil else{
                self.view?.setEmptyState()
                return
            }
            guard let _pocSearchArray = pocSearchArray, !_pocSearchArray.isEmpty else{
                self.view?.setEmptyState()
                return
            }
            self.pocDataSource = _pocSearchArray
            self.view?.reloadLocations()
            
        }
    }
    
    
}
