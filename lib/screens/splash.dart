
import 'package:flutter/material.dart';
import 'package:mega_pro_planing_app/providers/data.dart';
import 'package:mega_pro_planing_app/providers/db.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  getSavedData () async{
    await Database.getSavedPlans().then((savedPlans) {

      // load saved Plans
      Provider.of<Data>(context, listen: false).setData(savedPlans);

    }).onError((err, trc){
      if (mounted){
        ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("Nous pouvons pas obtenir les information stockee ! $err ")));
      }
    });
  } 

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    // load saved plans 
    getSavedData();

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  

      body:Column(
        children: [
          const Spacer(),
          Image.asset("assets/images/img.png",width: MediaQuery.of(context).size.width * 0.6,),
          const Spacer(),
          ListTile(
            onTap: (){
              Navigator.pushNamed(context, "planning");
            },
            tileColor: Colors.yellow,
            splashColor: Colors.greenAccent,
            leading: const Icon(Icons.table_chart,),
            title: const Text("Ouvrir Le Planing"),
            trailing: const Icon(Icons.arrow_right),
          
          )
        ],
      )  
      
    );
  }
}