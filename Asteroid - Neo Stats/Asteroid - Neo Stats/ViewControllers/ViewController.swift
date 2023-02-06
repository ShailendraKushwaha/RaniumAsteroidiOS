//
//  ViewController.swift
//  Asteroid - Neo Stats
//
//  Created by Shailendra Kushwaha on 05/02/23.
//

import UIKit
import Charts

class ViewController: UIViewController {
    
    private lazy var tableView : UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ChartCell.self, forCellReuseIdentifier: ChartCell.reuseIdentifier)
        tableView.register(BasicCell.self, forCellReuseIdentifier: BasicCell.reuseIdentifier)
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    private var headerView : UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let startDateField : DateTextField = {
       let textField = DateTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter Start Date"
        return textField
    }()
    
    private let endDateField : DateTextField = {
       let textField = DateTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter End Date"
        return textField
    }()
    
    private lazy var submitButon : UIButton = {
       let button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(self.submitButtonPressed), for: .touchUpInside)
        button.layer.cornerRadius = 8
        return button
    }()
    
    
    var asteroidInfo : AsteroidInfo? {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Asteroids NeoW API"
    }
}

private extension ViewController {
    
    func setupView(){
        view.backgroundColor = .white
        
        view.addSubview(headerView)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 16),
            headerView.heightAnchor.constraint(equalToConstant: 78),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        headerView.addSubview(startDateField)
        headerView.addSubview(endDateField)
        headerView.addSubview(submitButon)
        
        NSLayoutConstraint.activate([
            startDateField.topAnchor.constraint(equalTo: headerView.topAnchor),
            startDateField.heightAnchor.constraint(equalToConstant: 25),
            startDateField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            startDateField.trailingAnchor.constraint(equalTo: view.centerXAnchor,constant: -20),
            
            endDateField.topAnchor.constraint(equalTo: headerView.topAnchor),
            endDateField.heightAnchor.constraint(equalToConstant: 25),
            endDateField.leadingAnchor.constraint(equalTo: view.centerXAnchor,constant: 20),
            endDateField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            
            submitButon.topAnchor.constraint(equalTo: startDateField.bottomAnchor,constant: 16),
            submitButon.heightAnchor.constraint(equalToConstant: 36),
            submitButon.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            submitButon.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20)
        ])
        
    
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor,constant: 16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func callNeoWAPI(params:Dictionary<String,String>){
//    https://api.nasa.gov/neo/rest/v1/feed?start_date=2015-09-07&end_date=2015-09-08&api_key=DEMO_KEY
        
        
        APIHandler.sharedInstance.getAPI(params: params, endPoint: .feed, onSuccess: {[weak self] data,dictionary  in
            do {
                guard let `self` else { return }
                
                if let errorMessage = dictionary["error_message"] as? String {
                    self.showAlert(message: errorMessage)
                    return
                }
                self.asteroidInfo  = try JSONDecoder().decode(AsteroidInfo.self, from: data)
                self.getFastestAsteroid()
            } catch {
                print(error)
            }
        }, onFailure: {error in
            self.showAlert(message: error.localizedDescription)
        })
    }
    
    private func getFastestAsteroid() -> NearEarthObject? {
        guard let asteroidInfo else { return nil }
        
        var allAsteroids :[NearEarthObject] = []
        
        for (_,value) in asteroidInfo.nearEarthObjects {
            allAsteroids.append(contentsOf: value)
        }
        
        let sortedAsteroids = allAsteroids.sorted { object1,object2 in
            if object1.closeApproachData.count == 0 || object2.closeApproachData.count == 0{
                return false
            }
            
            if object1.closeApproachData[0].relativeVelocity.kilometersPerHour > object2.closeApproachData[0].relativeVelocity.kilometersPerHour {
                return true
            }
            
            return false
        }
        
        return sortedAsteroids[0]
    }
    
    private func getClosestAsteroid() -> NearEarthObject? {
        guard let asteroidInfo else { return nil }
        
        var allAsteroids :[NearEarthObject] = []
        
        for (_,value) in asteroidInfo.nearEarthObjects {
            allAsteroids.append(contentsOf: value)
        }
        
        let sortedAsteroids = allAsteroids.sorted { object1,object2 in
            if object1.closeApproachData.count == 0 || object2.closeApproachData.count == 0{
                return false
            }
            
            if object1.closeApproachData[0].missDistance.kilometers > object2.closeApproachData[0].missDistance.kilometers {
                return true
            }
            
            return false
        }
        
        return sortedAsteroids[ sortedAsteroids.count - 1]
    }
    
    func showAlert(message:String){
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default,handler: { action in
            alertController.dismiss(animated: true)
        }))
        alertController.modalTransitionStyle = .crossDissolve
        alertController.modalPresentationStyle = .fullScreen
        self.present(alertController, animated: true)
    }
    
//    MARK: tableView Helper functions
    
    func getCell(for indexPath:IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChartCell.reuseIdentifier, for: indexPath) as? ChartCell else { fatalError("Chartcell failed")}
            cell.awakeFromNib()
            cell.asteroidInfo = asteroidInfo
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BasicCell.reuseIdentifier, for: indexPath) as? BasicCell else { fatalError("Chartcell failed")}
        cell.awakeFromNib()
        cell.infotype = indexPath.row == 1 ? .fastest : .closest
        cell.nearEarthObject = indexPath.row == 1 ? getFastestAsteroid() : getClosestAsteroid()
        return cell
    }
    
   
}

extension ViewController: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 3 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { getCell(for: indexPath)}
    
}

@objc extension ViewController{
    
    func submitButtonPressed(_ sender : Any){
        
        if startDateField.text == "" || endDateField.text == "" {
            return
        }
        
        let params = [
            "start_date":startDateField.text!,
            "end_date":endDateField.text!,
            "api_key":"DEMO_KEY"
        ]
        
        callNeoWAPI(params: params)
    }
    
}
