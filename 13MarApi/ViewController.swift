//
//  ViewController.swift
//  13MarApi
//
//  Created by Appinventiv-PC on 13/03/18.
//  Copyright © 2018 Appinventiv-PC. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UISearchBarDelegate{
    // Mark:-variables
    var  fetchedData1 = [Locations]()
    let K_GOOGLE_API_KEY = "AIzaSyDQAoHIo0XgKc7pQl43H4D64F-PmiTrPVA"
    var searchItem = ""
    // Mark :- Outlets
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewOutlet.dataSource = self
        tableViewOutlet.delegate = self
        setUpSearchBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setUpSearchBar(){
        searchBarOutlet.delegate = self
    }
    
    
    
    // Mark ;- function for data retrival
    func parseData(item : String) {
   fetchedData1  = []
        //addingPercentEncoding adds % sign inplace of spaces during search
        let request = NSMutableURLRequest(url: NSURL(string: "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(searchBarOutlet.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&key=\(K_GOOGLE_API_KEY)")! as URL,cachePolicy: .useProtocolCachePolicy,timeoutInterval: 10.0)
        print (request)
        request.httpMethod = "GET"
      //  request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse!)
                guard let d = data else{return}
                let fetchedData = try! JSONSerialization.jsonObject(with: d, options: .mutableContainers) as!NSDictionary
                let arrayData = fetchedData["results"] as! [[String : Any]]
                print(arrayData)
                // arraydata is a type of array, inside array is dictionary...so we accessing each element one by one which is of form dictionary and then mapping(transforming) it as data passed to location initialiser.
                self.fetchedData1 = arrayData.map({ (data) -> Locations in
                    return Locations(data1: data)
                })
                DispatchQueue.main.async {
                    self.tableViewOutlet.reloadData1()
                }
            }
        }
        )
        
        dataTask.resume()
    }
}



public class Locations {
    
    var name : String = ""
    var address : String = ""
    var photos : [[String :Any]] = []
    var height : Int = 0
    var reference : String = ""
    
    init (data1:[String : Any]){
        
        if let name = data1["name"] as? String
        {
            self.name = name
        }
        if let address = data1["formatted_address"] as? String {
            self.address = address
        }
        
        if let photos = data1["photos"] as? [[String :Any]]{
            self.photos = photos
        }
        
        if !self.photos.isEmpty,let height = photos[0]["height"] as? Int{
            self.height = height
        }
        
        if !self.photos.isEmpty,let reference = photos[0]["photo_reference"] as? String{
            self.reference = reference
        }
        
        
    }
    
}



extension ViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  fetchedData1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewOutlet.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let urlString = "https://maps.googleapis.com/maps/api/place/photo?maxwidth="+"\(fetchedData1[indexPath.row].height)"+"&photoreference="+fetchedData1[indexPath.row].reference+"&key=\(K_GOOGLE_API_KEY)"
print (urlString)
        if let url = URL(string: urlString) {
            do {
                let imageData = try Data(contentsOf: url)
                cell.imageOutletInCellClass.image = UIImage(data: imageData)
            } catch {
                print("Unable to load data: \(error)")
            }
        }
     //   if (indexPath.row == 0){ print("type something") }else{
        cell.NameOutletinCellclass.text = fetchedData1[indexPath.row].name
        
        
        cell.DiscriptionOfItemInCellClas.text = fetchedData1[indexPath.row].address
        return cell
        }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            UIView.animate(withDuration: 0.5){
            cell.transform = CGAffineTransform.identity
    
     }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        searchItem = searchText
        parseData(item: searchItem)
        print (searchText)
    }
    
    
}
extension UITableView {
    func reloadData1(afterDelay delayTime: TimeInterval=4) -> Void {
        self.perform(#selector(self.reloadData), with: nil, afterDelay: delayTime)
    }

}
