import 'package:flutter/material.dart';
import 'package:social/UI/screens/photo_viewer.dart';
import 'package:social/UI/screens/post_detail.dart';
import 'package:social/UI/screens/profile.dart';

class ProfileNavigator extends StatelessWidget {
  ProfileNavigator({@required this.navigatorKey, @required this.userId})
      : assert(navigatorKey != null);
  final GlobalKey<NavigatorState> navigatorKey;
  final userId;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        String name = settings.name;
        switch (name) {
          case '/':
            return MaterialPageRoute(builder: (_) => ProfilePage(userId: userId));
            break;
          case '/post':
            if(settings.arguments != null) {
              return MaterialPageRoute(builder: (_) => PostDetails(post: settings.arguments));
            }
            break;
          case '/photo':
            if (settings.arguments is String) {
              return MaterialPageRoute(
                  builder: (_) => PhotoViewer(imageUrl: settings.arguments));
            }
            break;
          case '/profile':
            if (settings.arguments is int) {
              return MaterialPageRoute(builder: (_) => ProfilePage(userId: settings.arguments));
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
