//
//  ProductsListPresenter.swift
//  ZXVenturesChallenge_Caio
//
//  Created by Caio de Souza on 05/04/2018.
//  Copyright © 2018 Caio de Souza. All rights reserved.
//

import Foundation
import CoreLocation

// Filter Constants
struct ProductFiltersConstants{
    static let searchAll = ""
    static let allCategories = 0
}

//MARK: - Presenter Protocols
protocol ProductsListView : class{
    func presentError(message: String)
    func reloadCollectionView()
    func setupCategorySegmentationControl(configurationTuple : [(title: String, id : Int)])
    func setLoadingState()
    func finishLoadingState()
    func setCollectionLoadingState()
    func finishCollectionLoadingState()
    func setCollectionEmptyState()
    func hideCollectionEmptyState()
    func finishCollectionEmptyState()
    
    
}

protocol ProductsListPresenter : class{
    func attach(view: ProductsListView?)
    func detachView()
    init(pocID: String)
    func viewDidLoad()
    var numberOfProducts : Int { get }
    func product(at row: Int) -> PocCategorySearchQuery.Data.Poc.Product.ProductVariant?
    func requestCategorySearch(search: String, categoryID: Int, showLoading: Bool, completionHandler: @escaping () -> Void)
    var selectedProduct: PocCategorySearchQuery.Data.Poc.Product.ProductVariant? { get }
    func setSelectedProduct(row: Int)
}

//MARK: - Presenter Implementation
class ProductsListViewPresenterImplementation : ProductsListPresenter{


    private weak var view : ProductsListView?
    private var pocID : String
    private var gateway : BeerGateway!
    private var dataSource :  [PocCategorySearchQuery.Data.Poc.Product.ProductVariant?]?
    var selectedProduct: PocCategorySearchQuery.Data.Poc.Product.ProductVariant?
    
    var numberOfProducts: Int{
        return dataSource?.count ?? 0
    }
    
    required init(pocID: String) {
        self.pocID = pocID
        self.gateway = BeerApolloGateway()
    }
    
    func attach(view: ProductsListView?) {
        self.view = view
    }
    
    func detachView() {
        self.view = nil
    }
    
    func viewDidLoad() {
        self.view?.setLoadingState()
        requestAllCategoryTitles { (categoryTuple) in
            self.view?.setupCategorySegmentationControl(configurationTuple: categoryTuple)
            self.requestCategorySearch(categoryID: categoryTuple.first!.id, showLoading: false) {
                DispatchQueue.main.async {
                    self.view?.reloadCollectionView()
                    self.view?.finishLoadingState()
                }
            }
        }
    }

    func product(at row: Int) -> PocCategorySearchQuery.Data.Poc.Product.ProductVariant? {
        return dataSource?[row]
    }
    
    func setSelectedProduct(row: Int) {
        selectedProduct = dataSource?[row]
    }
    
    
    // MARK: - Private Methods
    func requestCategorySearch(search: String = ProductFiltersConstants.searchAll,
                               categoryID: Int = ProductFiltersConstants.allCategories, showLoading: Bool = true, completionHandler: @escaping () -> Void){
        self.view?.hideCollectionEmptyState()
        if showLoading{
            self.view?.setCollectionLoadingState()
        }
        gateway.categorySearch(pocID: self.pocID,
                               search: search, categoryID: 0)
        { (productDataSource, error) in
            defer {
                self.view?.finishCollectionLoadingState()
                self.view?.finishLoadingState()
            }
            guard error == nil else{
                self.view?.setCollectionEmptyState()
                return
            }
            guard let _dataSource = productDataSource, !_dataSource.isEmpty else{
                self.view?.setCollectionEmptyState()
                return
            }
            self.dataSource = _dataSource
            completionHandler()
            
        }
    }
    
    func requestAllCategoryTitles(completionHandler: @escaping ([(title: String, id : Int)]) -> Void){
        gateway.allCategoriesTitle { (allCategorys, error) in
            guard error == nil else{
                self.view?.finishLoadingState()
                self.view?.presentError(message: "Unable To Fetch Category Titles")
                return
            }
            guard let _allCategorys = allCategorys else{
                self.view?.finishLoadingState()
                self.view?.presentError(message: "There's not Registered Category Titles")
                return
            }
            let mappedCategories = _allCategorys.map({ (categoryTitle) -> (title: String, id :Int) in
                return (categoryTitle!.title!, Int(categoryTitle!.id!)!)
            })
            completionHandler(mappedCategories)
            
        }
    }
    
    
}
