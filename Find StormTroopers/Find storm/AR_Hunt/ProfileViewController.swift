//
//  ProfileViewController.swift
//  Find Stormtrooper
//
//  Created by Xiuye Ding on 2017/5/1.
//

import UIKit

class ProfileViewController: UITableViewController {
  @IBOutlet weak var menuButton:UIBarButtonItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if self.revealViewController() != nil {
      menuButton.target = self.revealViewController()
      //menuButton.action = "revealToggle:"
      menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
      self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    // Return the number of sections.
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // Return the number of rows in the section.
    return 1
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsTableViewCell
    
    // Configure the cell...
    if indexPath.row == 0 {
      //cell.postImageView.image = UIImage(named: "watchkit-intro")
      cell.postImageView.image = UIImage(named: "astronaut-1")
      cell.postTitleLabel.text = "Hakunamatata"
      
      cell.collectionLabel.text = "Collection"
      //cell.postTitleLabel.text = "WatchKit Introduction: Building a Simple Guess Game"
      
      cell.authorLabel.text = "Jupiter"
      cell.authorImageView.image = UIImage(named: "jupiter")
      
      cell.star1Label.text = "Europa"
      cell.star1ImageView.image = UIImage(named:"europa")
      
      cell.star2Label.text = "Mercury"
      cell.star2ImageView.image = UIImage(named:"mercury")
      
      //cell.star3Label.text = "Mars"
      //cell.star3ImageView.image = UIImage(named:"mars")
      
      //cell.star4Label.text = "Moon"
      //cell.star4ImageView.image = UIImage(named:"moon-1")
      
    }
    
    return cell
  }
}
