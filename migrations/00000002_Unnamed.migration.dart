import 'package:aqueduct/aqueduct.dart';   
import 'dart:async';

class Migration2 extends Migration { 
  @override
  Future upgrade() async {
   database.createTable(new SchemaTable("_Author", [
new SchemaColumn("id", ManagedPropertyType.bigInteger, isPrimaryKey: true, autoincrement: true, isIndexed: false, isNullable: false, isUnique: false),
new SchemaColumn("name", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),
new SchemaColumn.relationship("book", ManagedPropertyType.bigInteger, relatedTableName: "_Book", relatedColumnName: "id", rule: ManagedRelationshipDeleteRule.nullify, isNullable: true, isUnique: false),
],
));

database.deleteColumn("_Book", "author");


  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    