//
//  NoteDisplayViewController.swift
//  MakeSchoolNotes
//
//  Created by Ali Malik on 4/14/16.
//  Copyright © 2016 Chris Orcutt. All rights reserved.
//
import Foundation
import RealmSwift
import UIKit

class NoteDisplayViewController: UIViewController {
    
    @IBOutlet weak var titleTextfield: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    var note: Note?{
        didSet{
            displayNote(note)
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        //is called every time the view is about to be displayed to ensure it is always refreshed. 
        super.viewWillAppear(animated)
        
        displayNote(note)
    }
    
    

    func displayNote(note: Note?){
        if let note = note, titleTextfield = titleTextfield, contentTextView = contentTextView{
            titleTextfield.text = note.title
            contentTextView.text = note.content
        }
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        saveNote()
    }
    
    func saveNote(){
        if let note = note{
            do{
                let realm = try Realm()
                
                try realm.write{
                    if(note.title != self.titleTextfield.text || note.content != self.contentTextView.text){
                        note.title = self.titleTextfield.text!
                        note.content = self.contentTextView.text
                        note.modificationDate = NSDate()
                    }
                }
            }
            
            catch{
                print("handle error")
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
