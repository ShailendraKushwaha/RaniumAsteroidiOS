//
//  ChartCell.swift
//  Asteroid - Neo Stats
//
//  Created by Shailendra Kushwaha on 05/02/23.
//

import UIKit
import Charts

class ChartCell: UITableViewCell {
    
    static let reuseIdentifier =  "ChatCell"
    
    private var lineChartView: LineChartView = {
       let chart = LineChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        
        chart.rightAxis.enabled = false
        
        chart.leftAxis.labelFont = .boldSystemFont(ofSize: 14)
        
        chart.xAxis.labelPosition = .bottom
        chart.xAxis.labelFont = .boldSystemFont(ofSize: 14)
    
        return chart
    }()
    
    let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    var lineChartWidth: NSLayoutConstraint?
    
    var lineChartEntry = [ChartDataEntry]()
    var asteroidInfo : AsteroidInfo?{
        didSet{
            setupValues()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupView(){
        contentView.addSubview(scrollView)
        scrollView.addSubview(lineChartView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo:contentView.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            scrollView.heightAnchor.constraint(equalTo:lineChartView.heightAnchor)
        ])
        
        lineChartWidth = lineChartView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        NSLayoutConstraint.activate([
            lineChartView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            lineChartView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            lineChartView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            lineChartView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            lineChartWidth!,
            lineChartView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        ])
        self.layoutIfNeeded()
    }
    
    private func setupValues(){
        guard let asteroidInfo else { return }
        lineChartEntry.removeAll()
        let xAxisLabels = sortDates(array:Array(asteroidInfo.nearEarthObjects.keys))
        var index : Int =  0
        for label in xAxisLabels {
            if let asteroids = asteroidInfo.nearEarthObjects[label] as? [NearEarthObject] {
                let entry = ChartDataEntry(x: Double(index), y: Double(asteroids.count))
                lineChartEntry.append(entry)
            }
            index += 1
        }
        
        // MARK: this method doesnt work because keys are dictionary sorted dates appear in jumbeled up sequence
//        var index : Int =  0
//        for (key,value) in asteroidInfo.nearEarthObjects{
//            print(key)
//            print(value.count)
////            let entry = ChartDataEntry(x: Double(index), y: Double(value.count))
////            lineChartEntry.append(entry)
////            index += 1
//        }

        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Number of asteroids per day")
        line1.colors = [NSUIColor.blue]
        line1.valueFont = .boldSystemFont(ofSize: 14)
        line1.drawCirclesEnabled = false
        let data = LineChartData()
        data.dataSets = [line1]
        lineChartView.data = data
        
        
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:xAxisLabels)
            lineChartView.xAxis.granularity = 1
        lineChartView.setVisibleXRangeMaximum(Double(xAxisLabels.count)/2)
        lineChartView.xAxis.setLabelCount(Int(Double(xAxisLabels.count)/2), force: false)
        lineChartView.animate(xAxisDuration: 2.0)
    }
    
    
    func sortDates(array:[String]) -> [String] {
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        df.locale = Locale(identifier: "en_IN")
        df.timeZone = TimeZone(identifier: "UTC")!

        return array.sorted {df.date(from: $0)! < df.date(from: $1)!}
         //->["2019-1-10", "2015-4-2", "2010-11-21", "2010-2-3"]
    }

}
