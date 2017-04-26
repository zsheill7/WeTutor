/*
 * Copyright (c) 2017 Zoe Sheill
 *
 */

import UIKit
import Photos
import Firebase
import JSQMessagesViewController

final class ChatViewController: JSQMessagesViewController {
  
  // MARK: Properties
  fileprivate let imageURLNotSetKey = "NOTSET"
  
  var channelRef: FIRDatabaseReference?

  fileprivate lazy var messageRef: FIRDatabaseReference = self.channelRef!.child("messages")
  fileprivate lazy var storageRef: FIRStorageReference = FIRStorage.storage().reference(forURL: "gs://tutorme-e7292.appspot.com")
  fileprivate lazy var userIsTypingRef: FIRDatabaseReference = self.channelRef!.child("typingIndicator").child(self.senderId)
  fileprivate lazy var usersTypingQuery: FIRDatabaseQuery = self.channelRef!.child("typingIndicator").queryOrderedByValue().queryEqual(toValue: true)

  fileprivate var newMessageRefHandle: FIRDatabaseHandle?
  fileprivate var updatedMessageRefHandle: FIRDatabaseHandle?
  
  fileprivate var messages: [JSQMessage] = []
  fileprivate var photoMessageMap = [String: JSQPhotoMediaItem]()
  
  fileprivate var localTyping = false
  var channel: Channel? {
    didSet {
      title = channel?.name
    }
  }
  var isTyping: Bool {
    get {
      return localTyping
    }
    set {
      localTyping = newValue
      userIsTypingRef.setValue(newValue)
    }
  }
  
  lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
  lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
  
  // MARK: View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.senderId = FIRAuth.auth()?.currentUser?.uid
    //self.senderDisplayName = FIRAuth.auth()?.currentUser?.uid
    
    print("channelRef")
    print(channelRef)

