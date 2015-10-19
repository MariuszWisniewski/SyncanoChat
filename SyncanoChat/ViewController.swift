//
//  ViewController.swift
//  SyncanoChat
//
//  Created by Mariusz Wisniewski on 10/19/15.
//  Copyright © 2015 Mariusz Wisniewski. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import syncano_ios

class ViewController: JSQMessagesViewController {
    
    let channel = SCChannel(name: syncanoChannelName)
    
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor(red: 10/255, green: 180/255, blue: 230/255, alpha: 1.0))
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.lightGrayColor())
    var messages = [JSQMessage]()
    
    let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(loginViewControllerIdentifier) as! LoginViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setup()
        self.downloadNewestMessagesFromSyncano()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.showLoginViewControllerIfNotLoggedIn()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadMessagesView() {
        self.collectionView?.reloadData()
    }
    
    func reloadAllMessages() {
        self.messages = []
        self.reloadMessagesView()
        self.downloadNewestMessagesFromSyncano()
    }
}

//MARK - Setup
extension ViewController {
    func setup() {
        self.title = "Syncano ChatApp"
        self.setupSenderData()
        self.channel.delegate = self
        self.channel.subscribeToChannel()
        self.loginViewController.delegate = self
    }
    
    func setupSenderData() {
        let sender = (SCUser.currentUser() != nil) ? SCUser.currentUser().username : ""
        self.senderId = sender
        self.senderDisplayName = sender
    }
}

//MARK - Data Source
extension ViewController {
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        let data = self.messages[indexPath.row]
        return data
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didDeleteMessageAtIndexPath indexPath: NSIndexPath!) {
        self.messages.removeAtIndex(indexPath.row)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let data = messages[indexPath.row]
        switch(data.senderId) {
        case self.senderId:
            return self.outgoingBubble
        default:
            return self.incomingBubble
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let data = self.collectionView(self.collectionView, messageDataForItemAtIndexPath: indexPath)
        if (self.senderDisplayName == data.senderDisplayName()) {
            return nil
        }
        return NSAttributedString(string: data.senderDisplayName())
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let data = self.collectionView(self.collectionView, messageDataForItemAtIndexPath: indexPath)
        if (self.senderDisplayName == data.senderDisplayName()) {
            return 0.0
        }
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
}

//MARK - Toolbar
extension ViewController {
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        self.messages += [message]
        self.sendMessageToSyncano(message)
        self.finishSendingMessage()
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        
    }
}

//MARK - Syncano
extension ViewController {
    
    func sendMessageToSyncano(message: JSQMessage) {
        let messageToSend = Message()
        messageToSend.text = message.text
        messageToSend.senderId = self.senderId
        messageToSend.channel = syncanoChannelName
        messageToSend.other_permissions = .Full
        messageToSend.saveWithCompletionBlock { error in
            if (error != nil) {
                //Super cool error handling
            }
        }
    }
    
    func downloadNewestMessagesFromSyncano() {
        Message.please().giveMeDataObjectsWithCompletion { objects, error in
            if let messages = objects as? [Message]! {
                self.messages = self.jsqMessagesFromSyncanoMessages(messages)
                self.finishReceivingMessage()
            }
        }
    }
    
    func jsqMessageFromSyncanoMessage(message: Message) -> JSQMessage {
        let jsqMessage = JSQMessage(senderId: message.senderId, senderDisplayName: message.senderId, date: message.created_at, text: message.text)
        return jsqMessage
    }
    
    func jsqMessagesFromSyncanoMessages(messages: [Message]) -> [JSQMessage] {
        var jsqMessages : [JSQMessage] = []
        for message in messages {
            jsqMessages.append(self.jsqMessageFromSyncanoMessage(message))
        }
        return jsqMessages
    }
}

//MARK - Channels
extension ViewController : SCChannelDelegate {
    
    func addMessageFromNotification(notification: SCChannelNotificationMessage) {
        let message = Message(fromDictionary: notification.payload)
        if message.senderId == self.senderId {
            //we don't need to add messages from ourselves
            return
        }
        self.messages.append(self.jsqMessageFromSyncanoMessage(message))
        self.finishReceivingMessage()
    }
    
    func updateMessageFromNotification(notification: SCChannelNotificationMessage) {
        
    }
    
    func deleteMessageFromNotification(notification: SCChannelNotificationMessage) {
        
    }
    
    func chanellDidReceivedNotificationMessage(notificationMessage: SCChannelNotificationMessage!) {
        switch(notificationMessage.action) {
        case .Create:
            self.addMessageFromNotification(notificationMessage)
        case .Delete:
            self.deleteMessageFromNotification(notificationMessage)
        case .Update:
            self.updateMessageFromNotification(notificationMessage)
        default:
            break
        }
    }
}

//MARK - Login Logic
extension ViewController : LoginDelegate {
    func didSignUp() {
        self.prepareAppForNewUser()
        self.hideLoginViewController()
        
    }
    
    func didLogin() {
        self.prepareAppForNewUser()
        self.hideLoginViewController()
    }
    
    func prepareAppForNewUser() {
        self.setupSenderData()
        self.reloadAllMessages()
    }
    
    func isLoggedIn() -> Bool {
        let isLoggedIn = (SCUser.currentUser() != nil)
        return isLoggedIn
    }
    
    func logout() {
        SCUser.currentUser()?.logout()
    }
    
    func showLoginViewController() {
        self.presentViewController(self.loginViewController, animated: true) {
            
        }
    }
    
    func hideLoginViewController() {
        self.dismissViewControllerAnimated(true) {
            
        }
    }
    
    func showLoginViewControllerIfNotLoggedIn() {
        if (self.isLoggedIn() == false) {
            self.showLoginViewController()
        }
    }
    
    @IBAction func logoutPressed(sender: UIBarButtonItem) {
        self.logout()
        self.showLoginViewControllerIfNotLoggedIn()
    }
}
