import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HttpScreen extends StatefulWidget {
  const HttpScreen({super.key});

  @override
  _HttpScreenState createState() => _HttpScreenState();
}

class _HttpScreenState extends State<HttpScreen> {
  List<String> catImages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getImages();
  }

  Future<void> getImages() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse('https://api.thecatapi.com/v1/images/search?limit=20'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        setState(() {
          catImages = data.map((cat) => cat['url'].toString()).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load images');
      }
    } catch (e) {
      print('Error fetching images: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Petición HTTP con http')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getImages();
        },
        child: const Icon(Icons.replay_outlined),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : MasonryGridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              gridDelegate:
                  const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: catImages.length,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: FadeInImage(
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 100),
                      placeholder:
                          const AssetImage('assets/loaders/loading.gif'),
                      image: NetworkImage(catImages[index])),
                );
              },
            ),
    );
  }
}