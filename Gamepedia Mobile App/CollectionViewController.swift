//
//  CollectionViewController.swift
//  Gamepedia Mobile App
//
//  Created by Jay on 12/8/16.
//  Copyright © 2016 Juan Pablo Fernandez. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate,UISearchResultsUpdating, wikiArticlesDelegate {
    
    
    
    var wikiArticle = wikiArticles()
    var articleList: [[String: String]] = []
    
    var filteredNames: [[String: String]] = []
    
    var searchController: UISearchController!
    var resultsController = UICollectionViewController()

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wikiArticle.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: CGFloat(200), height: self.collectionView.bounds.height)
        resultsController = UICollectionViewController(collectionViewLayout: flowLayout)

        self.resultsController.collectionView?.delegate = self
        self.resultsController.collectionView?.dataSource = self
//        self.resultsController.collectionView?.register(CollectionViewCell(), forCellWithReuseIdentifier: "Cell")
        self.resultsController.collectionView?.backgroundColor = UIColor.white
        self.resultsController.collectionView?.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        self.searchController = UISearchController(searchResultsController: self.resultsController)
        self.navigationItem.titleView = self.searchController.searchBar
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.definesPresentationContext = false
        
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredNames = []
        print(searchController.searchBar.text)
        for i in articleList.indices {
            if (articleList[i]["Title"]?.lowercased().contains(searchController.searchBar.text!.lowercased()))! {
                filteredNames.append(articleList[i])
                print(articleList[i]["Title"])
            }
        }
        
        
        resultsController.collectionView?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height
        
        let frame = CGSize(width: (width/2)-5, height: (height/4)-5)
        return frame
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.collectionView {
            return articleList.count
        } else {
            return filteredNames.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(articleList[indexPath.row]["Title"])
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        // Configure the cell
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
            cell.titleLabel.text = articleList[indexPath.row]["Title"]
            return cell
        } else {
            print(filteredNames[indexPath.row]["Title"])
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SearchCollectionViewCell
            cell.textLabel?.text = filteredNames[indexPath.row]["Title"]
//            cell.backgroundColor = UIColor.blue
            return cell
        }
        
    }
    
    func listOfWikis(wikiList: [[String : String]]) {
//        print(wikiList)
        articleList = wikiList
        collectionView?.reloadData()
    }
}
