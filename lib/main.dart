

import 'package:flutter/material.dart';
import 'package:mega_pro_planing_app/providers/data.dart';
import 'package:mega_pro_planing_app/screens/planning.dart';
import 'package:mega_pro_planing_app/screens/splash.dart';
import 'package:provider/provider.dart';

void main (){
  runApp(
    ChangeNotifierProvider(create: (context) => Data(),child: const App(),)
  );
}


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Mega Pro Planning",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        visualDensity: VisualDensity.adaptivePlatformDensity,

        scaffoldBackgroundColor:  const Color.fromARGB(255, 210, 220, 231),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.green
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          
          style: ButtonStyle(
            backgroundColor: WidgetStateColor.resolveWith((states) => Colors.yellow,),
            textStyle: WidgetStateProperty.resolveWith((states) => const TextStyle(
              color: Colors.green
            ),),  
          )
        )

      ),
      routes: {
        "/":(context) => const SplashScreen(),
        "planning": (context) => const PlanningScreen(),
      },
    );
  }
}