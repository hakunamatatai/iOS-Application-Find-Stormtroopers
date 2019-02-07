//
//  NewsTableViewController.swift
//  Find Stormtrooper
//
//  Created by Hakunamatata on 2017/4/28.
//  Copyright (c) 2017 Xiuye Ding
//

//import Foundation
import UIKit

class NewsTableViewController: UITableViewController {
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
    return 3
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsTableViewCell
    
    // Configure the cell...
    if indexPath.row == 0 {
      //cell.postImageView.image = UIImage(named: "watchkit-intro")
      cell.postImageView.image = UIImage(named: "news1")
      
      cell.postTitleLabel.text = "Find Stormtrooper Game: A game for star wars funs!"
      //cell.postTitleLabel.text = "WatchKit Introduction: Building a Simple Guess Game"
      cell.authorLabel.text = "Yuchang Chen, Xiuye Ding"
      cell.authorImageView.image = UIImage(named: "white")
      
    } else if indexPath.row == 1 {
      //cell.postImageView.image = UIImage(named: "custom-segue-featured-1024")
      cell.postImageView.image = UIImage(named: "news2")
      cell.postTitleLabel.text = "Star Wars: Episode VII- The Force Awakens"
      cell.authorLabel.text = "Sina Movie"
      cell.authorImageView.image = UIImage(named: "appcoda-300")
      
    } else {
      //cell.postImageView.image = UIImage(named: "webkit-featured")
      cell.postImageView.image = UIImage(named: "news3")
      cell.postTitleLabel.text = "Star Wars movie: Star Wars 8: The Last Jedi will release in 2018"
      cell.authorLabel.text = "Sohu Entertainment"
      cell.authorImageView.image = UIImage(named: "batman")
      
    }
    
    return cell
  }
}
