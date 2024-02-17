import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  //colorSchemeSeed: Colors.yellow,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
      background: const Color(0xff333333), primary: Colors.grey.shade200, secondary: Colors.grey.shade700),
  inputDecorationTheme: InputDecorationTheme(
      border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(
              10.0)), // OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none),
      filled: true,
      fillColor: Colors.grey.shade900),
  snackBarTheme: SnackBarThemeData(backgroundColor: Colors.grey.shade600),
  appBarTheme: AppBarTheme(backgroundColor: Colors.yellow, foregroundColor: Colors.grey.shade900),
  tabBarTheme: TabBarTheme(
      indicatorColor: Colors.grey.shade900,
      labelColor: Colors.grey.shade900,
      unselectedLabelColor: Colors.grey.shade900.withOpacity(0.5),
      tabAlignment: TabAlignment.fill),

  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)),
          shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
          overlayColor: MaterialStateProperty.all<Color>(Colors.black26))),
);

   // darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        //     primaryColor: Colors.red,
        //     colorScheme: ColorScheme.fromSwatch(
        //         primarySwatch: Colors.yellow,
        //         backgroundColor: Colors.red,
        //         accentColor: Colors.yellow.shade600,
        //         brightness: Brightness.dark)),


 //darkTheme: ThemeData(colorSchemeSeed: Colors.yellow, brightness: Brightness.dark)
        //.copyWith(colorScheme: ColorScheme.fromSeed(seedColor: Colors.red), primaryColor: Colors.green
        // onSecondaryContainer: Colors.red,
        // tertiary: Colors.red,
        // onTertiary: Colors.red,
        // onTertiaryContainer: Colors.red,
        // onBackground: Colors.red,
        // background: Colors.grey.shade800,
        // primaryContainer: Colors.yellow,
        // secondary: Colors.red,
        // onSecondary: Colors.green,
        // onPrimary: Colors.yellow,R
        // onPrimaryContainer: Colors.grey.shade800),
        //),
        //,
        // darkTheme: ThemeData(
        //   useMaterial3: true,
        //   primaryColor: Colors.red,
        //   // buttonTheme: Theme.of(context).buttonTheme.copyWith(
        //   //       colorScheme: ColorScheme.light().copyWith(
        //   //           background: Colors.grey.shade800,
        //   //           primaryContainer: Colors.yellow,
        //   //           secondary: Colors.red,
        //   //           onSecondary: Colors.green,
        //   //           onSecondaryContainer: Colors.red,

        //   //           onPrimary: Colors.yellow,
        //   //           onPrimaryContainer: Colors.grey.shade800),
        //   //     ),
        //   tabBarTheme: const TabBarTheme(
        //       labelColor: Colors.yellow, labelStyle: TextStyle(color: Colors.yellow), indicatorColor: Colors.yellow

        //       //primaryColor: Colors.pink[800], // outdated and has no effect to Tabbar
        //       //accentColor: Colors.cyan[600] // deprecated,
        //       ),
        //   //scaffoldBackgroundColor: Colors.red,
        //   appBarTheme: AppBarTheme(backgroundColor: Colors.grey.shade600),
        //   colorScheme: ColorScheme.dark().copyWith(
        //       onSecondaryContainer: Colors.red,
        //       tertiary: Colors.red,
        //       onTertiary: Colors.red,
        //       onTertiaryContainer: Colors.red,
        //       onBackground: Colors.red,
        //       background: Colors.grey.shade800,
        //       primaryContainer: Colors.yellow,
        //       secondary: Colors.red,
        //       onSecondary: Colors.green,
        //       onPrimary: Colors.yellow,
        //       onPrimaryContainer: Colors.grey.shade800),

        //   // appBarTheme: AppBarTheme(
        //   //   backgroundColor: Colors.red,
        //   // )
        // ),
        // darkTheme: ThemeData(
        //     primarySwatch: Colors.red,
        //     primaryColor: Colors.black,
        //     backgroundColor: Colors.black,
        //     indicatorColor: Color(0xff0E1D36),
        //     //buttonColor: Color(0xff3B3B3B),
        //     hintColor: Color(0xff280C0B),
        //     highlightColor: Color(0xff372901),
        //     hoverColor: Color(0xff3A3A3B),
        //     focusColor: Color(0xff0B2512),
        //     disabledColor: Colors.grey,
        //     //textSelectionColor: Colors.white,
        //     cardColor: Color(0xFF151515),
        //     canvasColor: Colors.black,
        //     brightness: Brightness.dark,
        //     buttonTheme: Theme.of(context).buttonTheme.copyWith(buttonColor: Colors.red)),