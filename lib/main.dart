import 'package:flutter/material.dart';
import 'package:my_app/model/card_data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Movie Cards")),
        body: _InfoCards(),
      ),
    );
  }
}

final List<CardData> mockCardData = [
  CardData(
    name: "The Shawshank Redemption",
    description:
        "Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.",
    imdb: "tt0111161",
    language: "English",
    year: 1994,
  ),
  CardData(
    name: "Parasite",
    description:
        "A poor family schemes to become employed by a wealthy family by infiltrating their household and posing as unrelated, highly qualified individuals.",
    imdb: "tt6751668",
    language: "Korean",
    year: 2019,
    coverImage: null, // Optional field, can be null as per your model
  ),
];

class _InfoCards extends StatelessWidget {
  final List<CardData> movies = mockCardData;

  @override
  Widget build(BuildContext ctx) {
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (ctx, index) {
        final movie = movies[index];
        return Card(
          elevation: 4,
          margin: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              movie.coverImage != null
                  ? Image.memory(
                    Uri.parse(movie.coverImage!).data!.contentAsBytes(),
                    height: 250,
                    fit: BoxFit.cover,
                  )
                  : Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: Icon(Icons.image_not_supported, size: 50),
                  ),

              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${movie.name} (${movie.year})",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(movie.description, style: TextStyle(fontSize: 14)),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            blurRadius: 4,
                            offset: Offset(0, 2), // Subtle shadow
                          ),
                        ],
                      ),
                      child: Text(
                        movie.language,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black87, // Darker text for contrast
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Add IMDb link logic here later if needed
                        ("Navigating to IMDb for ${movie.imdb}");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow[700], // IMDb-like yellow
                        foregroundColor: Colors.black, // Text/icon color
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            12,
                          ), // Rounded edges
                        ),
                        elevation: 2, // Subtle elevation
                      ),
                      child: Text(
                        "Visit IMDb",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


// ListTile(
//             title: Text(movie.name),
//             subtitle: Text("${movie.description} (${movie.year})"),
//             trailing: Text(movie.language),
//             leading:
                
//           ),