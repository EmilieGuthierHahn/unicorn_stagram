// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:unicorn_stagram/models/photo.dart';
import 'package:unicorn_stagram/providers/Likes_provider.dart';
import 'package:unicorn_stagram/screens/details_screen.dart';
import 'package:unicorn_stagram/services/photo_service.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Photo>> _postsFuture;
  final PhotoService photoService = PhotoService();

  @override
  void initState() {
    super.initState();
    _postsFuture = photoService.findAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unicorn_stagram 🦄'),
      ),
      body: FutureBuilder<List<Photo>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(
                'Oups, une erreur est survenue: ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            final posts = snapshot.data!;

            return GridView.builder(
              padding: const EdgeInsets.all(2.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 2.0,
                mainAxisSpacing: 2.0,
              ),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];

                return GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (modalContext) {
                        return ChangeNotifierProvider.value(
                          value:
                              Provider.of<LikesProvider>(context, listen: false),
                          child: DetailsModal(post: post),
                        );
                      },
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: post.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.pink.shade50,
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey.shade200,
                      child:
                          const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text("Aucun post pour le moment."));
        },
      ),
    );
  }
}
