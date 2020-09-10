//
//  WALocationListView.swift
//  WeatherApp
//
//  Created by qiaoliwen on 2020/9/10.
//  Copyright © 2020 qiaoliwen. All rights reserved.
//


import UIKit
import EasyPeasy

class WALocationListView: UITableView{
    
    private var cityList: [[String: String]] = []
    private var cityNameList: [String] = []
    
    init(frame: CGRect,coreDataStack:  WACoreDataStack){

        super.init(frame: frame, style: .plain)
        
        self.register(WALocationListCell.self, forCellReuseIdentifier: "WALocationListCell")
        self.separatorInset =  UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        self.dataSource = self
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCityNameList(cityNameList: [String]){
        self.cityNameList = cityNameList
        self.reloadData()
    }
    
    func updateCityList(cityList: [[String: String]]){
        self.cityList = cityList
    }
}

extension WALocationListView: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.cityNameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "WALocationListCell", for: indexPath) as! WALocationListCell
        cell.updateLocationNameList(locationName: cityNameList[indexPath.row])
        return cell
    }
    
    // delete table cell
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            cityList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // move table cell
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = cityList[sourceIndexPath.row]
        cityList.remove(at: sourceIndexPath.row)
        cityList.insert(movedObject, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}
