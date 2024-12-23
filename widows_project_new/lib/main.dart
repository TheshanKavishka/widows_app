import 'package:flutter/material.dart';
import 'login/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


Future<void> main() async {
  await Supabase.initialize(
    url: 'https://ltsunygkmstitvyxskia.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx0c3VueWdrbXN0aXR2eXhza2lhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzM4ODUwMzIsImV4cCI6MjA0OTQ2MTAzMn0.R6Xi5Rs5Tpy7Y8YOiUUsql-t6ERcOFN9hn9xaS0kd3E',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  const LoginPage(),
    );
  }
}
