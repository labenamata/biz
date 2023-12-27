class TempQuery {
  static const String TABLE_NAME = "temp";
  static const String CREATE_TABLE = "CREATE TABLE IF NOT EXISTS $TABLE_NAME " +
      "(menu_id INTEGER PRIMARY KEY AUTOINCREMENT," +
      "variant_id INTEGER," +
      "variant TEXT," +
      "qty INTEGER," +
      "name TEXT," +
      "note TEXT," +
      "is_takeaway INTEGER," +
      "total INTEGER," +
      "price INTEGER)";
  static const String SELECT = "select * from $TABLE_NAME";

  static const String TotalTemp = "SELECT sum(total) as sum from temp";
}
