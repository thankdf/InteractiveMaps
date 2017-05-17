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
    
    var thisBoothID = 0
    
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
        
        // update image for each cell
        if(review.photos.count < 1){
            cell.noPhotoLabel.isHidden = false
        }
        else{
            cell.noPhotoLabel.isHidden = true
            for index in 0..<review.photos.count
            {
                
                if(index == 0)
                {
                    if let img = review.photos[index]
                    {
                        cell.reviewImage1.isUserInteractionEnabled = true
                        
                        cell.reviewImage1.image = img
                    }
                }
                else if(index == 1)
                {
                    if let img = review.photos[index]
                    {
                        cell.reviewImage2.isUserInteractionEnabled = true
                        cell.reviewImage2.image = img
                        
                    }
                }
                else{
                    if let img = review.photos[index]
                    {
                        cell.reviewImage3.isUserInteractionEnabled = true
                        cell.reviewImage3.image = img
                    }
                }
                
            }
            
        }
        
        cell.reviewVC = self
        return cell
    }
    
    //Actually executing delete action
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            
            print("row : \(indexPath.row)  reviewID : \(reviews[indexPath.row].reviewID!)")
            
            deleteFromDB(for: reviews[indexPath.row].reviewID!)
            self.reviews.remove(at: indexPath.row)
            reviewTableView.deleteRows(at: [indexPath], with: .automatic)
            
            
        }
    }
    
    //Allow user to delete their own comment
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        //if reviews[indexPath.row].username == UserDefaults.standard.string(forKey: "username") || (UserDefaults.standard.string(forKey: "change this to check if they are event coordinator!!!"))
        if (reviews[indexPath.row].username == UserDefaults.standard.string(forKey: "name")!)
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
    
    
    //animation for zooming image
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
    
    //zoom out image
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
                
                
            }
        }
    }
    
    //unwind method from add review page
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
            
            var reviewImages:[UIImage?] = []
            for tempImage in addReviewVC.reviewImage
            {
                if(tempImage != nil)
                {
                    reviewImages.append(tempImage)
                }
                
            }
            
            //let newReview = Review(comment: reviewText, photos: reviewImages, boothID: 201, date: timeStamp, username: "yoho@gmail.com")
            let newReview = Review(comment: reviewText, photos: reviewImages, boothID: thisBoothID, date: timeStamp, username: UserDefaults.standard.string(forKey: "username")!)
            
            //boothID and username need to be change above!!!
            
            
            //saving to database
            saveToDB2(for: newReview)
            
            //update Table
            newReview.setUserName(newName: UserDefaults.standard.string(forKey: "name")!)
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
        let boothID = thisBoothID
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
                            var arrayToBeSaved:[UIImage] = []
                            //load image from server
                            for review in parseReviews
                            {
                                
                                let imgURL0 = "http://130.65.159.80/images/review\(review["review_id"] as! String)img0.jpg"
                                let imgURL1 = "http://130.65.159.80/images/review\(review["review_id"] as! String)img1.jpg"
                                let imgURL2 = "http://130.65.159.80/images/review\(review["review_id"] as! String)img2.jpg"
                                let urlArray = [imgURL0,imgURL1,imgURL2]
                                
                                for eachURL in urlArray
                                {
                                    if let url = URL(string: eachURL) {
                                        
                                        if let data = NSData(contentsOf: url as URL){
                                            if let downloadedImg = UIImage(data: data as Data) {
                                                arrayToBeSaved.append(downloadedImg)
                                            }
                                        }
                                    }
                                }
                                
                                
                                //load data from MySQL
                                
                                let newReview: Review = Review.init(reviewID: Int(review["review_id"] as! String)!,
                                                                    comment: review["review"] as! String,
                                                                    photos: arrayToBeSaved,
                                                                    boothID: Int(review["booth_id"] as! String)!,
                                                                    date: review["date"] as! String,
                                                                    username: (review["first_name"] as! String)+" "+(review["last_name"] as! String))
                                
                                self.reviews.append(newReview)
                                arrayToBeSaved = []
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
    
    // method for constructing request body
    func createBodyWithParameters(parameters: NSMutableDictionary?,  boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters!
            {
                
                if(value is String || value is NSString)
                {
                    body.appendString("--\(boundary)\r\n")
                    body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                    body.appendString("\(value)\r\n")
                }
                else if(value is [UIImage]){
                    var i = 0;
                    
                    for image in value as! [UIImage]{
                        
                        let filename = "image\(i).jpg"
                        let data = UIImageJPEGRepresentation(image,0.5);
                        let mimetype = "image/jpg"
                        let filePathKey = "file" + String(i)
                        
                        
                        body.appendString("--\(boundary)\r\n")
                        // body.appendString("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n")
                        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n")
                        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
                        body.append(data! as Data)
                        body.appendString("\r\n")
                        i = i+1;
                    }
                    
                    
                }
            }
        }
        
        body.appendString("--\(boundary)--\r\n")
        
        print("Uploading \(body as Data) byte")
        
        return body
    }
    
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    
    
    func saveToDB2(for review : Review)
    {
        
        let myUrl = NSURL(string: "http://130.65.159.80/SaveReview2.php");
        
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";
        
        let param = [
            "booth_id"   : "\(review.boothID)",
            "review"     : "\(review.comment)",
            "date"       : "\(review.date)",
            "username"   : "\(review.username)",
            "images"     : review.photos
            
            ] as NSMutableDictionary
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = createBodyWithParameters(parameters: param, boundary: boundary) as Data
        
        
        //myActivityIndicator.startAnimating();
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            // You can print out response object
            //print("******* response = \(response)")
            
            // Print out reponse body
            //let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            //print("****** response data = \(responseString!)")
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                
                //               print(json)
                
                //                dispatch_async(dispatch_get_main_queue(),{
                //                    self.myActivityIndicator.stopAnimating()
                //                    self.myImageView.image = nil;
                //                });
                
            }catch
            {
                print(error)
            }
            
        }
        
        task.resume()
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
                            //print("Delete review successfully.")
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

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
