class PengaturanQuery {
  static const String TABLE_NAME = "pengaturan";
  static const String CREATE_TABLE = "CREATE TABLE IF NOT EXISTS $TABLE_NAME " +
      "(id INTEGER PRIMARY KEY AUTOINCREMENT," +
      "nama TEXT," +
      "alamat TEXT," +
      "kota TEXT," +
      "telepon TEXT," +
      "alamatIP TEXT," +
      "printerName1 TEXT DEFAULT test," +
      "printerName2 TEXT DEFAULT test," +
      "printerAddress1 TEXT DEFAULT test," +
      "printerAddress2 TEXT DEFAULT test)";
  static const String SELECT = "select * from $TABLE_NAME";
}
