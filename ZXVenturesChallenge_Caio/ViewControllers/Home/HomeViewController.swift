//
//  HomeViewController.swift
//  ZXVenturesChallenge_Caio
//
//  Created by Caio de Souza on 03/04/2018.
//  Copyright © 2018 Caio de Souza. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa



class HomeViewController: UIViewController, SegueHandlerType {
    
    //Outlets
    @IBOutlet weak var adressFilterTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateView: UIView!
    
    //Segue Handler
    enum SegueIdentifier: String {
        case ProductList
    }
    
    // Presenter
    let presenter : HomeViewPresenter = HomeViewPresenterImplementation()
    
    //RX Stuff
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        //
        presenter.attach(view: self)
        
        //
        tableView.register(AddressTableViewCell.self)
        
        //
        
        //Reactive Text Field
        adressFilterTextField.rx.text
            .orEmpty
            .debounce(0.5,
                      scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] query in
                DispatchQueue.main.async {
                    self.setLoadingState()
                }
                self.presenter.updateLocations(forInput: query) })
            .disposed(by: disposeBag)
        
        //
        setEmptyState()
        let _ = adressFilterTextField.becomeFirstResponder()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(for: segue){
        case .ProductList:
            let productsListViewController = segue.destination as! ProductsListViewController
            productsListViewController.presenter = ProductsListViewPresenterImplementation(pocID: presenter.selectedID)
            productsListViewController.title = presenter.selectedTitle
            break
            
            
        }
        
    }
    
    deinit {
        presenter.detachView()
    }

}

//MARK: - Presenter View Implementation
extension HomeViewController : HomeView{
    
    func reloadLocations() {
        self.emptyStateView.isHidden = true
        self.tableView.isHidden = false
        self.tableView.reloadData()
    }
    
    func setLoadingState() {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.hidesWhenStopped = true
        self.adressFilterTextField.rightView = activityIndicator
        self.adressFilterTextField.rightViewMode = .always
        activityIndicator.startAnimating()
    }
    
    func finishLoadingState() {
        DispatchQueue.main.async {
            self.adressFilterTextField.rightView = nil
            self.adressFilterTextField.rightViewMode = .never
        }
       
    }
    
    func setEmptyState() {
        self.emptyStateView.isHidden = false
        self.tableView.isHidden = true
    }
    
    func presentError(message: String) {
        let alertController = UIAlertController(title: "Error...", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "Ok",
                                                     style: .cancel,
                                                     handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    func pushNextViewController() {
        self.performSegue(withIdentifier: .ProductList, sender: nil)
    }
}

//MARK: - UITableViewDataSource
extension HomeViewController : UITableViewDataSource{
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfLocations
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as AddressTableViewCell
        if let addressString = presenter.address(forRow: indexPath.row){
            cell.configure(title: addressString)
        }
        return cell
    }
}
//MARK: - UITableViewDelegate
extension HomeViewController : UITableViewDelegate{


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! AddressTableViewCell
        presenter.setSelectedTitle(title: cell.adressTitleLabel.text!)
        presenter.fetchSelectedLocation(row: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}
