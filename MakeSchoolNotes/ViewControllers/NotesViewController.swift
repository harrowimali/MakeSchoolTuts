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
 
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    
    // Do any additional setup after loading the view, typically from a nib.

    do{
        let realm = try Realm()
        notes = realm.objects(Note).sorted("modificationDate", ascending: false)
    }
    catch{
        print("handle error")
    }
    
    tableView.dataSource = self
    tableView.delegate = self

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
  
}

extension NotesViewController {
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NoteCell", forIndexPath: indexPath) as! NoteTableViewCell //1
        
//        cell.title.text = "Note"
  //      cell.date.text = "Date"
    
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
        //selectedNote = notes[indexPath.row]
        //self.performSegueWithIdentifier("ShowExistingNote", sender: self)
        /* from the end of 4, not sure what the fuck I'm supposed to do with those
        DIRE:
         Can you add a selectedNote variable to the class to store the selected Note? Hint you need to uncomment the first commented line so the selectedNote can be assigned.
         */
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