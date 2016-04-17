//
//  NotesViewController.swift
//  MakeSchoolNotes
//
//  Created by Martin Walsh on 29/05/2015.
//  Updated by Chris Orcutt on 09/07/2015.
//  Copyright © 2015 MakeSchool. All rights reserved.
//

import UIKit
import RealmSwift

class NotesViewController: UITableViewController {
    
    
    var selectedNote: Note?
  
    override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    // Do any additional setup after loading the view, typically from a nib.

}
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        do{
            let realm = try Realm()
            notes = realm.objects(Note).sorted("modificationDate",ascending: false)
        }
        catch{
            print("Handle Error")
        }
        
    }
    
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
    
    
    var notes: Results<Note>!{
        didSet{
            //notes update --> Update table view
            tableView?.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowExistingNote") {
            let noteViewController = segue.destinationViewController as! NoteDisplayViewController
            noteViewController.note = selectedNote
        }
    }
}

extension NotesViewController {
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NoteCell", forIndexPath: indexPath) as! NoteTableViewCell
        let row = indexPath.row
        let note = notes[row] as Note
        cell.note = note
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes?.count ?? 0
    }
    
    
    @IBAction func unwindToSegue(segue: UIStoryboardSegue){
        //the function above is from realm and allows stacking
        
        if let identifier = segue.identifier{
            
            do {
                let realm = try Realm()
                
                switch identifier {
                    
                case "Save":

                    let source = segue.sourceViewController as! NewNoteViewController
                    try realm.write() {
                        realm.add(source.currentNote!)
                    }
                    
                case "Delete":
                    
                    
                    try realm.write() {
                        realm.delete(self.selectedNote!)
                    }
                    
                    let source = segue.sourceViewController as! NoteDisplayViewController
                    source.note = nil;
                    
                    
                default:
                    print("No one loves \(identifier)")
                    
                }
                
                notes = realm.objects(Note).sorted("modificationDate", ascending: false)
            } catch {
                print("handle error")
            }
        }
        
             }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        selectedNote = notes[indexPath.row]
        self.performSegueWithIdentifier("ShowExistingNote", sender: self)

    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool{
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        if editingStyle == .Delete{
            let note = notes[indexPath.row] as Object
            
            do{
                let realm = try Realm()
                try realm.write(){
                    realm.delete(note)
                }
                notes = realm.objects(Note).sorted("modificationDate", ascending: false)
            }
            catch{
                print("handle error")
            }
        }
    
    
    }

    
    

}