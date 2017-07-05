//
//  ViewController.swift
//  learnReactive
//
//  Created by Anuradha Sharma on 23/06/17.
//  Copyright © 2017 Anuradha Sharma. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var txtCities: UITextField!
    @IBOutlet weak var lblCityName: UILabel!
    
    var name: Variable<String> = Variable("Julia")
    
    var shownCities = [String]()
    let allCities = ["California", "rio de janeiro", "birmingham", "ottawa", "bangalore", "Helsinki"]
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.asObservable()
            .bind(to: lblCityName.rx.text)
            .addDisposableTo(disposeBag)
        
        txtCities.rx.controlEvent([.editingDidBegin,.editingDidEnd,.editingChanged])
            .asObservable()
            .subscribe(onNext: {
                self.name.value = self.txtCities.text!
            })
            .addDisposableTo(disposeBag)
        
        searchBar
            .rx.text
            .orEmpty
            .debounce(0.2, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .subscribe(onNext: { [unowned self] query in
                self.shownCities = self.allCities.filter { $0.hasPrefix(query) }
                self.tableView.reloadData()
            })
            .addDisposableTo(disposeBag)
    }
    
    func addObservableOnCities(){
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return shownCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityPrototypeCell", for: indexPath)
        cell.textLabel?.text = shownCities[indexPath.row]
        return cell
    }
}


