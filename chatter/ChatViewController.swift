//
//  ChatViewController.swift
//  chatter
//
//  Created by William Falk-Wallace on 2/18/15.
//  Copyright (c) 2015 Falk-Wallace. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var messages: NSMutableArray = []
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatTableView.dataSource = self
        onTimer()
        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "onTimer", userInfo: nil, repeats: true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendTapped(sender: AnyObject) {
        var message = PFObject(className: "Message")
        message["text"] = messageTextField.text
        messageTextField.text = nil
        message.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                self.messages.insertObject(message, atIndex: 0)
                self.chatTableView.reloadData()
            } else {
                println("error")
            }
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = chatTableView.dequeueReusableCellWithIdentifier("com.chatter.MessageCell") as MessageTableViewCell
        // cell.usernameLabel.text = messages[indexPath.row]["user"]["username"]
        cell.messageLabel.text = messages[indexPath.row]["text"] as String
        return cell
    }
    
    func onTimer() {
        var query = PFQuery(className: "Message")
        query.orderByDescending("createdAt")
        query.includeKey("user")
        query.findObjectsInBackgroundWithBlock { (messages, error) -> Void in
            self.messages = NSMutableArray(array: messages)
            println(messages)
            self.chatTableView.reloadData()
        }
        
    }
    
    
    
}
