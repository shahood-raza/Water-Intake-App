import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_intake_app/pages/home_page.dart';
import 'package:water_intake_app/providers/water_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WaterProvider(),
      child: MaterialApp(
        
        title: 'Water Intake',
        debugShowCheckedModeBanner: false,
        theme: ThemeData( 
          
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade400),
        ),
        home: const HomePage(),
      ),
    );
  }
}

