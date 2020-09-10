//
//  WAMainPage.swift
//  WeatherApp
//
//  Created by qiaoliwen on 2020/9/10.
//  Copyright © 2020 qiaoliwen. All rights reserved.
//

import UIKit
import EasyPeasy
import CoreData
import CoreLocation

class WAMainPage: UIViewController {
    
    //core data
    var coreDataStack: WACoreDataStack!
    //api
    private weak var apiManager: WAApiManager?
    //view
    private var currentLocationWeatherView: WACurrentLocationView!
    private var lacationListTableView: WALocationListView!
    private var addCityView: WAAddCityView!
    //location
    private var locationManager: CLLocationManager!
    //data
    private var userModel: WAUserModel!
    private var cithModelList: [WACityModel] = []
    //flag
    private var currentCityName: String = ""
    private var currentCityKey: String = ""
    
    init(userModel: WAUserModel, coreDataStack: WACoreDataStack) {
        self.coreDataStack = coreDataStack
        super.init(nibName: nil, bundle: nil)
        self.apiManager = self
        self.userModel = userModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.edgesForExtendedLayout = []
        setupBackgroundImage()
        setupCurrentLocationWeatherView()
        setupLocationListTableView()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
    }
    
    func setupBackgroundImage(){
        let bgView = UIImageView()
        bgView.image = #imageLiteral(resourceName: "background")
        bgView.contentMode = .scaleAspectFill
        self.view.addSubview(bgView)
        bgView.easy.layout([Edges(0)])
    }
    
    func setupCurrentLocationWeatherView(){
        currentLocationWeatherView = WACurrentLocationView()
        currentLocationWeatherView.backgroundColor = .clear
        self.view.addSubview(currentLocationWeatherView)
        currentLocationWeatherView.easy.layout([Top(60),Left(0),Right(0), Height(UIScreen.main.bounds.height/2)])
    }
    
