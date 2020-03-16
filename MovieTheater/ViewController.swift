//
//  ViewController.swift
//  MovieTheater
//
//  Created by Mohammed Adel on 3/6/20.
//  Copyright © 2020 Mohammed Adel. All rights reserved.
//

import UIKit
import CoreData


import Alamofire
import SwiftyJSON
import SDWebImage
import Reachability
import iOSDropDown



class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate
{
    
    @IBOutlet weak var dropDown: DropDown!
    @IBOutlet weak var collectionViewShow: UICollectionView!
    
    
    let reachability = try! Reachability()
    
    
    
    
    
    
    struct Movie {
        var id :String
        var original_title : String
        var movie_poster :String
        var overview :String
        var user_rating : Double
        var release_date :String
        
    }
    
    var movieCoreDataStorage = [NSManagedObject]()

    
    
    let popularURL = URL(string:  "https://api.themoviedb.org/3/movie/popular?api_key=6a771f1860da17b780437ad863c1cb6d")
    
    let topRated  = URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=6a771f1860da17b780437ad863c1cb6d")
    
    let dataURl = URL(string:  "https://api.themoviedb.org/3/discover/movie?api_key=6a771f1860da17b780437ad863c1cb6d")
    
    var  arrRes:[Any] = []
    var numberOfResult = 0;
    
    var  resultJson:[JSON] = []
    var imageForEachMovie :[JSON] = []
    

    var selectedMovie:Movie?
    

    
    override func viewWillAppear(_ animated: Bool) {
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        
        dropDown.optionArray = ["Highest rated","Most Popular","Last Movies"]
        dropDown.rowHeight = 45
        
        dropDown.listDidDisappear {
            switch self.dropDown.selectedIndex{
            case 0 :
                self.getListOfMovies(list: self.topRated!)
            case 1:
                self.getListOfMovies(list: self.popularURL!)
            case 2:
                self.getListOfMovies(list: self.dataURl!)
                
            case .none: break
                
            case .some(_): break
            
            }
        }
        
        
    
        
     
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
                
                
                self.getListOfMovies(list: self.dataURl!)














            } else {
                print("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
            let alert = UIAlertController(title: "Unable to detect WiFi connection", message: "It's recommended to turn on WiFi to get the last Movies data ", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "OK \n i will re-connect", style: .default, handler: {action in
                
                if let url = URL(string:"App-Prefs:root=WIFI") {
                    if UIApplication.shared.canOpenURL(url) {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                }
           
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: {action in
               
                func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                    
                    
                    
                    
                    
                    return self.movieCoreDataStorage.count
                }
                
                
                
                
                
                
                
                
                
                
            }))
            
            self.present(alert, animated: true)
            
            
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.hi), name: .reachabilityChanged, object: self.reachability)
            do{
                try self.reachability.startNotifier()
            }catch{
                print("could not start reachability notifier")
            }
        }

       
        
       
        
  
        
        
        
     



}
    
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = view.frame.size.height
        let width = view.frame.size.width
        if UIApplication.shared.statusBarOrientation.isLandscape {
            collectionView.reloadData()
            return CGSize(width: width * 0.4999, height: height * 0.85)
            
        }
        else {
            
            collectionView.reloadData()
            return CGSize(width: width * 0.4999, height: height * 0.24)
            
            
        }
        
        
        
        
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        
        
        
        return self.numberOfResult
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for:indexPath )as! myCollectionViewCell
        
        
        
         cell.myImageCell.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        
        cell.myImageCell.sd_setImage(with: URL(string:
"https://image.tmdb.org/t/p/w185\(self.resultJson[indexPath.row]["poster_path"])"))
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print(self.resultJson[indexPath.row]["original_title"])
        
        
        
        selectedMovie = Movie(id:self.resultJson[indexPath.row]["id"].stringValue ,
            original_title: self.resultJson[indexPath.row]["original_title"].stringValue, movie_poster: self.resultJson[indexPath.row]["poster_path"].stringValue, overview: self.resultJson[indexPath.row]["overview"].stringValue, user_rating: self.resultJson[indexPath.row]["vote_average"].doubleValue, release_date: self.resultJson[indexPath.row]["release_date"].stringValue)
        
        print(self.resultJson[indexPath.row]["id"].stringValue)
        
        
        performSegue(withIdentifier: "movieDetail", sender: self)
        
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var tc = segue.destination as!DetailsTableViewController
        
        
        //sending Data to Detail table view view
        
        //sending title
        tc.detailMovieName = self.selectedMovie?.original_title
        
        //sending poster link
        tc.detailMoviePoster = self.selectedMovie?.movie_poster
        
        //sending release year
        tc.detailMovieReleaseDate = self.selectedMovie?.release_date
        
        //sending release rating
        
        tc.detailMovieRatingValue = self.selectedMovie?.user_rating
        
        //sending overview
        
        tc.detailMovieOverview = self.selectedMovie?.overview
        
        //sending Movie ID
        
        tc.detailMovieId = self.selectedMovie?.id
        
    }
    
    
    @objc func hi(note:Notification){
        print("hi from restart of connection ")
    }
    
    
    func getListOfMovies(list:URL){
        
        Alamofire.request(list).responseData { (resData) -> Void in
            print(resData.result.value!)
            
            let swiftyJsonResult = JSON(resData.result.value!)
            
            self.resultJson = swiftyJsonResult["results"].arrayValue
            
            
            self.numberOfResult = self.resultJson.count
            
            
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let manageContext = appDelegate.persistentContainer.viewContext as!
                NSManagedObjectContext
            
            let entity = NSEntityDescription.entity(forEntityName: "Movie", in: manageContext )
            
            let movie = NSManagedObject(entity: entity!, insertInto: manageContext)
            
            
            
            for i in 0...self.resultJson.count-1 {
                movie.setValue(self.resultJson[i]["original_title"].stringValue, forKey: "title")
                
                movie.setValue(self.resultJson[i]["release_date"].stringValue, forKey: "releaseYear")
                
                movie.setValue(self.resultJson[i]["id"].stringValue, forKey: "id")
                
                movie.setValue(self.resultJson[i]["poster_path"].stringValue, forKey: "poster")
                
                movie.setValue( self.resultJson[i]["overview"].stringValue, forKey: "overview")
                movie.setValue(self.resultJson[i]["vote_average"].doubleValue, forKey: "rating")
                
                
                self.movieCoreDataStorage.append(movie)
            }
            
            do{
                try manageContext.save()
                
            }catch let error{
                print(error)
            }
            
            
            DispatchQueue.main.async {
                // Run UI Updates
                //                print(self.resultJson.count)
                self.collectionViewShow.dataSource = self
                
                self.collectionViewShow.reloadData()
                
                
                
                
            }
            
            
        }

        
    }
}


