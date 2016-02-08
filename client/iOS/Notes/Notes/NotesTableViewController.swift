//
//  NotesTableViewController.swift
//  Notes
//
//  Created by Mahbub Morshed on 1/7/16.
//  Copyright © 2016 Mahbub Morshed. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NotesTableViewController: UITableViewController {
    
    var notes = [Note]()
    var selectedNote: Note!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        enableRowAutosizing()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "retrieveNotes", name: "newnotecreated", object: nil)
        retrieveNotes()
    }
    
    
    func enableRowAutosizing(){
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
}


// MARK: - Table view data source
extension NotesTableViewController{
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notes.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("notesList", forIndexPath: indexPath) as! NotesListCellTableViewCell
        
        let note = self.notes[indexPath.row]
        cell.NoteTitle.text = note.title
        cell.NoteDetails.text = note.description
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedNote = self.notes[indexPath.row]
        performSegueWithIdentifier("Show Detail", sender: self)
    }
    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 80.0
//    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let note:Note = self.notes[indexPath.row]
            
            deleteNote(note.id)
            print("deleting note with title \(note.title) and id \(note.id)")
            
            self.notes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
}


// MARK: - Web service related codes
extension NotesTableViewController{
    func retrieveNotes(){
        Alamofire.request(.GET, "http://localhost:8888/notes/").validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print("JSON: \(json)")
                    
                    
                    
                    if json.count > 0{
                        self.notes.removeAll()
                        
                        for i in 0...json.count-1{
                            let id = json[i]["id"].string
                            let title = json[i]["title"].string
                            let description = json[i]["note"].string
                            print("title is \(title)")
                            
                            let note:Note = Note(id:id!, title: title!, description: description!)
                            self.notes.append(note)
                            
                        }
                    }
                    self.tableView.reloadData()
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    func deleteNote(noteId:String){
        Alamofire.request(.POST, "http://localhost:8888/notes/", parameters: ["delete":noteId]).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print("JSON: \(json)")
                    
                    if json.count > 0{
                        NSNotificationCenter.defaultCenter().postNotificationName("newnotecreated", object: self)
                    }
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - Navigation
extension NotesTableViewController{
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Show Detail"{
            let navigationVC:UINavigationController = segue.destinationViewController as! UINavigationController
            
            let detailViewController:DetailViewController = navigationVC.topViewController as! DetailViewController
            detailViewController.selectedNote = self.selectedNote
            
        }
    }
}
