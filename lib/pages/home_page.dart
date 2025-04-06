import '../Authentication/auth_service.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //instance of auth
  final FirebaseAuth auth = FirebaseAuth.instance;
  //instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final user = FirebaseAuth.instance.currentUser!;

  void signOut() {
    //basically we are using methods from another class,so we need an instance of that class first
    final authService = Provider.of<AuthService>(context,
        listen: false); //instance of AuthService class
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey[100]),
        centerTitle: true,
        backgroundColor: Colors.grey[800],
        title: Text(
          'Active Users',
          style: TextStyle(
            color: Colors.grey[100],
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        actions: [
          IconButton(
              onPressed: signOut,
              icon: Icon(
                Icons.logout,
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: _buildUserList(),
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey[900],
        child: Column(
          children: [
            DrawerHeader(
              margin: EdgeInsets.all(20),
              child: Column(
                children: [
                  Image.asset(
                    "image/mslogo.png",
                    scale: 1.5,
                    color: Colors.grey[200],
                  ),
                  Text(
                    "DropCHAT",
                    style: TextStyle(
                      fontFamily: "Bytesized",
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.grey[200],
                    ),
                  ),
                ],
              ),
            ),

            // Use Expanded to make ListView take remaining space
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: Text(
                      "About",
                      style: TextStyle(
                        color: Colors.grey[100],
                      ),
                    ),
                    leading: Icon(
                      Icons.info,
                      color: Colors.grey[100],
                    ),
                  ),
                  ListTile(
                    onTap: signOut,
                    title: Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.grey[100],
                      ),
                    ),
                    leading: Icon(
                      Icons.logout,
                      color: Colors.grey[100],
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.only(
                  bottom: 20), // Adjust bottom spacing if needed
              child: ListTile(
                leading: Icon(
                  Icons.create,
                  color: Colors.white,
                ),
                title: Text(
                  "Developed By HimaloySTUDIO",
                  style: TextStyle(
                    color: Colors.grey[100],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error!");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Waiting...");
          }

          return ListView(
            children: snapshot.data!.docs
                .map<Widget>((doc) => _buildUserListItem(doc))
                .toList(),
          );
        });
  }

  //build individual user list item
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    if (auth.currentUser!.email != data['email']) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverUserEmail: data['email'],
                receiverUserID: data['uid'],
                receiverName: data['name'].toString(),
              ),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(
              vertical: 4, horizontal: 10), // Adjust spacing
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(12),
          child: Center(
            child: Column(
              children: [
                Text(
                  data['name'].toString(),
                  style: TextStyle(
                    color: Colors.grey.shade100,
                    fontWeight: FontWeight.bold,
                    // fontSize: 18,
                  ),
                ),
                Text(
                  data['email'],
                  style: TextStyle(
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return SizedBox.shrink();
  }
}
