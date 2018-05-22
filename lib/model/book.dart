import '../fave_reads.dart';

class Book extends ManagedObject<_Book> implements _Book {}

class _Book {
  @managedPrimaryKey
  int id;

  String title;
  String author;
  int year;
}
