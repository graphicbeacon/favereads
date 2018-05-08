import '../fave_reads.dart';

class Book extends HTTPSerializable {
  String title;
  String author;
  int year;

  Book({this.title, this.author, this.year});

  @override
  Map<String, dynamic> asMap() => {
        "title": title,
        "author": author,
        "year": year,
      };

  @override
  void readFromMap(Map body) {
    title = body["title"];
    author = body["author"];
    year = body["year"];
  }
}
