//
//  ViewController.swift
//  Book Listing
//
//  Created by Mohaned Al-Feky on 8/2/18.
//  Copyright © 2018 mohaned. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate, UIPickerViewDelegate,UIPickerViewDataSource {
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var musicData = [JSON]()
    let searchTypes = ["track","artist"]
 
  
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        picker.dataSource = self
        
       
       
        
        
        
    }
     func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text{
            let  newQuery = query.replacingOccurrences(of: " ", with: "+")
            switch searchTypes[picker.selectedRow(inComponent: 0)]{
            case searchTypes[0]:
                searchData(searchType: "search", query: newQuery)
                break
            case searchTypes[1]:
                searchData(searchType: "track", query: newQuery)
                break
           
            default:
                print("Error")
            }
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: searchTypes[row], attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        return attributedString
    }
    
    func searchData(searchType:String,query:String){
        let queryURL = "https://api.deezer.com/\(searchType)?q=\(query)"
        Alamofire.request(queryURL, method: .get, parameters: nil).responseJSON { (response) in
            if response.result.isSuccess{
                if let responseData = response.result.value{
                    let jsonData : JSON = JSON(responseData)
                  
                    self.musicData = jsonData["data"].arrayValue
                    print(self.musicData)
                    self.tableView.reloadData()
                   
                
                
                }else{
                    print("No Data")
                }
            }else{
                print("Not Connected")
                
            }
        
    }
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MusicTableViewCell
            cell.titleLabel.text = musicData[indexPath.row]["title"].string
            cell.albumLabel.text = musicData[indexPath.row]["album"]["title"].string
        cell.artistLabel.text = musicData[indexPath.row]["artist"]["name"].string
        if let urlString = musicData[indexPath.row]["album"]["cover_medium"].string{
        if let url = URL(string: urlString){
            cell.coverImage.kf.setImage(with: url)
            
        }
        }
        return cell
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return searchTypes.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return searchTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        searchBar.text = ""
        searchBar.placeholder = "Search By \(searchTypes[row])"
        musicData.removeAll()
        self.tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       performSegue(withIdentifier: "musicSegue", sender: musicData[indexPath.row])
       
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AudioViewController
        if let  jsonData = sender as? JSON{
            vc.imageMedium = jsonData["album"]["cover_medium"].string
            vc.imageTitle = jsonData["title"].string
            vc.imageHigh = jsonData["album"]["cover_big"].string
            vc.previewURL = jsonData["preview"].string
            
        }
        
}
}

