import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailPage extends StatefulWidget {
  final int malId;
  final String title;

  DetailPage({required this.malId, required this.title});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Map<String, dynamic> animeDetail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAnimeDetail();  // Mengambil data saat inisialisasi
  }

  Future<void> _fetchAnimeDetail() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.jikan.moe/v4/anime/${widget.malId}'),  // Mengambil data detail berdasarkan mal_id
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);  // Parsing JSON
        setState(() {
          animeDetail = data['data'];  // Simpan detail yang diterima
          isLoading = false;  // Set isLoading ke false
        });
      } else {
        throw Exception('Failed to load anime detail');
      }
    } catch (e) {
      print('Error fetching anime detail: $e');  // Menangani kesalahan
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: CircularProgressIndicator(),  // Loading saat mengambil data
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(animeDetail['title'] ?? widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              animeDetail['images']['jpg']['image_url'],  // Gambar dari API
            ),
            SizedBox(height: 16),
            Text(
              animeDetail['synopsis'] ?? 'No synopsis available.',  // Tampilkan sinopsis atau informasi lainnya
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Rating: ${animeDetail['rating']}',  // Tampilkan rating atau informasi lain
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
