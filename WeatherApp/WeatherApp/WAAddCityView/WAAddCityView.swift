//
//  WAAddCityPage.swift
//  WeatherApp
//
//  Created by qiaoliwen on 2020/9/10.
//  Copyright © 2020 qiaoliwen. All rights reserved.
//

import UIKit
import EasyPeasy

protocol WAAddNewCityDelegate: class {
    func addNewCity()
}

class WAAddCityView: UIView {
    
    //core data
    private var coreDataStack: WACoreDataStack
    //ui
    private var textInputField : UITextField!
    //api
    private weak var apiManager: WAApiManager?
    
    //delegate
    private weak var addNewCityDelegate: WAAddNewCityDelegate?
    
    private var userModel: WAUserModel
    private var searchResultLabel: UILabel!
    private var cityName: String = ""
    private var cityKey: String = ""
    
    init(frame: CGRect, userModel: WAUserModel, addNewCityDelegate: WAAddNewCityDelegate, coreDataStack: WACoreDataStack) {
        self.userModel = userModel
        self.coreDataStack = coreDataStack
        super.init(frame:frame)
        self.apiManager = self
        
        self.backgroundColor = UIColor(named: "weatherColor")
        self.layer.borderColor = UIColor(named: "bgWeatherColor")?.cgColor
        self.layer.borderWidth = 3
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.cornerRadius = 30
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.shadowRadius = 15
        self.clipsToBounds = true
        
        // set search button
        let searchButton = UIButton()
        searchButton.tintColor = UIColor(named: "bgWeatherColor")
        searchButton.setBackgroundImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.setTitleColor(UIColor(named: "bgWeatherColor"), for: .normal)
        searchButton.titleLabel?.font = WAConstant.fontSmall
        searchButton.addTarget(self, action: #selector(searchCityKey), for: .touchUpInside)
        addSubview(searchButton)
        searchButton.easy.layout([Top(30), Right(30), Height(40), Width(40)])
        
        textInputField = UITextField(frame:CGRect())
        textInputField.layer.borderColor = UIColor(named: "bgWeatherColor")?.cgColor
        textInputField.layer.borderWidth = 3
        textInputField.layer.cornerRadius = 15
        textInputField.textAlignment = .left
        textInputField.placeholder = "Search"
        textInputField.tintColor = UIColor(named: "bgWeatherColor")
        textInputField.textColor = UIColor(named: "bgWeatherColor")
        textInputField.font = WAConstant.fontSmall
        textInputField.returnKeyType = UIReturnKeyType.next
        textInputField.delegate = self
        self.addSubview(textInputField)
        textInputField.easy.layout([Left(30), Right(5).to(searchButton), Top(30), Height(40)])
        textInputField.clearButtonMode = .whileEditing
        textInputField.returnKeyType = .done
        textInputField.becomeFirstResponder()
        
        searchResultLabel = UILabel()
        searchResultLabel.textAlignment = .left
        searchResultLabel.textColor = UIColor(named: "bgWeatherColor")
        self.addSubview(searchResultLabel)
        searchResultLabel.easy.layout([Left(30), Right(30), Top(8).to(textInputField), Height(40)])
        
        // set cencel button
        let cencelButton = UIButton()
        cencelButton.layer.borderColor = UIColor(named: "bgWeatherColor")?.cgColor
        cencelButton.layer.borderWidth = 3
        cencelButton.layer.cornerRadius = 15
        cencelButton.tintColor = UIColor(named: "bgWeatherColor")
        cencelButton.setTitle("Cencel", for: .normal)
        cencelButton.setTitleColor(UIColor(named: "bgWeatherColor"), for: .normal)
        cencelButton.titleLabel?.font = WAConstant.fontSmall
        cencelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        addSubview(cencelButton)
        cencelButton.easy.layout([Bottom(10),Left(30),Height(40), Width(100)])
        
        // set done button
        let doneButton = UIButton()
        doneButton.layer.borderColor = UIColor(named: "bgWeatherColor")?.cgColor
        doneButton.layer.borderWidth = 3
        doneButton.layer.cornerRadius = 15
        doneButton.tintColor = UIColor(named: "bgWeatherColor")
        doneButton.setTitle("Add", for: .normal)
        doneButton.setTitleColor(UIColor(named: "bgWeatherColor"), for: .normal)
        doneButton.titleLabel?.font = WAConstant.fontSmall
        doneButton.addTarget(self, action: #selector(done), for: .touchUpInside)
        addSubview(doneButton)
        doneButton.easy.layout([Bottom(10),Right(30),Height(40), Width(100)])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func searchCityKey(){
        if let newCityName = textInputField.text {
            var httpRequest: [String: String] = [:]
            httpRequest.updateValue("get", forKey: "httpMethod")
            httpRequest.updateValue("locations/v1/search", forKey: "httpSubUrl")
            var urlParams: [String: String] = [:]
            urlParams.updateValue("\(newCityName)", forKey: "q")
            urlParams.updateValue("8jqwJ6zNPy3II2I2mZEXenPlOVf7PBXS", forKey: "apikey")
            self.apiManager?.httpRequestAction(httpRequest: httpRequest, bodyParams: nil, urlParams: urlParams, httpTag: "getLocationKey")
        }else{
            textInputField.placeholder = "Enter a city name"
        }
    }
    
    @objc func cancel(){
        self.removeFromSuperview()
    }
    
    @objc func done(){
        self.removeFromSuperview()
        self.addNewCityDelegate?.addNewCity()
    }
}

extension WAAddCityView: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textInputField.resignFirstResponder()
        return true;
    }
    
    func getTextInputFieldText() -> String{
        return textInputField.text ?? ""
    }
    
}

extension WAAddCityView: WAApiManager{
    func doActionAfterHttp(httpResult: Any, httpTag: String) {
        if httpTag == "getLocationKey"{
            let httpResultData = httpResult as? [String: Any] ?? [:]
            let parentCity = httpResultData["ParentCity"] as? [String: Any] ?? [:]
            cityName = parentCity["EnglishName"] as? String ?? ""
            cityKey = parentCity["Key"] as? String ?? ""
            var httpRequest: [String: String] = [:]
            httpRequest.updateValue("get", forKey: "httpMethod")
            httpRequest.updateValue("currentconditions/v1/\(cityKey)", forKey: "httpSubUrl")
            var urlParams: [String: String] = [:]
            urlParams.updateValue("8jqwJ6zNPy3II2I2mZEXenPlOVf7PBXS", forKey: "apikey")
            self.apiManager?.httpRequestAction(httpRequest: httpRequest, bodyParams: nil, urlParams: urlParams, httpTag: "getLocationWeather")
        }else if httpTag == "getLocationWeather"{
            let httpResultData = httpResult as? [[String: Any]] ?? []
            let temperatureData = httpResultData[0]["Temperature"] as? [String: Any] ?? [:]
            let metricData = temperatureData["Metric"] as? [String: Any] ?? [:]
            let value = metricData["Value"] as? Double ?? 0
            let conditionId = httpResultData[0]["WeatherIcon"] as? Int16 ?? 0
            if cityName != ""{
                let currentCityModel = WACityModel(cityName: cityName, cityKey: cityKey, cityTem: value, cityConditionId: conditionId, context: self.coreDataStack.managedContext)
                userModel.addToCityList(currentCityModel)
                coreDataStack.saveContext()
            }
            
        }else{}
    }
}
