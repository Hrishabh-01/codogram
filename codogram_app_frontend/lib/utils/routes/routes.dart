import 'package:codogram_app_frontend/intro_page.dart';
import 'package:codogram_app_frontend/view/feed_view.dart';
import 'package:flutter/material.dart';
import 'package:codogram_app_frontend/utils/routes/routes_name.dart';
import 'package:codogram_app_frontend/view/home_screen.dart';
import 'package:codogram_app_frontend/view/login_view.dart';
import 'package:codogram_app_frontend/view/signup_view.dart';
import 'package:codogram_app_frontend/view/splash_view.dart';

class Routes{
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case RoutesName.intro:
        return MaterialPageRoute(builder: (BuildContext context)=>IntroPage());
      case RoutesName.splash:
        return MaterialPageRoute(builder: (BuildContext context)=>SplashView());
      case RoutesName.home:
        return MaterialPageRoute(builder: (BuildContext context)=>HomeScreen());
      case RoutesName.login:
        return MaterialPageRoute(builder: (BuildContext context)=>LoginView());
      case RoutesName.signUp:
        return MaterialPageRoute(builder: (BuildContext context)=>SignupView());
      case RoutesName.feed:
        return MaterialPageRoute(builder: (BuildContext context)=>FeedView());
      default:
        return MaterialPageRoute(builder: (_){return const Scaffold(
          body: Center(
            child: Text('No route defined'),
          ),
        );
        });
    }
  }
}