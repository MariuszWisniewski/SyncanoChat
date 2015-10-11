//
//  ViewController.swift
//  SyncanoChat
//
//  Created by Mariusz Wisniewski on 2/8/15.
//  Copyright (c) 2015 Mariusz Wisniewski. All rights reserved.
//

import UIKit

class ViewController: JSQMessagesViewController, SyncanoSyncServerDelegate {
    
    var userName = ""
    var messages = [JSQMessage]()
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor(red: 10/255, green: 180/255, blue: 230/255, alpha: 1.0))
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.lightGrayColor())
    
    let syncano = Syncano(domain: "syncano-demo", apiKey: "5ed094cc48380a18b41beda32c62b7bb91321946")
    let syncServer = SyncanoSyncServer(domain: "syncano-demo", apiKey: "5ed094cc48380a18b41beda32c62b7bb91321946")
    let projectId = "5811"
    let collectionId = "18345"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let savedUserName = NSUserDefaults.standardUserDefaults().stringForKey("userName") {
            self.userName = savedUserName
        } else {
            self.userName = "user" + String(arc4random_uniform(UInt32.max))
            NSUserDefaults.standardUserDefaults().setObject(self.userName, forKey: "userName")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        self.senderDisplayName = self.userName
        self.senderId = self.userName
        
        let params = SyncanoParameters_DataObjects_Get(projectId: projectId, collectionId: self.collectionId)
        self.syncano .dataGet(params, callback: { response in
            if let messages = response.data {
                for object in messages {
                    let object = object as? SyncanoData
                    if let senderId = object?.additional?["senderId"] as? String, text = object?.text {
                        let message = JSQMessage(senderId: senderId, displayName: senderId, text: text)
                        self.messages += [message]
                    }
                }
            }
            self.finishReceivingMessage()
        })
        self.syncServer.delegate = self
        do {
            try self.syncServer.connect()
        } catch _ {
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        let data = self.messages[indexPath.row]
        return data
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let data = self.messages[indexPath.row]
        if (data.senderId == self.senderId) {
            return self.outgoingBubble
        } else {
            return self.incomingBubble
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        let newMessage = JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text)
        self.sendMessageToSyncano(newMessage)
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        
    }
    
    func sendMessageToSyncano(message: JSQMessage) {
        let params = SyncanoParameters_DataObjects_New(projectId: projectId, collectionId: collectionId, state: "Pending")
        params.text = message.text
        params.additional = ["senderId" : message.senderId]
        
        self.syncano.dataNew(params, callback: { response in
            if response.responseOK {
                self.messages += [message]
            }
            self.finishSendingMessage()
        })
    }
    
    func syncServerConnectionOpened(syncServer: SyncanoSyncServer!) {
        self.subscribeToCollection()
    }
    
    func syncServer(syncServer: SyncanoSyncServer!, connectionClosedWithError error: NSError!) {
        do {
            try self.syncServer.connect()
        } catch _ {
        }
    }
    
    func syncServer(syncServer: SyncanoSyncServer!, notificationAdded addedData: SyncanoData!, channel: SyncanoChannel!) {
        if let senderId = addedData.additional?["senderId"] as? String {
            if senderId == self.senderId {
                return
            }
            let message = JSQMessage(senderId: senderId, displayName: senderId, text: addedData.text)
            self.messages += [message]
        }
        self.finishReceivingMessage()
    }
    
    func subscribeToCollection() {
        let params = SyncanoParameters_Subscriptions_SubscribeCollection(projectId: projectId, collectionId: collectionId, context: "connection")
        self.syncServer.subscriptionSubscribeCollection(params) { response in
            //take care of errors here
            if (response.responseOK) {
            }
        }
    }
    
    override func textViewShouldEndEditing(textView: UITextView) -> Bool {
        return super.textViewShouldEndEditing(textView)
    }
    
    override func textViewDidEndEditing(textView: UITextView) {
        super.textViewDidEndEditing(textView)
    }
    
}
