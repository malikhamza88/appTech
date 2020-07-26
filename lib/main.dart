import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:login_example/models/interventionPlanning.dart';
import 'package:login_example/providers/auth_provider.dart';
import 'package:login_example/screens/interventions_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/dashboard_screen.dart';
import 'screens/login_screen.dart';
import 'utils/transition_route_observer.dart';
import 'package:login_example/screens/post_intervention_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor:
          SystemUiOverlayStyle.dark.systemNavigationBarColor));

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  var password = prefs.getString('password');
  print(email);

  runApp(
    ChangeNotifierProvider(
      create: (BuildContext context) => AuthProvider(),
      child: MaterialApp(
        title: 'Login Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          accentColor: Colors.orange,
          cursorColor: Colors.orange,
          // fontFamily: 'SourceSansPro',
          textTheme: TextTheme(
            display2: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 45.0,
              // fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
            button: TextStyle(
              // OpenSans is similar to NotoSans but the uppercases look a bit better IMO
              fontFamily: 'OpenSans',
            ),
            caption: TextStyle(
              fontFamily: 'NotoSans',
              fontSize: 12.0,
              fontWeight: FontWeight.normal,
              color: Colors.deepPurple[300],
            ),
            display4: TextStyle(fontFamily: 'Quicksand'),
            display3: TextStyle(fontFamily: 'Quicksand'),
            display1: TextStyle(fontFamily: 'Quicksand'),
            headline: TextStyle(fontFamily: 'NotoSans'),
            title: TextStyle(fontFamily: 'NotoSans'),
            subhead: TextStyle(fontFamily: 'NotoSans'),
            body2: TextStyle(fontFamily: 'NotoSans'),
            body1: TextStyle(fontFamily: 'NotoSans'),
            subtitle: TextStyle(fontFamily: 'NotoSans'),
            overline: TextStyle(fontFamily: 'NotoSans'),
          ),
        ),
        home: email == null
            ? LoginScreen()
            : DashboardScreen(
                email: email,
                password: password,
              ),
        navigatorObservers: [TransitionRouteObserver()],
        routes: {
          LoginScreen.routeName: (context) => LoginScreen(),
          DashboardScreen.routeName: (context) => DashboardScreen(),
          TaskPage.routeName: (context) => TaskPage(),
          InterventionScreenPage.routeName: (context) =>
              InterventionScreenPage(),
          PlanningPage.routeName: (context) => PlanningPage(),
        },
      ),
    ),
  );
}
