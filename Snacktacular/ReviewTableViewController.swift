//
//  ReviewTableViewController.swift
//  Snacktacular
//
//  Created by Isabelle Smyth on 11/10/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import UIKit

class ReviewTableViewController: UITableViewController {
    var rating = 0 {
        didSet{
            for starButton in starButtonCollection {
                let image = UIImage(named: (starButton.tag < rating ? "star-filled": "star-empty"))
                starButton.setImage(image, for: .normal)
                
            }
            print(">>>>>new rating \(rating)")
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    @IBOutlet weak var reviewTitle: UITextField!
    
    @IBOutlet weak var reviewView: UITextView!
    @IBOutlet weak var postedByLabel: UILabel!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var buttonBackgroundView: UIView!
    
    @IBOutlet weak var reviewDateLabel: UILabel!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)

    }
    @IBOutlet var starButtonCollection: [UIButton]!
    
    
    @IBAction func starButtonPressed(_ sender: UIButton) {
        rating = sender.tag + 1
        
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
    }
    @IBAction func returnTitleDonePressed(_ sender: UITextField) {
    }
    
    @IBAction func reviewTitleChanged(_ sender: UITextField) {
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
               if isPresentingInAddMode {
                   dismiss(animated: true, completion: nil)
               } else {
                   navigationController?.popViewController(animated: true)
               }
    }
    @IBAction func cancelButtonPressed(_ sender: Any) {
        leaveViewController()
    }
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
    }
    
}
