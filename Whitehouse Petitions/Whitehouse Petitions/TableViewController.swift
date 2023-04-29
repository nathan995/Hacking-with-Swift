//
//  ViewController.swift
//  Whitehouse Petitions
//
//  Created by Nathan Getachew on 4/26/23.
//

import UIKit

class TableViewController: UITableViewController{
    
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.title = "Most recent"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target : self, action : #selector(filterTapped))
        
        let urlString : String
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        DispatchQueue.global(qos: .userInitiated).async {  [weak self] in
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    self?.parse(json: data)
                    return
                }
            } else {
                
                self?.showError()
            }
        }
    }
    
    @objc func filterTapped(){
        let ac = UIAlertController(title: "Filter", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self,weak ac] _ in
            guard let text = ac?.textFields?[0].text else { return }
            self?.filter(text)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func filter(_ text : String){
        
        filteredPetitions =  filteredPetitions.filter { petition in
            petition.title!.contains(text)
        }
        
        tableView.reloadData()
    }
    
    func showError() {
        DispatchQueue.main.async { [weak self] in
            
            
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(ac, animated: true)
        }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = petitions
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let petition = filteredPetitions[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let petition = filteredPetitions[indexPath.row]
        let vc = DetailViewController()
        vc.detailItem = petition
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

