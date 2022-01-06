// // ignore_for_file: prefer_const_constructors

// import 'package:admin_panel/Screen/dashboard.dart';
// import 'package:admin_panel/providers/app_states.dart';
// import 'package:admin_panel/providers/products_provider.dart';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// void main() async {
//   // These two lines
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();

//   //
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider.value(value: AppState()),
//         ChangeNotifierProvider.value(value: ProductProvider()),
//       ],
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Dashboard(),
//     );
//   }
// }

// ignore_for_file: prefer_const_constructors

import 'package:admin_panel/Screen/dashboard.dart';
import 'package:admin_panel/providers/app_states.dart';
import 'package:admin_panel/providers/products_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(
          create: (context) => AppState(),
        ),
        ChangeNotifierProvider<ProductProvider>(
          create: (context) => ProductProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapShot) {
              if (snapShot.hasData) {
                //  return HomeScreen();
              }
              return Dashboard();
            }),
      ),
    );
  }
}
