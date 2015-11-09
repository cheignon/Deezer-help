//
//  SearchCell.swift
//  Deezer
//
//  Created by Dorian Cheignon on 05/11/2015.
//  Copyright © 2015 Dorian Cheignon. All rights reserved.
//

import UIKit
protocol SearchCellDelegate{
    
    func searchDidPlayed(cell:SearchCell)
    func openTracklist(cell:SearchCell)
    
}
class SearchCell: UITableViewCell {

    @IBOutlet weak var playButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var iv: UIImageView!
    @IBOutlet weak var title: UILabel!
    var search:Search?
    var album:Album?
    var track:Track?
    var artist:Artist?
    var playlist:Playlist?
    var delegate:SearchCellDelegate?
    
    @IBAction func buttonPlayDidTouched(sender:AnyObject){
        self.delegate?.searchDidPlayed(self)
    }
    
    func buttonActionDidTouched(sender:AnyObject){
        self.delegate?.openTracklist(self)
    }
    
}
