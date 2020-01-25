import 'package:adoption_app/pages/mapaejemplo.dart';
import 'package:flutter/material.dart';
import 'package:adoption_app/pages/pages.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/shared/shared.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:adoption_app/pages/registroRescate.dart';

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
          primaryTextTheme: GoogleFonts.telexTextTheme(),
          scaffoldBackgroundColor: primaryColor,
          primaryColor: primaryColor,
          accentColor: primaryDark,
          disabledColor: primaryDark,
          primaryColorDark: primaryDark,
          primaryColorLight: primaryLight,
          //botones
          buttonTheme: ButtonThemeData(
            
            textTheme: ButtonTextTheme.primary,
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
          accentIconTheme: IconThemeData(
            color: Colors.white,
            size: 25
          ),
          iconTheme: IconThemeData(
            size: 25,
            color: secondaryDark,
          ),
          primaryIconTheme: IconThemeData(
            color: secondaryDark,
          ),
          //texto
          textTheme: GoogleFonts.josefinSansTextTheme(TextTheme(
            body1: TextStyle(fontSize: 15),
            button: TextStyle(fontSize: 15, color: Colors.white),
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
              textTheme: GoogleFonts.josefinSansTextTheme(TextTheme(
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
          '/registro_rescate': (BuildContext context) => RegistroRescate(),
          '/mapaejemplo': (BuildContext context) => MapSample(),
          '/avisos' :(BuildContext context) => AvisosList(),

        },
      ),
    );
  }
}
