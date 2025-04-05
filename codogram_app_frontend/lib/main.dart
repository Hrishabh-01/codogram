import 'package:codogram_app_frontend/view_model/feed_view_model.dart';
import 'package:flutter/material.dart';
import 'package:codogram_app_frontend/utils/routes/routes.dart';
import 'package:codogram_app_frontend/utils/routes/routes_name.dart';
import 'package:codogram_app_frontend/view/login_view.dart';
import 'package:codogram_app_frontend/view_model/auth_view_model.dart';
import 'package:codogram_app_frontend/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>AuthViewModel()),
        ChangeNotifierProvider(create: (_)=>UserViewModel()),
        ChangeNotifierProvider(create: (_)=>FeedViewModel())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent, // Transparent AppBar
            elevation: 0, // Remove shadow
            iconTheme: IconThemeData(color: Colors.white), // Set icon color
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20), // Set title text color
          ),
        ),
        initialRoute: RoutesName.splash,
        onGenerateRoute: Routes.generateRoute,
      ),);
  }
}
