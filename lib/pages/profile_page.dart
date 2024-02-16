import 'package:blog/components/text_box.dart';
import 'package:blog/components/text_format.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = 'ProfilePage';
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection('Users');

  Future<void> editField(String field) async {
    String newValue = '';
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: PoppinsText(text: 'Edit $field'),
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Enter new $field',
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const PoppinsText(text: 'Cancel'),
          ),
          TextButton(
            child: const PoppinsText(text: 'Save'),
            onPressed: () => Navigator.of(context).pop(newValue),
          ),
        ],
      ),
    );

    if (newValue.trim().isNotEmpty) {
      await usersCollection.doc(currentUser.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFced4da),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const PoppinsText(
          text: 'Profile',
          color: Colors.white,
        ),
        backgroundColor: Colors.grey[900],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            return Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.person,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PoppinsText(
                      text: currentUser.email!,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PoppinsText(
                      text: 'My Details:',
                      textAlign: TextAlign.center,
                      color: Colors.grey[600],
                    ),
                  ),
                  TextBox(
                    text: userData['username'],
                    nameSection: 'username',
                    onPressed: () => editField('username'),
                  ),
                  TextBox(
                    text: userData['bio'],
                    nameSection: 'bio',
                    onPressed: () => editField('bio'),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: PoppinsText(text: 'Error${snapshot.error}'),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
