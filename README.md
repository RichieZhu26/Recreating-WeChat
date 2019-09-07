# Recreating-WeChat

This is a messaging app that recreates WeChat using Google sign-in and Firebase. To user it, the user will first sign in with a Google account. If the user already have friends added before, he or she can directly select a friend and begin/continue a conversation. If the user is new or wants to add a new friend, he or she can go to "Contacts" and select the "Add" button at the top, enter part of the friend's name in the search bar and then choose the friend from related results. At this point if the user goes back to "Chats", he or she will find the new friend in the chat list and now they can send text messages to each other. In addition, the most recent message of that chat will be shown under the friend's name label.

(Two users with different physical devices have successfully chat with each other using this app. For demonstration purposes I created two default users in Firebase: "rl496" and "zc96")

To solve the problem of real-time data update in the UI, the app implements a timer to regularly request updated information (e.g. chat list or message list) from Firebase and renew the view accordingly.

Possible features of this project in the future: Photo/voice message, new message notification, read/unread mark, etc.
<br><br>
# Screenshots
<br><img src="https://github.com/RichieZhu26/Recreating-WeChat/blob/master/screenshot/signin.jpeg" width="400">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="https://github.com/RichieZhu26/Recreating-WeChat/blob/master/screenshot/chat.jpeg" width="400">
<br><br><img src="https://github.com/RichieZhu26/Recreating-WeChat/blob/master/screenshot/contact.jpeg" width="400">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="https://github.com/RichieZhu26/Recreating-WeChat/blob/master/screenshot/search.jpeg" width="400">
<br><br><img src="https://github.com/RichieZhu26/Recreating-WeChat/blob/master/screenshot/message.jpeg" width="400">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="https://github.com/RichieZhu26/Recreating-WeChat/blob/master/screenshot/send.jpeg" width="400">
<br><br><img src="https://github.com/RichieZhu26/Recreating-WeChat/blob/master/screenshot/firebase.jpeg">
