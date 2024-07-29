import 'package:flutter/material.dart';
import 'package:mega_pro_planing_app/providers/db.dart';


class Data extends ChangeNotifier{

  final List<String> Days = ["Lundi", "Mardi", "Mercredi","Jeudi", "Vendredi", "Samedi", "Dimanche"];


  List data = [];


  setData (List newData){
    data = newData;
    notifyListeners();
  }


  addNewRow(){

    data.add({
      "name":"clicker pour modifier ..",
      "plan": [
        "clicker pour modifier ..",
        "clicker pour modifier ..",
        "clicker pour modifier ..",
        "clicker pour modifier ..",
        "clicker pour modifier ..",
        "clicker pour modifier ..",
        "clicker pour modifier ..",
      ]
    });

    notifyListeners();
    Database.savePlans(data);

  }


  removeRow (info){
    data.remove(info);
    notifyListeners();
    Database.savePlans(data);
  }


  modifyName (Map info, String newName){
    data.where((data) => data == info).first["name"] = newName;

    notifyListeners();
    Database.savePlans(data);
  }

  modifyPlan (Map info,String plan ,int day){
    data.where((data) => data == info).first["plan"][day] = plan;


    notifyListeners();
    Database.savePlans(data);
  }


}