//
//  ViewController.swift
//  Asteroid - Neo Stats
//
//  Created by Shailendra Kushwaha on 05/02/23.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .red
        callNeoWAPI()
        
    }
}

private extension ViewController {
    
    func callNeoWAPI(){
//    https://api.nasa.gov/neo/rest/v1/feed?start_date=2015-09-07&end_date=2015-09-08&api_key=DEMO_KEY
        let params = [
            "start_date":"2015-09-07",
            "end_date":"2015-09-08",
            "api_key":"DEMO_KEY"
        ]
        
        APIHandler.sharedInstance.getAPI(params: params, endPoint: .feed, onSuccess: {data,dictionary  in
            do {
                let asteroidInfo :AsteroidInfo = try JSONDecoder().decode(AsteroidInfo.self, from: data)
                print(asteroidInfo)
            } catch {
                print(error)
            }
        }, onFailure: {error in
           print(error)
        })
    }
}
