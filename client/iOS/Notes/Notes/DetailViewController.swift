//
//  DetailViewController.swift
//  Notes
//
//  Created by Mahbub Morshed on 1/7/16.
//  Copyright © 2016 Mahbub Morshed. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DetailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate{


    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var noteDetailTextView: UITextView!
    

    
    var selectedNote:Note!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.setCurrentScreenType()
        drawBottomLine(self.titleTextView)
    }
    
    func setCurrentScreenType(){
        if selectedNote != nil{
            self.titleTextView.text = selectedNote.title
            self.noteDetailTextView.text = selectedNote.description
        }else{
            self.title = "Create New"
            self.startEditingNote(self)
        }
    }
    
    func saveNote() {
        self.titleTextView.resignFirstResponder()
        self.noteDetailTextView.resignFirstResponder()
        
        showEditButtonInNavigationItem()
        
        
        if selectedNote != nil{
            updateNotes(self.selectedNote.id, noteTitle: self.titleTextView.text, noteDescription: self.noteDetailTextView.text)
        }else{
            saveNotes(self.titleTextView.text, noteDescription: self.noteDetailTextView.text)
        }
    }
    
    
    @IBAction func startEditingNote(sender: AnyObject) {
        self.titleTextView.editable = true
        self.noteDetailTextView.editable = true
        
        self.titleTextView.becomeFirstResponder()
    }
}


// MARK : - Decoration for UITextView
extension DetailViewController{
    func drawBottomLine(textView: UITextView!){
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRectMake(0.0, textView.frame.size.height - 1, textView.frame.size.width, 0.5);
        bottomBorder.backgroundColor = UIColor.grayColor().CGColor
        titleTextView.layer.addSublayer(bottomBorder)
    }
}


// MARK: - Button type in Navigation Controller
extension DetailViewController{
    func showSaveButtonInNavigationItem(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action:"saveNote");
    }
    
    func showEditButtonInNavigationItem(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action:"startEditingNote:");
    }
}

// MARK: - TextView Delegate
extension DetailViewController{
    func textViewDidBeginEditing(textView: UITextView){
        if textView.text == "Your title here" || textView.text == "Your note here"{
            textView.text = ""
        }
        showSaveButtonInNavigationItem()
    }
}


// MARK: - Network Call
extension DetailViewController{
    func saveNotes(noteTitle:String, noteDescription:String){
        Alamofire.request(.POST, "http://localhost:8888/notes/", parameters: ["title":noteTitle, "description": noteDescription]).validate().responseJSON { response in
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
    
    
    func updateNotes(noteId:String, noteTitle:String, noteDescription:String){
        Alamofire.request(.PUT, "http://localhost:8888/notes/", parameters: ["id":noteId, "title":noteTitle, "description": noteDescription]).validate().responseJSON { response in
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
