//
//  TableViewController.swift
//  Gamepedia Mobile App
//
//  Created by Jay on 12/6/16.
//  Copyright © 2016 Juan Pablo Fernandez. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, wikiArticlesDelegate, UISearchResultsUpdating {
    
    var wikiArticle = wikiArticles()
    var articleList: [[String:String]]?
    
    var filteredNames: [[String: String]] = []
    
    var searchController: UISearchController!
    var resultsController = UITableViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        wikiArticle.delegate = self
        
        self.resultsController.tableView.dataSource = self
        self.resultsController.tableView.delegate = self
        
        
        self.searchController = UISearchController(searchResultsController: self.resultsController)
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
    }
    
    
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredNames = []
        for i in (articleList?.indices)! {
            if (articleList?[i]["Title"]?.lowercased().contains(searchController.searchBar.text!.lowercased()))! {
                filteredNames.append((articleList?[i])!)
                print(articleList?[i]["Title"])
            }
        }
        resultsController.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if tableView == self.tableView {
            if articleList != nil {
                return (articleList?.count)!
            } else {
                return 0
            }
        } else {
            print(filteredNames.count)
            return filteredNames.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let cell = UITableViewCell()
        if tableView == self.tableView {
            if articleList != nil {
                cell.textLabel?.text = articleList?[indexPath.row]["Title"]
                cell.detailTextLabel?.text = articleList?[indexPath.row]["Articles"]
            } else {
                return cell
            }
        } else {
            cell.textLabel?.text = filteredNames[indexPath.row]["Title"]
            cell.detailTextLabel?.text = filteredNames[indexPath.row]["Articles"]
        }
        
        return cell
        
    }
    
    func listOfWikis(wikiList: [[String : String]]) {
        print(wikiList.count)
        articleList = wikiList
        tableView.reloadData()
    }

}