    observeMessages()
    collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
    collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    observeTyping()
  }
  
  deinit {
    if let refHandle = newMessageRefHandle {
      messageRef.removeObserver(withHandle: refHandle)
    }
    if let refHandle = updatedMessageRefHandle {
      messageRef.removeObserver(withHandle: refHandle)
    }
  }
  
  // MARK: Collection view data source (and related) methods
  
  override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
    return messages[indexPath.item]
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return messages.count
  }
  
  override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
    let message = messages[indexPath.item]
    if message.senderId == senderId {
      return outgoingBubbleImageView
    } else {
      return incomingBubbleImageView
    }
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
    
    let message = messages[indexPath.item]
    
    if message.senderId == senderId {
      cell.textView?.textColor = UIColor.white
    } else {
      cell.textView?.textColor = UIColor.black
    }
    
    return cell
  }
  
  override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
    return nil
  }
  
  override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
    return 15
  }
  
  override func collectionView(_ collectionView: JSQMessagesCollectionView?, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString? {
    let message = messages[indexPath.item]
    switch message.senderId {
    case senderId:
      return nil
    default:
      guard let senderDisplayName = message.senderDisplayName else {
        assertionFailure()
        return nil
      }
      return NSAttributedString(string: senderDisplayName)
    }
  }

  // MARK: Firebase related methods
  
  fileprivate func observeMessages() {
    messageRef = channelRef!.child("messages")//FIRDatabase.database().reference().child("messages")
    let messageQuery = messageRef.queryLimited(toLast:25)
    
    // We can use the observe method to listen for new
    // messages being written to the Firebase DB
    newMessageRefHandle = messageQuery.observe(.childAdded, with: { (snapshot) -> Void in
      let messageData = snapshot.value as! Dictionary<String, String>

      if let id = messageData["senderId"] as String!, let name = messageData["senderName"] as String!, let text = messageData["text"] as String!, text.characters.count > 0 {
        self.addMessage(withId: id, name: name, text: text)
        self.finishReceivingMessage()
      } else if let id = messageData["senderId"] as String!, let photoURL = messageData["photoURL"] as String! {
        if let mediaItem = JSQPhotoMediaItem(maskAsOutgoing: id == self.senderId) {
          self.addPhotoMessage(withId: id, key: snapshot.key, mediaItem: mediaItem)
          
          if photoURL.hasPrefix("gs://") {
            self.fetchImageDataAtURL(photoURL, forMediaItem: mediaItem, clearsPhotoMessageMapOnSuccessForKey: nil)
          }
        }
      } else {
        print("Error! Could not decode message data")
      }
    })
    
    // We can also use the observer method to listen for
    // changes to existing messages.
    // We use this to be notified when a photo has been stored
    // to the Firebase Storage, so we can update the message data
    updatedMessageRefHandle = messageRef.observe(.childChanged, with: { (snapshot) in
      let key = snapshot.key
      let messageData = snapshot.value as! Dictionary<String, String>
      
      if let photoURL = messageData["photoURL"] as String! {
        // The photo has been updated.
        if let mediaItem = self.photoMessageMap[key] {
          self.fetchImageDataAtURL(photoURL, forMediaItem: mediaItem, clearsPhotoMessageMapOnSuccessForKey: key)
        }
      }
    })
  }
  
  fileprivate func fetchImageDataAtURL(_ photoURL: String, forMediaItem mediaItem: JSQPhotoMediaItem, clearsPhotoMessageMapOnSuccessForKey key: String?) {
    let storageRef = FIRStorage.storage().reference(forURL: photoURL)
    storageRef.data(withMaxSize: INT64_MAX){ (data, error) in
      if let error = error {
        print("Error downloading image data: \(error)")
        return
      }
      
      storageRef.metadata(completion: { (metadata, metadataErr) in
        if let error = metadataErr {
          print("Error downloading metadata: \(error)")
          return
        }
        
        if (metadata?.contentType == "image/gif") {
          mediaItem.image = UIImage.gifWithData(data!)
        } else {
          mediaItem.image = UIImage.init(data: data!)
        }
        self.collectionView.reloadData()
        
        guard key != nil else {
          return
        }
        self.photoMessageMap.removeValue(forKey: key!)
      })
    }
  }
  
  fileprivate func observeTyping() {
    //let newRef = channelRef!
    let typingIndicatorRef = channelRef!.child("typingIndicator")
    userIsTypingRef = typingIndicatorRef.child(senderId)
    userIsTypingRef.onDisconnectRemoveValue()
    usersTypingQuery = typingIndicatorRef.queryOrderedByValue().queryEqual(toValue: true)
    
    usersTypingQuery.observe(.value) { (data: FIRDataSnapshot) in
      
      // You're the only typing, don't show the indicator
      if data.childrenCount == 1 && self.isTyping {
        return
      }

      self.showTypingIndicator = data.childrenCount > 0
      self.scrollToBottom(animated: true)
    }
  }
  
  override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {

    let itemRef = messageRef.childByAutoId()
    

    print(senderId!)
    print(senderDisplayName!)
    print(text!)

    
    let messageItem = [
      "senderId": senderId!,
      "senderName": senderDisplayName!,
      "text": text!,
      //"timestamp": timestamp
    ] //as [String : Any]
    

    itemRef.setValue(messageItem)
    //let userRef = FIRDatabase.database().reference().child("users").child(senderId).child(")
    //let recentMessageTextReference = FIRDatabase.database().reference().child("users").child(senderId).child("recentMessageText")
   // let recentMessageTimestampReference = FIRDatabase.database().reference().child("users").child(senderId).child("recentMessageTimestamp")
    
    let recentMessageSenderRef = FIRDatabase.database().reference().child("users").child(senderId)
    recentMessageSenderRef.child("recentMessageText").setValue(text!)
     //recentMessageSenderRef.child("recentMessageTimestamp").setValue(timestamp)
    
    /*recentMessageTextReference.setValue(text!)
    recentMessageTimestampReference.setValue(timestamp)*/
    
    JSQSystemSoundPlayer.jsq_playMessageSentSound()
    
    print("in didPressSend")

    finishSendingMessage()
    isTyping = false
    
    //To see if a user sent a message.  We can count the number of times this happens to see how many messages are sent over time
   FIRAnalytics.logEvent(withName: "did_send_message", parameters: [
    "current_user": senderId! as NSObject,
    //"current_user_is_tutor": currentUser.isTutor! as NSObject
    ])
    
  }
    
    
  
  func sendPhotoMessage() -> String? {
    let itemRef = messageRef.childByAutoId()
    
    let messageItem = [
      "photoURL": imageURLNotSetKey,
      "senderId": senderId!,
      ]
    
    itemRef.setValue(messageItem)
    
    
    JSQSystemSoundPlayer.jsq_playMessageSentSound()
    
    finishSendingMessage()
    return itemRef.key
  }
    
    
  func setImageURL(_ url: String, forPhotoMessageWithKey key: String) {
    let itemRef = messageRef.child(key)
    itemRef.updateChildValues(["photoURL": url])
  }
  
  // MARK: UI and User Interaction
  
  fileprivate func setupOutgoingBubble() -> JSQMessagesBubbleImage {
    let bubbleImageFactory = JSQMessagesBubbleImageFactory()
    return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
  }

  fileprivate func setupIncomingBubble() -> JSQMessagesBubbleImage {
    let bubbleImageFactory = JSQMessagesBubbleImageFactory()
    return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
  }

  override func didPressAccessoryButton(_ sender: UIButton) {
    let picker = UIImagePickerController()
    picker.delegate = self
    if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
      picker.sourceType = UIImagePickerControllerSourceType.camera
    } else {
      picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
    }
    
    present(picker, animated: true, completion:nil)
  }
  
  fileprivate func addMessage(withId id: String, name: String, text: String) {
    if let message = JSQMessage(senderId: id, displayName: name, text: text) {
      messages.append(message)      
    }
  }
  
  fileprivate func addPhotoMessage(withId id: String, key: String, mediaItem: JSQPhotoMediaItem) {
    if let message = JSQMessage(senderId: id, displayName: "", media: mediaItem) {
      messages.append(message)
      
      if (mediaItem.image == nil) {
        photoMessageMap[key] = mediaItem
      }
      
      collectionView.reloadData()
    }
  }
  
  // MARK: UITextViewDelegate methods
  
  override func textViewDidChange(_ textView: UITextView) {
    super.textViewDidChange(textView)
    // If the text is not empty, the user is typing
    isTyping = textView.text != ""
  }
  
}

