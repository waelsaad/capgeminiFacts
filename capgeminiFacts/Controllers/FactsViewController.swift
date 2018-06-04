//
//  FactsViewController.swift
//  capgeminiFacts
//
//  Created by Wael Saad on 6/4/18.
//  Copyright © 2018 nettrinity.com.au All rights reserved.
//

import UIKit

enum SegueIdentifier: String {
    case reuseIdentifier = "FactCollectionImageCell"
    case showDetailSegue = "FactShowDetailView"
}

class FactsViewController: UICollectionViewController, NetworkResponse {
    
    var viewModel : FactViewModel!
    
    // Saves the Size of cell in a cache so that can be used to relayout cell
    private var cellSizeCache = NSCache<NSIndexPath, NSValue>()
    
    // Default image used to get dimensions of cell before downloading anything
    let initialImage: UIImage = UIImage(named: APPIMAGES.NoImage)!
    
    // Add a refresh control - Pull To Refresh
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.lightGray
        refreshControl.backgroundColor = UIColor.white
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.red, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 19.0)]
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Facts ...", attributes: attributes)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Facts"
        viewModel = FactViewModel.init(delegate: self)
        collectionView?.addSubview(refreshControl)
        showActivityIndicator()
        refreshData()
    }
    
    @IBAction func refreshClicked(_ sender: Any) {
        refreshData()
    }
    
    @objc func refreshData () -> Void {
        viewModel.refreshData()
    }
    
    // Add a refresh activity indicator on the navigation bar
    func showActivityIndicator() {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicatorView.startAnimating()
        let barButtonItem = UIBarButtonItem(customView: activityIndicatorView)
        navigationItem.setRightBarButton(barButtonItem, animated: true)
    }
    
    // Hide the refresh activity indicator once loaded all the images
    func hideActivityIndicator() {
        navigationItem.rightBarButtonItem = nil
    }
    
    // Refresh the UI and remove the refresh control
    func refreshFactsUI() {
        self.refreshControl.endRefreshing()
        self.cellSizeCache.removeAllObjects()
        self.collectionView?.reloadData()
        hideActivityIndicator()
        if viewModel.facts.count > 0{
            self.collectionView?.selectItem(at: IndexPath.init(row: 0, section: 0), animated: false, scrollPosition: .top)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.showDetailSegue.rawValue {
            let vc = segue.destination as! FactDetailViewController
            vc.loadData(vm: viewModel.selectedViewModel())
        }
    }
    
    func defaultSizeForImageView() -> CGSize {
        return initialImage.size
    }
    
    func stateUpdated(success: Bool, error: String) {
        if !success {
            self.displayAlert("Error", message: error, okBlock: nil)
        }
        refreshFactsUI()
    }
    
    // Handle the layout on device rotation and based on dimentions
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.collectionView?.collectionViewLayout.invalidateLayout()
    }
}

extension FactsViewController {
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SegueIdentifier.reuseIdentifier.rawValue, for: indexPath) as! FactCollectionViewCell
        cell.loadData(viewModel: viewModel.viewModelForCell(at: indexPath.row), delegate: self)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.cellSelected(index: indexPath.row)
        self.performSegue(withIdentifier: SegueIdentifier.showDetailSegue.rawValue , sender: nil)
    }
}

extension FactsViewController: ImageDownloaded {
    // Gets the size of cell and cache it.
    func resizeCell(at index: Int, size: CGSize) {
        let indexPath = NSIndexPath.init(item: index, section: 0)
        cellSizeCache.setObject(NSValue(cgSize: size), forKey: indexPath)
        self.collectionView?.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - UICollectionViewFlowLayout Delegate

extension FactsViewController: UICollectionViewDelegateFlowLayout {
    
    // Get the size of cell and calculate the height based on the collection view constraint

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize  {
        var insets: CGFloat = 0.0
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            insets = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        }
        let elementsCount = CGFloat(2)
        let size = UIScreen.main.bounds.width / elementsCount - insets
        return CGSize(width: size, height: size)
    }
}


