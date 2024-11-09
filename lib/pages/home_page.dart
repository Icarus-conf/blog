import 'package:blog/widgets/drawer.dart';
import 'package:blog/components/helper/helper_methods.dart';
import 'package:blog/components/text_format.dart';
import 'package:blog/components/textfield_styling.dart';
import 'package:blog/pages/profile_page.dart';
import 'package:blog/widgets/blog_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  final postText = TextEditingController();

  signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<String> getUsername() async {
    DocumentSnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser.email)
            .get();

    return querySnapshot.get('username');
  }

  postIn() async {
    if (postText.text.isNotEmpty) {
      String username = await getUsername();
      FirebaseFirestore.instance.collection('Posts').add({
        'UserEmail': currentUser.email,
        'Message': postText.text,
        'username': username,
        'createdAt': Timestamp.now(),
        'Likes': [],
      });
    }

    postText.clear();
  }

  goToProfile() {
    Navigator.pop(context);

    Navigator.pushNamed(context, ProfilePage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFced4da),
      drawer: CustomDrawer(
        onProfileTap: goToProfile,
        onLogOutTap: signOut,
      ),
      appBar: AppBar(
        title: const PoppinsText(
          text: 'Blog',
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.grey[900],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Posts')
                  .orderBy('createdAt', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final post = snapshot.data!.docs[index];
                      return BlogPost(
                        msg: post['Message'],
                        user: post['username'],
                        time: formatDate(post['createdAt']),
                        postId: post.id,
                        likes: List<String>.from(post['Likes'] ?? []),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: PoppinsText(text: 'Error:${snapshot.error}'),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              bottom: 12,
              right: 12,
              left: 12,
            ),
            color: const Color(0xFFced4da),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomTextField(
                        hintText: 'Write something',
                        controller: postText,
                      ),
                    ),
                    IconButton(
                      onPressed: postIn,
                      icon: Image.asset(
                        'assets/addition.png',
                        width: 40,
                      ),
                    ),
                  ],
                ),
                PoppinsText(text: currentUser.email!),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
