//
//  DeezerSearchViewController.swift
//  Deezer
//
//  Created by Dorian Cheignon on 05/11/2015.
//  Copyright © 2015 Dorian Cheignon. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation;

class DeezerSearchViewController: UIViewController,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,SearchCellDelegate,AVAudioPlayerDelegate{
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var SearchData:[Search]?
    var AlbumData:[Album]?
    var TrackData:[Track]?
    var ArtistData:[Artist]?
    var PlaylistData:[Playlist]?
    var audioPlayer = AVAudioPlayer()
    var order : Order?
    var filter : Filter?
    var textEntered : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.searchBar.scopeButtonTitles = ["All","Album","Artist","Track","Playlist"]
        self.searchBar.showsScopeBar = true
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Editing Text
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.textEntered = searchText
        Client.sharedClient.searchWithText(text: searchText, result:
            { (result) -> Void in
                if let searchdate = result as? [Search]{
                    self.SearchData = searchdate
                }else if let albumdata = result as? [Album]{
                    self.AlbumData = albumdata
                }
                else if let trackdata = result as? [Track]{
                    self.TrackData = trackdata
                }
                else if let artistdata = result as? [Artist]{
                    self.ArtistData = artistdata
                }
                else if let playlistdata = result as? [Playlist]{
                    self.PlaylistData = playlistdata
                }
                self.searchTableView.reloadData()
                self.searchTableView.reloadInputViews()

            }
            , withOrder: self.order, withFilter: self.filter)
    }
    func tableView( tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = searchTableView.dequeueReusableCellWithIdentifier("SearchCell") as! SearchCell
        cell.delegate = self
        cell.search = nil
        cell.album = nil
        cell.track  = nil
        cell.artist  = nil
        cell.playlist  = nil
        if self.filter != nil{
            
            switch(filter!){
                
            case .ARTIST:
                
                cell.artist = ArtistData?[indexPath.row]
                cell.title.text = ArtistData?[indexPath.row].name
                cell.iv.sd_setImageWithURL(ArtistData![indexPath.row].picture_medium!)
                break
            case .ALBUM:
                
                cell.album = AlbumData?[indexPath.row]
                cell.title.text = AlbumData?[indexPath.row].title
                cell.iv.sd_setImageWithURL(AlbumData![indexPath.row].cover_medium!)
                break
                
            case .TRACK:
                
                cell.track = TrackData?[indexPath.row]
                 cell.title.text = TrackData?[indexPath.row].title
                cell.iv.sd_setImageWithURL(TrackData![indexPath.row].album?.cover_medium!)

                break
                
            case .PLAYLIST:
                cell.playlist = PlaylistData?[indexPath.row]
                cell.title.text = PlaylistData?[indexPath.row].title
                cell.iv.sd_setImageWithURL(PlaylistData![indexPath.row].picture_medium!)
                break
            case .PODCAST:
                
                break
                
            }
            
        }else{
           
        cell.search = SearchData?[indexPath.row]

        cell.title.text = SearchData?[indexPath.row].title
        
        
        if let album = SearchData?[indexPath.row].album {
            cell.iv.sd_setImageWithURL(album.cover_medium!)
        }
        }
        
        
        return cell;
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if self.filter != nil{
            
            switch(filter!){
                
            case .ARTIST:
                if let count = self.ArtistData?.count{
                    return count
                }
                break
            case .ALBUM:
                if let count = self.AlbumData?.count{
                    return count
                }
                break
                
            case .TRACK:
                if let count = self.TrackData?.count{
                    return count
                }
                break
                
            case .PLAYLIST:
                if let count = self.PlaylistData?.count{
                    return count
                }
                break
            case .PODCAST:
                
                break
                
                
            }
            
        }else{
            if let count = self.SearchData?.count{
                return count
            }
        }
        return 0
        
    }
    
    // MARK: -Scope Button
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch(selectedScope){
        case 0:
            self.filter = nil
            break
        case 1:
            self.filter = Filter.ALBUM
            break
        case 2:
            self.filter = Filter.ARTIST
            break
        case 3:
            self.filter = Filter.TRACK
            break
        case 4:
            self.filter = Filter.PLAYLIST
            break
        default:
            self.filter = nil
            break
        }
        self.SearchData = [Search]()
        self.AlbumData = [Album]()
        self.TrackData = [Track]()
        self.PlaylistData = [Playlist]()
        self.searchTableView.reloadData()
        self.searchTableView.reloadInputViews()
        self.searchBar.delegate?.searchBar?(self.searchBar, textDidChange: self.textEntered)
        
    }
    
    // MARK: -SearchCellDelegate
    
    func searchDidPlayed(cell: SearchCell) {
        var preview = NSURL()
        if let url = cell.search?.preview{
            preview = url
            self.playSong(preview)
        }else if let url = cell.track?.preview{
            preview = url
            self.playSong(preview)
        }else if let url = cell.album?.tracks?.first?.preview{
            preview = url
            self.playSong(preview)
        }else if let tracklist = cell.playlist?.tracklist{
            Client.sharedClient.searchWithTrackList(tracklist, result: { (tracks) -> Void in
                if let preview = tracks.first?.preview{
                    self.playSong(preview)
                }
            })
        }else if let tracklist = cell.artist?.tracklist{
            
            Client.sharedClient.searchWithTrackList(tracklist, result: { (tracks) -> Void in
                if let preview = tracks.first?.preview{
                    self.playSong(preview)
                }
            })
            
        }
        
    }
    
    func playSong(preview:NSURL){
        do {
            
            
            if let datasound = NSData(contentsOfURL: preview){
                let stringPath =  NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory    , NSSearchPathDomainMask.AllDomainsMask, true)[0] + "/sound.mp3"
                datasound.writeToFile( stringPath, atomically: true)
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setActive(true)
                UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
                audioPlayer = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: stringPath))
                audioPlayer.prepareToPlay()
                audioPlayer.play()
                audioPlayer.volume = 1
                audioPlayer.delegate = self
                
            }
            
        }catch let error as NSError{
            print(error.description)
        }
    }
    
    func openTracklist(cell: SearchCell) {
        self.searchBar.selectedScopeButtonIndex = 3
        self.filter = .TRACK
        if let tracklist = cell.album?.tracklist{
            Client.sharedClient.searchWithTrackList(tracklist, result: { (tracks) -> Void in
                self.TrackData = tracks
                self.SearchData = [Search]()
                self.AlbumData = [Album]()
                self.searchTableView.reloadData()
                self.searchTableView.reloadInputViews()
            })
        }
        
    }
    
}
