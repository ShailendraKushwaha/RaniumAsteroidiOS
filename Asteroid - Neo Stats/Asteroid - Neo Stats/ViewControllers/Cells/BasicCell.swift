//
//  BasicCell.swift
//  Asteroid - Neo Stats
//
//  Created by Shailendra Kushwaha on 06/02/23.
//

import UIKit

enum AsteroidInfoType {
    case fastest,closest
}

class BasicCell: UITableViewCell {
    
    static let reuseIdentifier = "BasicCell"
    
    var nearEarthObject : NearEarthObject?{
        didSet{
            setupValues()
        }
    }
    var infotype:AsteroidInfoType  = .fastest
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupView(){
        selectionStyle = .none
    }
    
    private func setupValues(){
        guard let nearEarthObject else { return }
        
        var content = self.defaultContentConfiguration()
        if infotype == .fastest{
            content.text = "Fastest Asteroid"
            content.secondaryText = "Asteroid id - \(nearEarthObject.id) ,speed - \(nearEarthObject.closeApproachData[0].relativeVelocity.kilometersPerHour) KMPH"
        } else {
            content.text = "Closest Distance from Earth"
            content.secondaryText = "Asteroid id - \(nearEarthObject.id) ,Distance - \(nearEarthObject.closeApproachData[0].missDistance.kilometers) Kilometers"
        }
        contentConfiguration = content
    }

}
