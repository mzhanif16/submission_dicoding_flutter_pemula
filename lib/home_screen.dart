import 'dart:io';

import 'package:d_input/d_input.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:submission_dicoding_flutter_pemula/database_helper.dart';

class HomeView extends StatefulWidget {
  final DatabaseHelper databaseHelper;

  const HomeView({super.key, required this.databaseHelper});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final edtTitle = TextEditingController();
  final edtAuthor = TextEditingController();
  String? imagePath;
  final edtPublicationDate = TextEditingController();
  final edtGenre = TextEditingController();
  final edtDescription = TextEditingController();
  List<Map<String, dynamic>> books = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DaftarBuku'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: widget.databaseHelper.getBooks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text(
                    'Tidak ada data buku. Silahkan tambah data dulu pada button tambah dibawah',textAlign: TextAlign.center,));
          } else {
            books = snapshot.data!;
            return ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return Container(
                  margin: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (book['image'] != null)
                            Image.file(File(book['image']),
                                width: 100, height: 100, fit: BoxFit.cover),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book['title'],
                                  style: const TextStyle(fontSize: 12),
                                ),
                                Text(
                                  book['author'],
                                  style: const TextStyle(fontSize: 12),
                                ),
                                Text(
                                  book['publication_date'],
                                  style: const TextStyle(fontSize: 12),
                                ),
                                Text(
                                  book['genre'],
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      DView.spaceHeight(),
                      Text(book['description'])
                    ],
                  ),
                  // Tampilkan data buku lainnya sesuai kebutuhan.
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddBookDialog();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddBookDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tambah Buku'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                DInput(
                  controller: edtTitle,
                  fillColor: Colors.grey.shade300,
                  radius: BorderRadius.circular(10),
                  hint: 'Input title',
                ),
                DView.spaceHeight(),
                DInput(
                  controller: edtAuthor,
                  fillColor: Colors.grey.shade300,
                  radius: BorderRadius.circular(10),
                  hint: 'Input author',
                ),
                DView.spaceHeight(),
                DInput(
                  controller: edtPublicationDate,
                  fillColor: Colors.grey.shade300,
                  radius: BorderRadius.circular(10),
                  hint: 'Input publication date',
                ),
                DView.spaceHeight(),
                DInput(
                  controller: edtGenre,
                  fillColor: Colors.grey.shade300,
                  radius: BorderRadius.circular(10),
                  hint: 'Input genre',
                ),
                DView.spaceHeight(),
                DInput(
                  controller: edtDescription,
                  fillColor: Colors.grey.shade300,
                  radius: BorderRadius.circular(10),
                  hint: 'Input description',
                ),
                DView.spaceHeight(),
                ElevatedButton(
                  onPressed: () async {
                    final pickedImage = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (pickedImage != null) {
                      setState(() {
                        imagePath =
                            pickedImage.path; // Simpan path gambar yang dipilih
                      });
                    }
                  },
                  child: Text('Pilih Gambar'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                final title = edtTitle.text;
                final author = edtAuthor.text;
                final publicationDate = edtPublicationDate.text;
                final genre = edtGenre.text;
                final description = edtDescription.text;
                await widget.databaseHelper.addBook(title, author, imagePath!,
                    publicationDate, genre, description);
                // Tutup dialog
                Navigator.of(context).pop();

                // Update daftar buku
                books = await widget.databaseHelper.getBooks();
                setState(() {});
              },
              child: Text('Tambah'),
            ),
          ],
        );
      },
    );
  }
}
