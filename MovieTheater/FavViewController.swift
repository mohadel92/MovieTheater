//
//  FavViewController.swift
//  MovieTheater
//
//  Created by Mohammed Adel on 3/16/20.
//  Copyright © 2020 Mohammed Adel. All rights reserved.
//

import UIKit
import CoreData

class FavViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    
    var favMovieArray = [NSManagedObject]()
    
    
    
    
    
    
    
    
    
    

    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        DispatchQueue.main.async {
//            self.favtableview.reloadData()
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let manageContext = appDelegate.persistentContainer.viewContext as!
        NSManagedObjectContext
        
        let entity = NSEntityDescription.entity(forEntityName: "FavMovie", in: manageContext )
        
        let movie = NSManagedObject(entity: entity!, insertInto: manageContext)
        
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: "FavMovie")
        
        do{
         try   favMovieArray =  manageContext.fetch(fetchReq)
//            favtableview.reloadData()
            
        }catch let error{
            print(error)
        }
        
        
        
    }
    @IBOutlet weak var favtableview: UITableView!
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(favMovieArray[indexPath.row].value(forKey: "id"))
        
        
        
    }
    
    
    
    
    
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favMovieArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
        
    }
    
    
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
     
     // Configure the cell...
       
        
        
        if(self.favMovieArray[indexPath.row].value(forKey: "id") as? String != nil){
        cell.textLabel?.text =
            
        
            self.favMovieArray[indexPath.row].value(forKey: "title") as? String
            

        }
        
        return cell
       
     }
    
    
    
     // Override to support conditional editing of the table view.
      func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
    
    
    
     // Override to support editing the table view.
      func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let manageContext = appDelegate.persistentContainer.viewContext
        manageContext.delete(favMovieArray[indexPath.row])
    
       let fetchReq = NSFetchRequest<NSManagedObject>(entityName: "FavMovie")

        
        if(favMovieArray[indexPath.row].value(forKey: "id") as? String == nil){
            
        }
        else{
        let predicate = NSPredicate(format: "id == %@", favMovieArray[indexPath.row].value(forKey: "id") as! String )
        
        fetchReq.predicate = predicate
       
            do{
                try manageContext.save()
                print("Deleted Succes from fav")
                
                
            }catch let error{
                print(error)
            }
            
        }
    
        
        DispatchQueue.main.async {
               self.favMovieArray.remove(at: indexPath.row)
       self.favtableview.reloadData()
        }

          tableView.deleteRows(at: [indexPath], with: .fade)
        
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */


}
