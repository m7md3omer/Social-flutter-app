import 'package:flutter/material.dart';
import 'package:social/screens/photo_viewer.dart';
import 'package:social/screens/post_detail.dart';
import 'package:social/screens/profile.dart';

class ProfileNavigator extends StatelessWidget {
  ProfileNavigator({@required this.navigatorKey}) : assert(navigatorKey != null);
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        String name = settings.name;
        switch(name){
          case '/':
            return MaterialPageRoute(builder: (_) => ProfilePage());
            break;
          case '/post':
            return MaterialPageRoute(builder: (_) => PostDetails());
          case '/photo':
            if(settings.arguments is String) {
              return MaterialPageRoute(builder: (_) => PhotoViewer(imageUrl: settings.arguments));
            }
            break;
          default:
            return MaterialPageRoute(builder: (_) => ProfilePage());
            break;
        }
      },
    );
  }
}