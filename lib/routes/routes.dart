import 'package:appnotify_adm/pages/home_page.dart';
import 'package:appnotify_adm/pages/login_page.dart';
import 'package:appnotify_adm/pages/notificationsPage/notifications_page.dart';
import 'package:appnotify_adm/pages/selectedNotification/selected_notification.dart';
import 'package:flutter/widgets.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> list =
      <String, WidgetBuilder>{
    '/login': (_) => const LoginPage(),
    '/home': (_) => const HomePage(),
    '/notificacao': (_) => const NotificationsPage(),
    '/selectedNotification': (_) => const SelectedNotification(
          item_id: '',
        ),
  };

  static String initial = '/login';

  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
}
