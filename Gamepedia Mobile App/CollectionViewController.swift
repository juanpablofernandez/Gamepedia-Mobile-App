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
            let image = articleList[indexPath.row]["Image"]
            cell.titleLabel.text = articleList[indexPath.row]["Title"]
            cell.imageView.image = nil
            cell.imageView.downloadedFrom(link: image!)
            return cell
        } else {
            print(filteredNames[indexPath.row]["Title"])
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SearchCollectionViewCell
            let image = filteredNames[indexPath.row]["Image"]
            cell.textLabel?.text = filteredNames[indexPath.row]["Title"]
            cell.imageView?.downloadedFrom(link: image!)
//            cell.backgroundColor = UIColor.blue
            return cell
        }
        
    }
    
    func listOfWikis(wikiList: [[String : String]]) {
        print(wikiList.count)
        articleList = wikiList
        collectionView?.reloadData()
    }
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
