//
//  SearchResultsController.swift
//  Campus
//
//  Created by Tim Gymnich on 22.10.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import UIKit
import Sweeft


class SearchResultsController: UITableViewController {
    
    weak var delegate: DetailViewDelegate?
    var promise: Response<[SearchResults]>?
    
    var currentElement: DataElement?
    public var elements: [SearchResults] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.view.backgroundColor = .clear
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            self.tableView.separatorEffect = UIVibrancyEffect(blurEffect: blurEffect)
            self.tableView.backgroundView = blurEffectView

        } else {
            self.view.backgroundColor = .black
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navCon = segue.destination as? UINavigationController {
            if var mvc = navCon.topViewController as? DetailView {
                mvc.delegate = self
            }
            if let mvc = navCon.topViewController as? RoomFinderViewController {
                mvc.room = currentElement
            }
            if let mvc = navCon.topViewController as? PersonDetailTableViewController {
                mvc.user = currentElement
            }
            if let mvc = navCon.topViewController as? LectureDetailsTableViewController {
                mvc.lecture = currentElement
            }
        }
        if var mvc = segue.destination as? DetailView {
            mvc.delegate = self
        }
        if let mvc = segue.destination as? RoomFinderViewController {
            mvc.room = currentElement
        }
        if let mvc = segue.destination as? PersonDetailTableViewController {
            mvc.user = currentElement
        }
        if let mvc = segue.destination as? LectureDetailsTableViewController {
            mvc.lecture = currentElement
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard !elements[section].results.isEmpty else {
            return nil
        }
        return elements[section].key.description
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        currentElement = elements[indexPath.section].results[indexPath.row]
        return indexPath
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements[section].results.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return elements.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let element = elements[indexPath.section].results[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: element.getCellIdentifier()) as? CardTableViewCell ?? CardTableViewCell()
        cell.setElement(element)
        cell.backgroundColor = .clear
        
        return cell
    }
    
}

extension SearchResultsController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}


extension SearchResultsController: DetailViewDelegate {
    
    func dataManager() -> TumDataManager? {
        return delegate?.dataManager()
    }
    
}

extension SearchResultsController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        promise?.cancel()
        if let query = searchController.searchBar.text {
            promise = delegate?.dataManager()?.search(query: query).onSuccess(in: .main) { elements in
                self.elements = elements
            }
        }
    }
    
}
