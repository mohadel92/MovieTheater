//
//  DetailsTableViewController.swift
//  MovieTheater
//
//  Created by Mohammed Adel on 3/13/20.
//  Copyright © 2020 Mohammed Adel. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import Cosmos
import YoutubePlayer_in_WKWebView
import CoreData

import Reachability


class DetailsTableViewController: UITableViewController {
    
    
    let reachability = try! Reachability()
    
    
    
    
    
    
    var detailMovieName:String?
    
    var detailMoviePoster:String?
    
    var detailMovieReleaseDate:String?
    
    var detailMovieOverview:String?
    
    var detailMovieId:String?
    
    
    var detailMovieRatingValue:Double?
    
    
    
    @IBOutlet weak var DetailMovieYoutube: WKYTPlayerView!
    
    @IBOutlet weak var DetailMovieYoutube2: WKYTPlayerView!
    
    @IBOutlet weak var DetailMovieYoutube3: WKYTPlayerView!
    
    var  resultJsonReview:[JSON] = []
    var  resultJsonVideo:[JSON] = []

    @IBOutlet weak var detailMovieRating: CosmosView!
    @IBOutlet weak var detailMovieName_txt: UILabel!
    
    
    @IBOutlet weak var addFav_btn: UIButton!
    @IBOutlet weak var ReviewCell: UITableViewCell!
   
    @IBAction func addFav(_ sender: Any) {
        
        
        
        
        
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let manageContext = appDelegate.persistentContainer.viewContext 
        
        let entity = NSEntityDescription.entity(forEntityName: "FavMovie", in: manageContext )
        
        let movie = NSManagedObject(entity: entity!, insertInto: manageContext)
        
        
        
        
            movie.setValue(detailMovieName_txt.text, forKey: "title")
            
            movie.setValue(detailMovieYear_txt.text, forKey: "releaseYear")
            
            movie.setValue(detailMovieId, forKey: "id")
            
            movie.setValue(detailMoviePoster, forKey: "poster")
            
            movie.setValue(detailMovieOverview_txt.text, forKey: "overview")
            movie.setValue(detailMovieRating.rating, forKey: "rating")
        
        
        
        addFav_btn.removeFromSuperview()
        addFav_btn.isEnabled = false
            
        do{
         try manageContext.save()
            print("Succes add to fav")
            
            
        }catch let error{
            print(error)
        }
        
        }
        
    
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    
    

    @IBOutlet weak var VideoCell: UITableViewCell!
    
    @IBOutlet weak var detailMovieOverview_txt: UILabel!
    @IBOutlet weak var detailMovieYear_txt: UILabel!
    @IBOutlet weak var detailMovieImg: UIImageView!
    
