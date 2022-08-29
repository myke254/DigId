import 'database_helper.dart';


class DbMethods{
  final _dbHelper = DatabaseHelper.instance;

  void insert({String? firstName,String? middleName, String? lastName, String? nationality, String? dob, int? gender, String? pictures}) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnFirstName : firstName,
      DatabaseHelper.columnMiddleName : middleName,
      DatabaseHelper.columnLastName: lastName,
      DatabaseHelper.columnNationality:nationality,
      DatabaseHelper.columnDateOfBirth:dob,
      DatabaseHelper.columnGender: gender,
      DatabaseHelper.columnPictures: pictures
    };
    final id = await _dbHelper.insert(row);
    print('inserted row id: $id');
  }

  Future<List<Map<String, dynamic>>> query() async {
    final allRows = await _dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach(print);
    return allRows;
  }
  Future <Map<String,dynamic>> queryRow(int id) async {
    final row = await _dbHelper.queryRow(id);
    print("row data: ");
    row.entries.forEach(print);
    return row;
  }

  void update({required int id,String? firstName,String? middleName, String? lastName, String? nationality, String? dob, int? gender, String? pictures}) async {
    final exRow = await _dbHelper.queryRow(id);
    // row to update
    Map<String, dynamic> row = {
     // DatabaseHelper.columnId   : 1,
      DatabaseHelper.columnFirstName : firstName?? exRow['first_name'],
      DatabaseHelper.columnMiddleName: middleName?? exRow['middle_name'],
      DatabaseHelper.columnLastName: lastName?? exRow['last_name'],
      DatabaseHelper.columnNationality: nationality?? exRow['nationality'],
      DatabaseHelper.columnDateOfBirth: dob?? exRow['dob'],
      DatabaseHelper.columnGender: gender?? exRow['gender'],
      DatabaseHelper.columnPictures  : pictures?? exRow['pictures'],
    };
    final rowsAffected = await _dbHelper.update(row,id);
    print('updated $rowsAffected row(s)');
  }

  void delete(int id) async {
    // Assuming that the number of rows is the id for the last row.
    //final id = await _dbHelper.queryRowCount();
    final rowsDeleted = await _dbHelper.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
  }
}
