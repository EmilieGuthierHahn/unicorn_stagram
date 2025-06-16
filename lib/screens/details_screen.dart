// lib/screens/details_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:unicorn_stagram/models/photo.dart';
import 'package:unicorn_stagram/providers/Likes_provider.dart';


class DetailsModal extends StatefulWidget {
  final Photo post;

  const DetailsModal({super.key, required this.post});

  @override
  State<DetailsModal> createState() => _DetailsModalState();
}

class _DetailsModalState extends State<DetailsModal> {
  final List<String> _comments = [];
  final TextEditingController _commentController = TextEditingController();

  void _publishComment() {
    if (_commentController.text.isNotEmpty) {
      setState(() {
        _comments.add(_commentController.text);
        _commentController.clear();
        FocusScope.of(context).unfocus();
      });
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color unicornPink = Colors.pink.shade200;
    final Color unicornPurple = Colors.purple.shade200;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: CachedNetworkImage(
                        imageUrl: widget.post.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.post.description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Par ${widget.post.author}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    Consumer<LikesProvider>(
                      builder: (context, likesProvider, child) {
                        final isLiked =
                            likesProvider.isPostLiked(widget.post.id);
                        return TextButton.icon(
                          onPressed: () =>
                              likesProvider.toggleLike(widget.post.id),
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.redAccent : unicornPink,
                          ),
                          label: Text(
                            isLiked ? "J'adore !" : "Liker",
                            style: TextStyle(
                                color:
                                    isLiked ? Colors.redAccent : unicornPink),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 30),
                    const Text(
                      "Commentaires",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    if (_comments.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: Text("Aucun commentaire pour le moment.",
                              style: TextStyle(color: Colors.grey)),
                        ),
                      )
                    else
                      ..._comments.map((comment) => ListTile(
                            leading: CircleAvatar(
                              backgroundColor: unicornPurple,
                              child: const Icon(Icons.person,
                                  color: Colors.white, size: 18),
                            ),
                            title: Text(comment),
                          )),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 8,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      onSubmitted: (_) => _publishComment(),
                      decoration: InputDecoration(
                        hintText: "Ajouter un commentaire...",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: unicornPurple,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.send),
                    onPressed: _publishComment,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
