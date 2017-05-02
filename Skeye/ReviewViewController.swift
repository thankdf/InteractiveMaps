//
//  ReviewViewController.swift
//  Skeye
//
//  Created by yoho chen on 4/19/17.
//  Copyright © 2017 Team_Parking. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var reviewTableView: UITableView!
    
    var reviews:[Review] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadReviews()
        
        //remove extra cell
        reviewTableView.tableFooterView = UIView()
        
        reviewTableView.estimatedRowHeight = reviewTableView.rowHeight
        reviewTableView.rowHeight = UITableViewAutomaticDimension
        
        reviewTableView.dataSource = self
        reviewTableView.delegate = self
 
        
    }
    
    
    //Return number of tableview row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    //Configure Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! ReviewTableViewCell
        let review = reviews[indexPath.row]
        cell.userName.text = review.username
        cell.userReview.text = review.comment
        cell.reviewTimeStapm.text = review.date
        cell.configureCellWith(row: indexPath.row)
        cell.reviewVC = self
        
        return cell
    }
    
    //Allow user to delete their own comment
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete{
                
                
                print("row : \(indexPath.row)  reviewID : \(reviews[indexPath.row].reviewID!)")
                
                deleteFromDB(for: reviews[indexPath.row].reviewID!)
                self.reviews.remove(at: indexPath.row)
                reviewTableView.deleteRows(at: [indexPath], with: .automatic)
                
               
            }
    }
    

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        //if reviews[indexPath.row].username == UserDefaults.standard.string(forKey: "username") || (UserDefaults.standard.string(forKey: "change this to check if they are event coordinator!!!"))
        if (reviews[indexPath.row].username == "Yoho Chen")
        {
            return .delete
        }
        else{
            return .none
        }
    }
    
    
    
    
    let backgroundView = UIView()
    
    var reviewImageView : UIImageView?
    
    let zoomImageView = UIImageView()

    
    //animation
    func animateImageview(reviewImage: UIImageView, startingFrame: CGRect){

        self.reviewImageView = reviewImage
        
        if let realStartingFrame = (reviewImage.superview?.convert(reviewImage.frame, to: nil))
        {
            reviewImage.alpha = 0
            
            backgroundView.frame = self.view.frame
            backgroundView.backgroundColor = UIColor.black
            backgroundView.alpha = 0
            view.addSubview(backgroundView)
            
            zoomImageView.frame = realStartingFrame
            zoomImageView.isUserInteractionEnabled = true
            zoomImageView.image = reviewImage.image
            zoomImageView.contentMode = .scaleAspectFill
            zoomImageView.clipsToBounds = false
            
            if((reviewImage.image?.size.width)! < (reviewImage.image?.size.height)!)
            {
                //vertical image
               zoomImageView.contentMode = .scaleAspectFill
            }
            else
            {
                //horizontal image
                zoomImageView.contentMode = .scaleAspectFit
            }
            view.addSubview(zoomImageView)
            
            zoomImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomOut)))
            backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomOut)))
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.01, options: .curveLinear , animations:
                {
                    let height = (self.view.frame.width / realStartingFrame.width) * realStartingFrame.height
                    let yPos = self.view.frame.height/2 - height/2
                    self.zoomImageView.frame = CGRect(x:0, y:yPos, width:self.view.frame.width, height: height)
                    
                    
                    self.backgroundView.alpha = 1
            }, completion: nil)
            
                   }
        
    }
    
    func zoomOut(){
        if let startingFrame = (reviewImageView!.superview?.convert(reviewImageView!.frame, to: nil))
        {
            UIView.animate(withDuration: 0.5, animations: { 
                self.zoomImageView.frame = startingFrame
                self.backgroundView.alpha = 0
            }, completion: { (didComplete) in
                self.zoomImageView.removeFromSuperview()
                self.backgroundView.removeFromSuperview()
                self.reviewImageView?.alpha = 1
            })
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addReview" {
            if let addReviewPopover = segue.destination as? AddReviewViewController {
                //addReviewPopover.modalPresentationStyle = UIModalPresentationStyle.formSheet
                // addReviewPopover.popoverPresentationController?.delegate = self
                
            }
        }
    }
    