    func setupLocationListTableView(){
        
        let addBt = UIButton()
        addBt.setImage(#imageLiteral(resourceName: "addBt"), for: .normal)
        addBt.addTarget(self, action: #selector(addBtClick), for: .touchUpInside)
        self.view.addSubview(addBt)
        addBt.easy.layout([Top(0).to(currentLocationWeatherView), Right(10), Width(40), Height(40)])
        
        lacationListTableView = WALocationListView(frame: CGRect.zero, coreDataStack: coreDataStack, citySelectedDelegate: self)
        lacationListTableView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        self.view.addSubview(lacationListTableView)
        lacationListTableView.easy.layout([Top(0).to(addBt),Left(0),Right(0), Height(UIScreen.main.bounds.height/2)])
        
        getLocolCityListInfo()
        
    }
    
    @objc func addBtClick(){
        addCityView = WAAddCityView(frame: CGRect.zero, userModel: self.userModel, addNewCityDelegate: self, coreDataStack: self.coreDataStack)
        self.view.addSubview(addCityView)
        addCityView.easy.layout(CenterX(0),Top(90),Height(200),Width(280))
        
    }
    
    func getLocolCityListInfo(){
        var cityNameList: [String] = []
        cithModelList.removeAll()
        let userModelFetchRequest: NSFetchRequest<WAUserModel> = WAUserModel.fetchRequest()
        do {
            let results = try coreDataStack.managedContext.fetch(userModelFetchRequest)
           // print(results)
            guard !results.isEmpty, let cityList = results[0].cityList else {return}
            for (index,city) in cityList.enumerated(){
                let city = city as! WACityModel
                var httpRequest: [String: String] = [:]
                httpRequest.updateValue("get", forKey: "httpMethod")
                httpRequest.updateValue("currentconditions/v1/\(city.cityKey)", forKey: "httpSubUrl")
                var urlParams: [String: String] = [:]
                urlParams.updateValue("8jqwJ6zNPy3II2I2mZEXenPlOVf7PBXS", forKey: "apikey")
                self.apiManager?.httpRequestAction(httpRequest: httpRequest, bodyParams: nil, urlParams: urlParams, httpTag: "CityWeather\(String(index))")
                cithModelList.append(city)
                cityNameList.append(city.cityName ?? "")
            }
            lacationListTableView.updateCityNameList(cityNameList: cityNameList)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
}

extension WAMainPage: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            print(lat)
            print(lon)
            var httpRequest: [String: String] = [:]
            httpRequest.updateValue("get", forKey: "httpMethod")
            httpRequest.updateValue("locations/v1/cities/geoposition/search.json", forKey: "httpSubUrl")
            var urlParams: [String: String] = [:]
            urlParams.updateValue("\(lat),\(lon)", forKey: "q")
            urlParams.updateValue("8jqwJ6zNPy3II2I2mZEXenPlOVf7PBXS", forKey: "apikey")
            self.apiManager?.httpRequestAction(httpRequest: httpRequest, bodyParams: nil, urlParams: urlParams, httpTag: "getCurrentLocation")
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension WAMainPage: WAApiManager{
    func doActionAfterHttp(httpResult: Any, httpTag: String) {
        
        if httpTag == "getCurrentLocation"{
            let httpResultData = httpResult as? [String: Any] ?? [:]
            let parentCity = httpResultData["ParentCity"] as? [String: Any] ?? [:]
            currentCityName = parentCity["EnglishName"] as? String ?? ""
            currentCityKey = parentCity["Key"] as? String ?? ""
            var httpRequest: [String: String] = [:]
            httpRequest.updateValue("get", forKey: "httpMethod")
            httpRequest.updateValue("currentconditions/v1/\(currentCityKey)", forKey: "httpSubUrl")
            var urlParams: [String: String] = [:]
            urlParams.updateValue("8jqwJ6zNPy3II2I2mZEXenPlOVf7PBXS", forKey: "apikey")
            self.apiManager?.httpRequestAction(httpRequest: httpRequest, bodyParams: nil, urlParams: urlParams, httpTag: "getCurrentLocationWeather")
        }else if httpTag == "getCurrentLocationWeather"{
            let httpResultData = httpResult as? [[String: Any]] ?? []
            let temperatureData = httpResultData[0]["Temperature"] as? [String: Any] ?? [:]
            let metricData = temperatureData["Metric"] as? [String: Any] ?? [:]
            let value = metricData["Value"] as? Double ?? 0
            let conditionId = httpResultData[0]["WeatherIcon"] as? Int16 ?? 0
            self.currentLocationWeatherView.updateLocationInfo(cityName: currentCityName, temperature: value, conditionName: WAConstant.getConditionName(conditionId: conditionId))
            if currentCityName != ""{
                let currentCityModel = WACityModel(cityName: currentCityName, cityKey: currentCityKey, cityTem: value, cityConditionId: conditionId, context: self.coreDataStack.managedContext)
                userModel.addToCityList(currentCityModel)
                coreDataStack.saveContext()
            }
        }else {}
    }
}


extension WAMainPage: WACitySelectedDelegate{
    func citySelected(index: Int) {
        let cityModel = cithModelList[index]
        self.currentLocationWeatherView.updateLocationInfo(cityName: cityModel.cityName ?? "", temperature: cityModel.cityTem , conditionName: WAConstant.getConditionName(conditionId: cityModel.cityConditionId))
    }
}

extension WAMainPage: WAAddNewCityDelegate{
    func addNewCity() {
        getLocolCityListInfo()
    }
}

//print("httpResult:\(httpResult)")
//            let httpResultData = httpResult["DailyForecasts"]
//            print("httpResultDataQI:\(httpResultData)")
//           if let data = httpResult["DailyForecasts"] as? [[String:Any]], !data.isEmpty,
//              let dayWeather = data[0]["Day"] as? [String:Any] {
//                 print("httpResultData:\(httpResultData)")
//           }
//                let dayData = httpResultData["Day"] as? [String: Any] ?? [:]
//                print("dayData:\(dayData)")
//                let nightData = httpResultData["Night"] as? [String: Any] ?? [:]
//                print("nightData:\(nightData)")
            
