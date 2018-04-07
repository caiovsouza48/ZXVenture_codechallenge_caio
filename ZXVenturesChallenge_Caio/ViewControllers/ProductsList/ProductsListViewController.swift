//
//  ProductsListViewController.swift
//  ZXVenturesChallenge_Caio
//
//  Created by Caio de Souza on 05/04/2018.
//  Copyright © 2018 Caio de Souza. All rights reserved.
//

import UIKit
import ZXIBDesignables
import KRLCollectionViewGridLayout

class ProductsListViewController: UIViewController, SegueHandlerType {
    
    //Segue Handler
    enum SegueIdentifier: String {
        case ProductDetails
    }
    
    
    @IBOutlet weak var segmentedControl: SWSegmentedControl!
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingViewActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionEmptyStateView: UIView!
    @IBOutlet weak var collectionLoadingView: UIView!
    @IBOutlet weak var collectionLoadingActivityIndicator: UIActivityIndicatorView!
    
    //Presenter
    var presenter : ProductsListPresenter!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //Presenter Logic
        presenter.attach(view: self)
        presenter.viewDidLoad()
        
        // Cell Register
        productCollectionView.register(ProductCollectionViewCell.self)
        
        // SegmentedControl
        segmentedControl.delegate = self
        
        //Navigation
        let customBarButton = UIBarButtonItem()
        customBarButton.title = ""
        navigationController?.navigationBar.topItem?.backBarButtonItem = customBarButton
        
        //KRLCollectionViewGridLayout
        let layout = productCollectionView.collectionViewLayout as! KRLCollectionViewGridLayout
        layout.numberOfItemsPerLine = 2
        //Current Cell Width/Deidered Height
        layout.aspectRatio = 130.0/200.0
        
        //Refresh Control
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.gray
        refreshControl.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
        productCollectionView.refreshControl = refreshControl
        productCollectionView.alwaysBounceVertical = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(for: segue){
        case .ProductDetails:
            let productDetailsVC = segue.destination as! ProductDetailViewController
            productDetailsVC.presenter = ProductDetailsPresenterImplementation(product: presenter.selectedProduct!)
        }
        
    }
    
    @objc func refreshCollectionView(){
        let selectedSegmentedControlIndex = segmentedControl.selectedSegmentIndex
        presenter.requestCategorySearch(search: "",
                                        categoryID: segmentedControl.tagForSegmentAtIndex(selectedSegmentedControlIndex),
                                        showLoading: false) {
            if self.productCollectionView.refreshControl?.isRefreshing ?? false{
                self.productCollectionView.refreshControl?.endRefreshing()
            }
            self.productCollectionView.reloadData()
        }
    }
    
    deinit {
        presenter.detachView()
    }

}

//MARK: - View Protocol
extension ProductsListViewController : ProductsListView{

    func presentError(message: String) {
        let alertController = UIAlertController(title: "Error...", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "Ok",
                                                     style: .cancel,
                                                     handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func reloadCollectionView() {
        self.productCollectionView.reloadData()
        
    }
    func setupCategorySegmentationControl(configurationTuple: [(title: String, id: Int)]) {

        for (index, tuple) in configurationTuple.enumerated(){
            self.segmentedControl.setTitle(tuple.title, forSegmentAt: index)
            self.segmentedControl.setTag(tuple.id, forSegmentAt: index)
        }
    }
    func setLoadingState() {
        self.segmentedControl.alpha = 0.0
        self.loadingView.isHidden = false
        self.loadingViewActivityIndicator.isHidden = false
        self.loadingViewActivityIndicator.startAnimating()
    }
    
    func finishLoadingState() {
        self.segmentedControl.alpha = 1.0
        self.loadingView.isHidden = true
        self.loadingViewActivityIndicator.stopAnimating()
    }
    func setCollectionLoadingState() {
        self.collectionLoadingActivityIndicator.isHidden = false
        self.collectionLoadingActivityIndicator.startAnimating()
        self.productCollectionView.isHidden = true
        self.collectionLoadingView.isHidden = false
    }
    
    func finishCollectionLoadingState() {
        self.collectionLoadingActivityIndicator.stopAnimating()
        self.collectionLoadingView.isHidden = true
        self.productCollectionView.isHidden = false
    }
    
    func setCollectionEmptyState() {
        self.productCollectionView.isHidden = true
        self.collectionEmptyStateView.isHidden = false
    }
    func hideCollectionEmptyState() {
        self.collectionEmptyStateView.isHidden = true
        self.productCollectionView.isHidden = false
    }
    
    func finishCollectionEmptyState() {
        self.productCollectionView.isHidden = false
        self.collectionEmptyStateView.isHidden = true
    }
    
    
}

//MARK: - UICollectionViewDataSource
extension ProductsListViewController : UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfProducts
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as ProductCollectionViewCell
        let model = presenter.product(at: indexPath.row)
        cell.configure(model: model)
        return cell
    }
    
}

//MARK: - UICollectionViewDelegate
extension ProductsListViewController : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.setSelectedProduct(row: indexPath.row)
        collectionView.deselectItem(at: indexPath, animated: true)
        self.performSegue(withIdentifier: .ProductDetails, sender: nil)
        
        
    }
}

//MARK: - SWSegmentationControl
extension ProductsListViewController : SWSegmentedControlDelegate{
    func segmentedControl(_ control: SWSegmentedControl, didSelectItemAtIndex index: Int) {
        presenter.requestCategorySearch(search: ProductFiltersConstants.searchAll,
                                        categoryID: control.tagForSegmentAtIndex(index), showLoading: true) {
            DispatchQueue.main.async {
                self.reloadCollectionView()
            }
        }
    }
}
