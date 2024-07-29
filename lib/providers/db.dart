import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class  Database{
  
  static Future<SharedPreferences> getDatabase() async{
    return await SharedPreferences.getInstance();
  }


  static savePlans(List plans) async {
    print("============ Save plans ================");
    print(plans);
    final db = await getDatabase();
    await db.setString("plan", jsonEncode(plans));
  }


  static saveDate(DateTime date) async{
    final db = await getDatabase();
    await db.setString("date", date.toString());
  }

  static saveSite(String site) async {
    final db = await getDatabase();
    await db.setString("site", site);
  }


  // load data

  static Future getSavedPlans() async {
    final db = await getDatabase();
    String? plansAsJson = db.getString("plan");
    if (plansAsJson != null) {
      return jsonDecode(plansAsJson);
    }
    return [];
  }


  static Future<DateTime>  getDate() async {
      final db = await getDatabase();
      String? date = db.getString("date");
      if (date != null) {
        return DateTime.parse(date);
      }
    

    return DateTime.now();

  }


  static Future<String> getSite()async {
    final db = await getDatabase();
    String site = db.getString("site") ?? "";
    return site;
  }
  

}