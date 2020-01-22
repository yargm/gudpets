import 'package:flutter/material.dart';
import 'package:adoption_app/pages/pages.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/shared/shared.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MyApp());

Controller controller = Controller();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => controller,
      builder: (context) => controller,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryTextTheme: GoogleFonts.lancelotTextTheme(TextTheme()),
          scaffoldBackgroundColor: primaryColor,
          primaryColor: primaryColor,
          accentColor: primaryDark,
          disabledColor: primaryDark,
          primaryColorDark: primaryDark,
          primaryColorLight: primaryLight,
          //botones
          buttonTheme: ButtonThemeData(
            disabledColor: primaryDark,
            buttonColor: secondaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
          //navbar
          bottomAppBarTheme: BottomAppBarTheme(
            color: primaryLight,
          ),
          //iconos
          iconTheme: IconThemeData(
            size: 25,
            color: secondaryDark,
          ),
          primaryIconTheme: IconThemeData(
            color: secondaryDark,
          ),
          //texto
          textTheme: GoogleFonts.titilliumWebTextTheme(TextTheme(
            body1: TextStyle(fontSize: 15),
            button: TextStyle(fontSize: 15, color: primaryColor),
            body2: TextStyle(fontSize: 18),
          )),
          //flotante
          floatingActionButtonTheme:
              FloatingActionButtonThemeData(backgroundColor: secondaryColor),
          //appbar
          appBarTheme: AppBarTheme(
              elevation: 1,
              iconTheme: IconThemeData(size: 30, color: secondaryDark),
              actionsIconTheme: IconThemeData(color: secondaryDark, size: 30),
              textTheme: GoogleFonts.titilliumWebTextTheme(TextTheme(
                  title: TextStyle(color: primaryText, fontSize: 30))),
              color: primaryDark),
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/login',
        home: Home(),
        routes: {
          '/login': (BuildContext context) => LogIn(),
          '/registro_usuario': (BuildContext context) => RegistroUsuario(),
          '/home': (BuildContext context) => Home(),
          '/adopcion': (BuildContext context) => Adopcion(),
          '/perdido': (BuildContext context) => Perdido(),
          '/rescate': (BuildContext context) => Rescate(),
          '/emergencia': (BuildContext context) => Emergencia(),
          '/registro_emergencia': (BuildContext context) => RegistroEmergencia(),
          '/avisos' :(BuildContext context) => AvisosList(),
        },
      ),
    );
  }
}
