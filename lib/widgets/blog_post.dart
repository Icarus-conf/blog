import 'package:blog/widgets/comment.dart';
import 'package:blog/components/comment_btn.dart';
import 'package:blog/components/helper/helper_methods.dart';
import 'package:blog/components/like_btn.dart';
import 'package:blog/components/text_format.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BlogPost extends StatefulWidget {
  final String msg;
  final String user;
  final String postId;
  final List<String> likes;
  final String time;
  const BlogPost({
    super.key,
    required this.msg,
    required this.user,
    required this.postId,
    required this.likes,
    required this.time,
  });

  @override
  State<BlogPost> createState() => _BlogPostState();
}

class _BlogPostState extends State<BlogPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  bool isLiked = false;

  final _comment = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email!);
  }

  toggleLikeBtn() {
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference postRef =
        FirebaseFirestore.instance.collection('Posts').doc(widget.postId);
    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  Future<String> getUsername() async {
    DocumentSnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser.email)
            .get();

    return querySnapshot.get('username');
  }

  addComment(String commentText) async {
    String username = await getUsername();
    FirebaseFirestore.instance
        .collection('Posts')
        .doc(widget.postId)
        .collection('Comments')
        .add({
      'CommentText': commentText,
      'CommentedBy': username,
      'CommentTime': Timestamp.now(),
    });
  }

  removeComment() {}

  showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const PoppinsText(text: 'Add Comment'),
        content: TextField(
          controller: _comment,
          decoration: const InputDecoration(hintText: 'Write a comment'),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                _comment.clear();
              },
              child: const PoppinsText(text: 'Cancel')),
          TextButton(
              onPressed: () {
                addComment(_comment.text);
                Navigator.pop(context);
                _comment.clear();
              },
              child: const PoppinsText(text: 'Post')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFFe7ecef),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 0.5),
              blurRadius: 0.5,
            )
          ]),
      margin: const EdgeInsets.fromLTRB(25, 25, 25, 0),
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PoppinsText(text: widget.msg),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  PoppinsText(
                    text: widget.user,
                    color: Colors.grey[500],
                  ),
                  PoppinsText(
                    text: ' ~ ',
                    color: Colors.grey[500],
                  ),
                  PoppinsText(
                    text: widget.time,
                    color: Colors.grey[500],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  LikeBtn(isLiked: isLiked, onTap: toggleLikeBtn),
                  PoppinsText(
                    text: widget.likes.length.toString(),
                    color: Colors.grey,
                  ),
                ],
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                children: [
                  CommentBtn(onTap: showCommentDialog),
                  SizedBox(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Posts')
                          .doc(widget.postId)
                          .collection('Comments')
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return PoppinsText(
                            text: snapshot.data!.docs.length.toString(),
                            color: Colors.grey,
                          );
                        }
                        return PoppinsText(text: '0');
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Posts')
                .doc(widget.postId)
                .collection('Comments')
                .orderBy('CommentTime', descending: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((doc) {
                  final commentData = doc.data() as Map<String, dynamic>;
                  return Comment(
                    comment: commentData['CommentText'],
                    user: commentData['CommentedBy'],
                    createdAt: formatDate(commentData['CommentTime']),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
