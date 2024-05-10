import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'profile.dart';  // Impor ProfilePage
import 'detail.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<dynamic> recommendations;

  @override
  void initState() {
    super.initState();
    _fetchRecommendations();
  }

  Future<void> _fetchRecommendations() async {
    final response = await http.get(
      Uri.parse('https://api.jikan.moe/v4/anime/1/recommendations'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        recommendations = data['data'];
      });
    } else {
      throw Exception('Failed to load recommendations');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anime Recommendations'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),  // Ikon untuk profil
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(),  // Navigasi ke ProfilePage
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: recommendations.length,
        itemBuilder: (context, index) {
          final entry = recommendations[index]['entry'];
          return ListTile(
            leading: Image.network(
              entry['images']['jpg']['image_url'],
            ),
            title: Text(entry['title']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(
                    malId: entry['mal_id'],
                    title: entry['title'],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