// MARK: Image Picker Delegate
extension ChatViewController: UIImagePickerControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [String : Any]) {

    picker.dismiss(animated: true, completion:nil)

 
    if let photoReferenceUrl = info[UIImagePickerControllerReferenceURL] as? URL {
      // Handle picking a Photo from the Photo Library
  
      let assets = PHAsset.fetchAssets(withALAssetURLs: [photoReferenceUrl], options: nil)
      let asset = assets.firstObject


      if let key = sendPhotoMessage() {
 
        asset?.requestContentEditingInput(with: nil, completionHandler: { (contentEditingInput, info) in
          let imageFileURL = contentEditingInput?.fullSizeImageURL

    
          let path = "\(FIRAuth.auth()?.currentUser?.uid)/\(Int(Date.timeIntervalSinceReferenceDate * 1000))/\(photoReferenceUrl.lastPathComponent)"

      
          self.storageRef.child(path).putFile(imageFileURL!, metadata: nil) { (metadata, error) in
            if let error = error {
              print("Error uploading photo: \(error.localizedDescription)")
              return
            }
            // 7
            self.setImageURL(self.storageRef.child((metadata?.path)!).description, forPhotoMessageWithKey: key)
          }
        })
      }
    } else {
      // Handle picking a Photo from the Camera - TODO
    }
  }

  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion:nil)
  }
}