    @IBOutlet weak var detailMovieReviews_txt: UILabel!
    
  
  
    
    
  
    override func viewWillAppear(_ animated: Bool) {
        let reachability = try! Reachability()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
      
        
        //Test..Test..Test..Test
        //print("the sent name is equal to : \(detailMovieName!)")
        
   
        //print("https://image.tmdb.org/t/p/w342\(detailMoviePoster!)")
        //..Test..Test..Test..Test
        
        
        
        //setting the the Name of the Movie
        detailMovieName_txt.text = detailMovieName
        detailMovieName_txt.adjustsFontSizeToFitWidth = true
        ///////////
        
        
        //setting the picture of the movie
        detailMovieImg.sd_imageIndicator = SDWebImageActivityIndicator.gray
        detailMovieImg.sd_setImage(with: URL(string:
            "https://image.tmdb.org/t/p/w342\(detailMoviePoster!)"))
        
        //setting the release Date of the movie
        
            //getting the Year from release Date
        var detailMovieYear = detailMovieReleaseDate?.components(separatedBy: "-")
        
            //setting release year to textfield
        detailMovieYear_txt.text = detailMovieYear?[0]
        
         //setting rating /2 to get it from 5 +> to textfield
        
        detailMovieRating.rating = detailMovieRatingValue!/2
        
        //setting overview
        
        detailMovieOverview_txt.text = "Overview: \n \(detailMovieOverview!)"
        //setting reviews for movies
        
        
        
        // requesting Data for View
        
        let dataURl = "https://api.themoviedb.org/3/movie/\(String(describing: detailMovieId!))/reviews?api_key=6a771f1860da17b780437ad863c1cb6d"
        
        let videoURl = "https://api.themoviedb.org/3/movie/\(String(describing: detailMovieId!))/videos?api_key=6a771f1860da17b780437ad863c1cb6d"
        
        
        
        
        
        
        
        
        
        
        
        
        
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
                
                
                
                
                
                
                
                
                
                
                
                Alamofire.request(dataURl).responseData { (resData) -> Void in
                    print(resData.result.value!)
                    
                    let swiftyJsonResult = JSON(resData.result.value!)
                    
                    self.resultJsonReview = swiftyJsonResult["results"].arrayValue
                    
                    // requesting Youtube vide for View
                    
                    
                    Alamofire.request(videoURl).responseData { (videoData) -> Void in
                        print(videoData.result.value!)
                        
                        let swiftyJsonVideo = JSON(videoData.result.value!)
                        
                        self.resultJsonVideo = swiftyJsonVideo["results"].arrayValue
                        
                        
                        
                        
                        
                        
                        
                        DispatchQueue.main.async {
                            // Run UI Updates
                            //                print(self.resultJson.count)
                            
                            //            for i in 0 ... self.resultJsonReview.count-1   {
                            //
                            //                self.detailMovieReviews_txt.text ?? "" +
                            //                self.resultJsonReview[i].stringValue
                            //
                            //
                            //
                            //            }
                            
                            
                            //print(self.resultJsonReview[0]["content"])
                            self.detailMovieReviews_txt.text = "Reviews : \n  "
                            
                            if (self.resultJsonReview.count != 0){
                                
                                for i in 0 ... self.resultJsonReview.count-1{
                                    self.detailMovieReviews_txt.text?.append("\(self.resultJsonReview[i]["content"].stringValue)")
                                    
                                    self.detailMovieReviews_txt.text?.append("\n Next review  \(self.resultJsonReview[i]["author"].stringValue) said : \n")
                                    
                                    
                                }
                                
                                
                            }else{
                                self.detailMovieReviews_txt.text = "No Available Reviews yet :("
                                
                                
                                
                            }
                            
                            
                            if(self.resultJsonVideo.count != 0){
                                
                                print("Available youtube videos \(self.resultJsonVideo.count)")
                                
                                
                                
                                
                                switch self.resultJsonVideo.count {
                                    
                                case 1:
                                    self.DetailMovieYoutube.load(withVideoId: self.resultJsonVideo[0]["key"].stringValue)
                                    break
                                case 2:
                                    self.DetailMovieYoutube.load(withVideoId: self.resultJsonVideo[0]["key"].stringValue)
                                    
                                    self.DetailMovieYoutube2.load(withVideoId: self.resultJsonVideo[1]["key"].stringValue)
                                    break
                                case 3...100 :
                                    self.DetailMovieYoutube.load(withVideoId: self.resultJsonVideo[0]["key"].stringValue)
                                    
                                    self.DetailMovieYoutube2.load(withVideoId: self.resultJsonVideo[1]["key"].stringValue)
                                    self.DetailMovieYoutube3.load(withVideoId: self.resultJsonVideo[2]["key"].stringValue)
                                    
                                    break
                                    
                                default:
                                    print("exhausted")
                                }
                                
                                
                                
                                
                            }else{
                                
                            }
                            
                            
                            
                            
                            
                            
                            
                            self.tableView.reloadData()
                            
                            
                            
                            
                        }
                        
                        
                        
                    }
                    
                    
                }
            
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
            } else {
                
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
            
            self.detailMovieReviews_txt.text = " No Connection"
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
}

