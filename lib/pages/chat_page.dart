import 'package:flutter/material.dart';
import 'package:chat_app/Chat/chat_bubble.dart';
import 'package:chat_app/Chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserID;
  final String receiverName;

  const ChatPage({
    super.key,
    required this.receiverUserEmail,
    required this.receiverUserID,
    required this.receiverName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Color themeColor = Colors.blue; // Default theme color
  bool bottomAppBar = false;
  IconData iconLeft = Icons.add;
  bool darkMode = false;
  Color backColor = Colors.grey.shade300;

  void bottomAppBarOpen() {
    setState(() {
      bottomAppBar = !bottomAppBar;
      if (bottomAppBar) {
        iconLeft = Icons.close;
      } else {
        iconLeft = Icons.add;
      }
    });
  }

  void changeTheme(Color newColor) {
    setState(() {
      themeColor = newColor;
    });
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUserID, _messageController.text, widget.receiverName);
    }
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey[200]),
        centerTitle: true,
        backgroundColor: themeColor,
        title: Column(
          children: [
            Text(
              widget.receiverName,
              style: TextStyle(
                color: Colors.grey.shade300,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.receiverUserEmail,
              style: TextStyle(
                color: Colors.grey[100],
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                children: [
                  _buildMessageList(),
                ],
              ),
            ),
          ),
          _buildMessageInput(),
          SizedBox(height: 15),
        ],
      ),
      endDrawer: Drawer(
        backgroundColor: Colors.grey,
        child: ListView(
          padding: EdgeInsets.only(top: 50, left: 30),
          children: [
            ListTile(
              title: Text(
                "Change Theme",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text("Select a color"),
            ),
            Wrap(
              spacing: 10,
              children: [
                Colors.blue,
                Colors.red,
                Colors.green,
                Colors.purple,
                Colors.black,
                Colors.teal,
              ].map((color) {
                return GestureDetector(
                  onTap: () => changeTheme(color),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Dark Mode",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Switch(
                      activeColor: Colors.black,
                      inactiveThumbColor: themeColor,
                      value: darkMode,
                      onChanged: (index) {
                        setState(() {
                          darkMode = index;

                          if (index) {
                            backColor = Colors.grey.shade900;
                          } else {
                            backColor = Colors.grey.shade300;
                          }
                        });
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: bottomAppBar
          ? BottomAppBar(
              color: Colors.white,
              child: SafeArea(
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.image,
                          color: themeColor,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.file_copy,
                          color: themeColor,
                        )),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessage(
          widget.receiverUserID, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return _buildMessageItem(snapshot.data!.docs[index]);
          },
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    var alignments = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignments,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
              (data['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
          children: [
            Text(
              data['senderEmail'],
              style: TextStyle(
                color: Colors.grey,
                fontSize: 10,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            ChatBubble(
              message: data['message'],
              bgColor: (data['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? themeColor
                  : Colors.white,
              textColor: (data['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? Colors.white
                  : Colors.grey.shade800,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Row(
      children: [
        Container(
            margin: EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              color: themeColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: IconButton(
                onPressed: bottomAppBarOpen,
                icon: Icon(
                  iconLeft,
                  size: 25,
                  color: Colors.white,
                ))),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: TextField(
            controller: _messageController,
            decoration: InputDecoration(
              filled: true,
              fillColor: darkMode ? Colors.black : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide.none,
              ),
              hintText: "Enter Message",
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        )),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.white, width: 3),
              color: themeColor,
            ),
            child: IconButton(
                onPressed: sendMessage,
                icon: Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 25,
                )),
          ),
        )
      ],
    );
  }
}
