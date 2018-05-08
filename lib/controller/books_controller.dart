import '../fave_reads.dart';

List books = [
  {
    'title': 'Head First Design Patterns',
    'author': 'Eric Freeman',
    'year': 2004
  },
  {
    'title': 'Clean Code: A handbook of Agile Software Craftsmanship',
    'author': 'Robert C. Martin',
    'year': 2008
  },
  {
    'title': 'Code Complete: A Practical Handbook of Software Construction',
    'author': 'Steve McConnell',
    'year': 2004
  },
];

class BooksController extends HTTPController {
  @httpGet
  Future<Response> getAll() async {
    return new Response.ok(books);
  }

  @httpGet
  Future<Response> getSingle(@HTTPPath("index") int idx) async {
    if (idx < 0 || idx > books.length - 1) {
      return new Response.notFound(body: 'Book does not exist');
    }
    return new Response.ok(books[idx]);
  }

  @httpPost
  Future<Response> addSingle() async {
    var book = request.body.asMap();
    books.add(book);
    return new Response.ok(book);
  }

  @httpPut
  Future<Response> replaceSingle(@HTTPPath("index") int idx) async {
    if (idx < 0 || idx > books.length - 1) {
      return new Response.notFound(body: 'Book does not exist');
    }
    var body = request.body.asMap();
    for (var i = 0; i < books.length; i++) {
      if (i == idx) {
        books[i]["title"] = body["title"];
        books[i]["author"] = body["author"];
        books[i]["year"] = body["year"];
      }
    }
    return new Response.ok(body);
  }

  @httpDelete
  Future<Response> delete(@HTTPPath("index") int idx) async {
    if (idx < 0 || idx > books.length - 1) {
      return new Response.notFound(body: 'Book does not exist');
    }
    books.removeAt(idx);
    return new Response.ok('Book successfully deleted.');
  }
}
