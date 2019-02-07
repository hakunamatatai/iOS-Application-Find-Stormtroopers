//
//  NewsTableViewCell.swift
//  Find Stormtrooper
//
//  Created by Hakunamatata on 2017/4/28.
//  Copyright (c) 2017 Xiuye Ding
//

import UIKit

class NewsTableViewCell: UITableViewCell {
  
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTitleLabel: UILabel!
  
    @IBOutlet weak var collectionLabel: UILabel!
  
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    
    
    @IBOutlet weak var star1ImageView: UIImageView!
    @IBOutlet weak var star1Label: UILabel!
    

    @IBOutlet weak var star2ImageView: UIImageView!
    @IBOutlet weak var star2Label: UILabel!
    
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
}