//    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
//        return .none
//    }
    
    @IBAction func cancelToReviewViewController(segue:UIStoryboardSegue) {
    }
    
    //unwind method from Add Review page
    @IBAction func saveReviewDetail(segue:UIStoryboardSegue)
    {
        
        if let addReviewVC = segue.source as? AddReviewViewController
        {
            var reviewText = ""
            if addReviewVC.reviewTextView.textColor == UIColor.black
            {
                reviewText = addReviewVC.reviewTextView.text
            }
            let timeStamp = DateFormatter.localizedString(from: Date(), dateStyle: .full, timeStyle: .none)
            let reviewPic = addReviewVC.reviewImage
            let newReview = Review(comment: reviewText, photos: reviewPic, boothID: 187, date: timeStamp, username: "yoho@gmail.com")
            //let newReview = Review(comment: reviewText, photos: reviewPic, boothID: 187, date: timeStamp, username: UserDefaults.standard.string(forKey: "username"))
            
            //boothID and username need to be change above!!!
            
            //save to DB
            saveToDB(for: newReview)
            
            //update Table
            reviews.append(newReview)
                
            let indexPath = IndexPath(row: reviews.count-1, section: 0)
            reviewTableView.insertRows(at: [indexPath], with: .automatic)

        }

        
    }
    
    func loadReviews()
    {
        let ipAddress = "http://130.65.159.80/RetrieveReview.php"
        let url = URL(string: ipAddress)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        //use userdefault
        let boothID = 187
        let postString = "booth_id=\(boothID)"
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        URLSession.shared.dataTask(with: request, completionHandler:
        {
                (data, response, error) -> Void in
                if(error != nil)
                {
                    print("error=\(String(describing: error))\n")
                    return
                }
                do
                {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    
                    if let parseJSON = json
                    {
                        let resultStatus: String = parseJSON["status"] as! String
                        
                        if(resultStatus == "success")
                        {
                            let parseReviews = parseJSON["reviews"] as! [[String: Any]]
                            for review in parseReviews
                            {
                                let newReview: Review = Review.init(reviewID: Int(review["review_id"] as! String)!,
                                                                    comment: review["review"] as! String,
                                                                    photos: [nil],
                                                                    boothID: Int(review["booth_id"] as! String)!,
                                                                    date: review["date"] as! String,
                                                                    username: (review["first_name"] as! String)+" "+(review["last_name"] as! String))
                                
                                self.reviews.append(newReview)
                            }
                            DispatchQueue.main.async(){
                                self.reviewTableView.reloadData()
                            }
                            
    
                        }
                        else{
                            print("error: Retrieving review.")
                        }
                    }
                }
                catch let error as Error?
                {
                    print("Found an error - \(String(describing: error))")
                }
        }).resume()

        
    }
    
    func saveToDB(for review : Review)
    {
        let ipAddress = "http://130.65.159.80/SaveReview.php"
        let url = URL(string: ipAddress)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let postString = "booth_id=\(review.boothID)&review=\(review.comment)&date=\(review.date)&username=\(review.username)"
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        URLSession.shared.dataTask(with: request, completionHandler:
            {
                (data, response, error) -> Void in
                if(error != nil)
                {
                    print("error=\(String(describing: error))\n")
                    return
                }
                do
                {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary

                    if let parseJSON = json
                    {
                        let resultValue: String = parseJSON["status"] as! String
                        
                        if(resultValue == "success")
                        {
                           // print("result: \(resultValue)\n")

                        }
                    }
                }
                catch let error as Error?
                {
                    print("Found an error - \(String(describing: error))")
                }
        }).resume()

    }
    
    
    func deleteFromDB(for reviewID : Int)
    {
        let ipAddress = "http://130.65.159.80/DeleteReview.php"
        let url = URL(string: ipAddress)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let postString = "review_id=\(reviewID)"
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        URLSession.shared.dataTask(with: request, completionHandler:
            {
                (data, response, error) -> Void in
                if(error != nil)
                {
                    print("error=\(String(describing: error))\n")
                    return
                }
                do
                {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    
                    if let parseJSON = json
                    {
                        if(parseJSON["status"] as! String == "success")
                        {
                            print("Delete review successfully.")
                            print("sql = \(parseJSON["sql"] as! String)")
                            
                        }
                    }
                }
                catch let error as Error?
                {
                    print("Found an error for Delete - \(String(describing: error))")
                }
        }).resume()
        
    }

    

}
