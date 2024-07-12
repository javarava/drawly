import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//Defining MaterialColor shades for black
MaterialColor drawlyBlack = const MaterialColor(
  0xFF000000,
  <int, Color>{
    50: Color(0xFFEEEEEE),
    100: Color(0xFFE0E0E0),
    200: Color(0xFFBDBDBD),
    300: Color(0xFF9E9E9E),
    400: Color(0xFF757575),
    500: Color(0xFF616161),
    600: Color(0xFF424242),
    700: Color(0xFF212121),
    800: Color(0xDD000000),
    900: Color(0xFF000000),
  },
);

//Defining MaterialColor shades for red
MaterialColor drawlyRed = const MaterialColor(
  0xFF000000,
  <int, Color>{
    50: Color(0xFFFEEDED),
    100: Color(0xFFFCD8D9),
    200: Color(0xFFFABEBF),
    300: Color(0xFFF8ABAD),
    400: Color(0xFFF59496),
    500: Color(0xFFF48285),
    600: Color(0xFFF37073),
    700: Color(0xFFF1565A),
    800: Color(0xFFEF3F43),
    900: Color(0xFFED2026),
  },
);

//Defining MaterialColor shades for blue
MaterialColor drawlyBlue = const MaterialColor(
  0xFF000000,
  <int, Color>{
    50: Color(0xFFF0F2FF),
    100: Color(0xFFDDE3FF),
    200: Color(0xFFB3C1FF),
    300: Color(0xFF95AAFF),
    400: Color(0xFF718DFF),
    500: Color(0xFF5174FF),
    600: Color(0xFF2D57FF),
    700: Color(0xFF0033FF),
    800: Color(0xFF0000CC),
    900: Color(0xFF000099),
  },
);

MaterialColor drawlyCream = const MaterialColor(
  0xFF000000,
  <int, Color>{
    50: Color(0xFFFFFDFB),
    100: Color(0xFFFEF9F3),
    200: Color(0xFFFEF5ED),
    300: Color(0xFFFEF1E2),
    400: Color(0xFFFEECD8),
    500: Color(0xFFFEE6CB),
    600: Color(0xFFFEE0C0),
    700: Color(0xFFFEDAB1),
    800: Color(0xFFFED29F),
    900: Color(0xFFFEC88B),
  },
);

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: false,
      primarySwatch: drawlyBlack,
      brightness: Brightness.light,
      //Remove click and tap backgrounds with the 2 lines below
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      scaffoldBackgroundColor: Colors.white,
      fontFamily: 'Inter ',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 50,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        headlineLarge: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontVariations: [FontVariation('wght', 700.0)],
        ),
        headlineMedium: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontVariations: [FontVariation('wght', 700.0)],
        ),
        headlineSmall: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          /* shadows: <Shadow>[
            Shadow(
              offset: Offset(1.0, 1.0),
              blurRadius: 1.0,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ], */
        ),
        titleLarge: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w900,
          fontSize: 22.0,
        ),
        bodySmall: TextStyle(
          color: Colors.black,
        ),
        bodyMedium: TextStyle(
          color: Colors.black,
        ),
        bodyLarge: TextStyle(
          color: Colors.black,
        ),
      ).apply(
        bodyColor: Colors.black,
        displayColor: Colors.black,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: drawlyBlack.shade900),
        actionsIconTheme: IconThemeData(
          color: drawlyBlack.shade900,
          size: 28,
        ),
        centerTitle: true,
        elevation: 2,
        toolbarHeight: 48,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: drawlyBlack.shade900,
        unselectedLabelColor: drawlyBlack.shade500,
        indicatorColor: drawlyBlack.shade600,
        dividerColor: drawlyBlack.shade300,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: drawlyBlack.shade800,
      ),
      tooltipTheme: TooltipThemeData(
        padding: const EdgeInsets.fromLTRB(8, 3, 8, 3),
        verticalOffset: 5,
        textStyle: const TextStyle(
          fontSize: 10,
          color: Colors.white,
        ),
        decoration: BoxDecoration(
          color: drawlyBlack.shade900.withOpacity(0.5),
          borderRadius: BorderRadius.zero,
        ),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: Colors.white,
        headerBackgroundColor: drawlyBlack.shade900,
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      primarySwatch: Colors.grey,
      brightness: Brightness.dark,
      //Remove click and tap backgrounds with the 2 lins below
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      scaffoldBackgroundColor: const Color.fromARGB(249, 39, 39, 39),
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 50,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        headlineLarge: TextStyle(
          color: Color.fromARGB(255, 217, 21, 7),
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
          fontVariations: [FontVariation('wght', 700.0)],
        ),
        headlineMedium: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
          fontVariations: [FontVariation('wght', 700.0)],
        ),
        headlineSmall: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          shadows: <Shadow>[
            Shadow(
              offset: Offset(1.0, 1.0),
              blurRadius: 1.0,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ],
        ),
        titleLarge: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 22.0,
          color: Colors.white,
        ),
      ).apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 43, 43, 43),
        iconTheme: IconThemeData(color: Color.fromARGB(255, 255, 255, 255)),
        actionsIconTheme: IconThemeData(
          color: Color.fromARGB(255, 255, 255, 255),
          size: 28,
        ),
        centerTitle: true,
        elevation: 2,
        toolbarHeight: 48,
        titleTextStyle: TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  //------------------ MAINSTYLES ------------------

  static appTitle() {
    return 'Drawly';
  }

  static buttonNavigationText() {
    return TextStyle(
      fontSize: 11,
      color: Colors.grey[700],
    );
  }

  static buttonNavigationSelectedText() {
    return TextStyle(
      fontSize: 11,
      color: drawlyBlack.shade900,
    );
  }

  static sliverAppBarBackLeading(context) {
    return InkWell(
      child: const Icon(
        Icons.chevron_left,
        color: Colors.white,
        size: 28,
      ),
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }

  //------------------ TEXTSTYLES ------------------

  static text9() {
    return const TextStyle(
      fontSize: 9,
    );
  }

  static text9Bold() {
    return const TextStyle(
      fontSize: 9,
      fontWeight: FontWeight.bold,
    );
  }

  static text10() {
    return const TextStyle(
      fontSize: 10,
    );
  }

  static text11() {
    return const TextStyle(
      fontSize: 11,
    );
  }

  static text11Bold() {
    return const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.bold,
    );
  }

  static text12() {
    return const TextStyle(
      fontSize: 12,
      color: Colors.black,
    );
  }

  static text12Inverted() {
    return const TextStyle(
      fontSize: 12,
      color: Colors.white,
    );
  }

  static formDescription() {
    return TextStyle(
      fontSize: 12,
      color: drawlyBlack.shade700,
    );
  }

  static text12Bold() {
    return const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
  }

  static text12Red() {
    return const TextStyle(
      fontSize: 12,
      color: Colors.red,
    );
  }

  static text12RedBold() {
    return const TextStyle(
      fontSize: 12,
      color: Colors.red,
      fontWeight: FontWeight.bold,
    );
  }

  static text12Grey500() {
    return TextStyle(
      fontSize: 12,
      color: Colors.grey[500],
    );
  }

  static text13() {
    return const TextStyle(
      fontSize: 13,
      color: Colors.black,
    );
  }

  static text13Bold() {
    return const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
  }

  static text14() {
    return const TextStyle(
      fontSize: 14,
      color: Colors.black,
    );
  }

  static text14Bold() {
    return const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
  }

  static text14Inverted() {
    return const TextStyle(
      fontSize: 14,
      color: Colors.white,
    );
  }

  static text14InvertedBold() {
    return const TextStyle(
      fontSize: 14,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );
  }

  static text15() {
    return const TextStyle(
      fontSize: 15,
      color: Colors.black,
    );
  }

  static text15Bold() {
    return const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
  }

  static text15Grey700() {
    return TextStyle(
      fontSize: 15,
      color: Colors.grey[700],
    );
  }

  static text16() {
    return const TextStyle(
      fontSize: 16,
      color: Colors.black,
    );
  }

  static text16Inverted() {
    return const TextStyle(
      fontSize: 16,
      color: Colors.white,
    );
  }

  static text16InvertedBold() {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
  }

  static text16Bold() {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
  }

  static text16RedBold() {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.red,
    );
  }

  static text16ExtraBold() {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w900,
      color: Colors.black,
    );
  }

  static text16Grey700() {
    return TextStyle(
      fontSize: 16,
      color: Colors.grey[700],
    );
  }

  static text18() {
    return const TextStyle(
      fontSize: 18,
      color: Colors.black,
    );
  }

  static text18Bold() {
    return const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
  }

  static text18ExtraBold() {
    return const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w900,
      color: Colors.black,
    );
  }

  static text18InvertedBold() {
    return const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
  }

  static text20Bold() {
    return const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
  }

  static text20ExtraBold() {
    return const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w900,
      color: Colors.black,
    );
  }

  static text22ExtraBold() {
    return const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w900,
      color: Colors.black,
    );
  }

  static text16Grey700Bold() {
    return TextStyle(
      fontSize: 16,
      color: Colors.grey[700],
      fontWeight: FontWeight.bold,
    );
  }

  static text16Grey700BoldUndeline() {
    return TextStyle(
      fontSize: 16,
      color: Colors.grey[700],
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.underline,
    );
  }

  static text16Blue600Bold() {
    return TextStyle(
      fontSize: 16,
      color: Colors.blue[600],
      fontWeight: FontWeight.bold,
    );
  }

  static text16Green600Bold() {
    return TextStyle(
      fontSize: 16,
      color: Colors.green[600],
      fontWeight: FontWeight.bold,
    );
  }

  static text14Red800() {
    return TextStyle(
      fontSize: 14,
      color: drawlyRed.shade800,
    );
  }

  static text14Red800Bold() {
    return TextStyle(
      fontSize: 14,
      color: drawlyRed.shade800,
      fontWeight: FontWeight.bold,
    );
  }

  static text16Red800() {
    return TextStyle(
      fontSize: 16,
      color: drawlyRed.shade800,
    );
  }

  static text16Red800Bold() {
    return TextStyle(
      fontSize: 16,
      color: drawlyRed.shade800,
      fontWeight: FontWeight.bold,
    );
  }

  static text18Inverted() {
    return const TextStyle(
      fontSize: 18,
      color: Colors.white,
    );
  }

  static text18InvertedShadow() {
    return TextStyle(
      fontSize: 18,
      color: Colors.white,
      shadows: <Shadow>[
        Shadow(
          offset: const Offset(2.0, 2.0),
          blurRadius: 3.0,
          color: drawlyBlack.shade400,
        ),
      ],
    );
  }

  static text18BoldInvertedShadow() {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      shadows: <Shadow>[
        Shadow(
          offset: const Offset(2.0, 2.0),
          blurRadius: 3.0,
          color: drawlyBlack.shade400,
        ),
      ],
    );
  }

  static text18InvertedExtraBoldShadow() {
    return TextStyle(
      fontSize: 18,
      color: Colors.white,
      fontWeight: FontWeight.w900,
      shadows: <Shadow>[
        Shadow(
          offset: const Offset(2.0, 2.0),
          blurRadius: 3.0,
          color: drawlyBlack.shade400,
        ),
      ],
    );
  }

  static text20Grey700Bold() {
    return TextStyle(
      fontSize: 20,
      color: Colors.grey[700],
      fontWeight: FontWeight.bold,
    );
  }

  static text20Red800Bold() {
    return TextStyle(
      fontSize: 20,
      color: drawlyRed.shade800,
      fontWeight: FontWeight.bold,
    );
  }

  static text22Red800Bold() {
    return TextStyle(
      fontSize: 22,
      color: drawlyRed.shade800,
      fontWeight: FontWeight.bold,
    );
  }

  static text22ExtraBoldShadow() {
    return const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w900,
      shadows: <Shadow>[
        Shadow(
          offset: Offset(2.0, 2.0),
          blurRadius: 3.0,
          color: Colors.white,
        ),
      ],
    );
  }

  static text22InvertedExtraBoldShadow() {
    return TextStyle(
      fontSize: 22,
      color: Colors.white,
      fontWeight: FontWeight.w900,
      shadows: <Shadow>[
        Shadow(
          offset: const Offset(3.0, 3.0),
          blurRadius: 5.0,
          color: drawlyBlack.shade400,
        ),
      ],
    );
  }

  static text22CreamExtraBoldShadow() {
    return TextStyle(
      fontSize: 22,
      color: drawlyCream.shade900,
      fontWeight: FontWeight.w900,
      shadows: <Shadow>[
        Shadow(
          offset: const Offset(2.0, 2.0),
          blurRadius: 3.0,
          color: drawlyBlack.shade400,
        ),
      ],
    );
  }

  static text28ExtraBold() {
    return const TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w900,
      color: Colors.black,
    );
  }

  static grey1cir10BoxDecoration() {
    return BoxDecoration(
      //  color: drawlyCream.shade300,
      border: Border.all(
        width: 1,
        color: drawlyBlack.shade300,
      ),
      borderRadius: const BorderRadius.all(
        Radius.circular(10),
      ),
    );
  }

  static grey2cir10BoxDecoration() {
    return BoxDecoration(
      border: Border.all(
        width: 2,
        color: const Color.fromARGB(255, 200, 200, 200),
      ),
      borderRadius: const BorderRadius.all(
        Radius.circular(10),
      ),
    );
  }

  static grey1cir0TopOnlyBoxDecoration() {
    return BoxDecoration(
      border: Border(top: BorderSide(width: 1.0, color: drawlyBlack.shade300)),
    );
  }

  static grey1cir0TopAndBottomDecoration() {
    return BoxDecoration(
      border: Border(
        top: BorderSide(width: 1.0, color: drawlyBlack.shade300),
        bottom: BorderSide(width: 1.0, color: drawlyBlack.shade300),
      ),
    );
  }

  static redTags5CirBoxDecoration() {
    return BoxDecoration(
      color: drawlyRed.shade900,
      borderRadius: const BorderRadius.all(
        Radius.circular(5),
      ),
    );
  }

  //------------------ INPUTS ------------------

  static noBorderInput() {
    return const InputDecoration(
      border: InputBorder.none,
      contentPadding: EdgeInsets.all(0),
    );
  }

  static noBorderInputDecoration() {
    return InputDecoration(
      isDense: true,
      border: AppTheme.noInputBorder(),
      enabledBorder: AppTheme.noInputBorder(),
      focusedBorder: AppTheme.noInputBorder(),
      errorBorder: AppTheme.noInputBorder(),
      focusedErrorBorder: AppTheme.noInputBorder(),
      contentPadding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
      filled: true,
      fillColor: Colors.white,
      alignLabelWithHint: false,
    );
  }

  static grey1OutlinedFieldWithHint(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 12),
      border: AppTheme.appBorderGrey1(),
      enabledBorder: AppTheme.appEnabledBorderGrey(),
      focusedBorder: AppTheme.appFocusedBorderGrey(),
      contentPadding: const EdgeInsets.all(10),
    );
  }

  static greyfilled1OutlinedFieldWoLabel() {
    return InputDecoration(
      border: AppTheme.appBorderGrey(),
      enabledBorder: AppTheme.appEnabledBorderGrey(),
      focusedBorder: AppTheme.appFocusedBorderGrey(),
      errorBorder: AppTheme.appErrorBorderRed(),
      focusedErrorBorder: AppTheme.appErrorBorderRed(),
      contentPadding: const EdgeInsets.all(10),
      filled: true,
      fillColor: Colors.white,
    );
  }

  static greyfilled1OutlinedField(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(fontSize: 14),
      border: AppTheme.appBorderGrey(),
      enabledBorder: AppTheme.appEnabledBorderGrey(),
      focusedBorder: AppTheme.appFocusedBorderGrey(),
      errorBorder: AppTheme.appErrorBorderRed(),
      focusedErrorBorder: AppTheme.appErrorBorderRed(),
      contentPadding: const EdgeInsets.all(10),
      filled: true,
      fillColor: Colors.white,
    );
  }

  static greyfilled1OutlinedFieldDisabled(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(fontSize: 14),
      border: AppTheme.appBorderGrey(),
      enabledBorder: AppTheme.appEnabledBorderGrey(),
      disabledBorder: AppTheme.appEnabledBorderGrey(),
      focusedBorder: AppTheme.appFocusedBorderGrey(),
      errorBorder: AppTheme.appErrorBorderRed(),
      focusedErrorBorder: AppTheme.appErrorBorderRed(),
      contentPadding: const EdgeInsets.all(10),
      filled: true,
      fillColor: Colors.white,
    );
  }

  static greyfilled1OutlinedFieldWithHint(String labelText, String hintText) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      labelStyle: const TextStyle(fontSize: 14),
      border: AppTheme.appBorderGrey(),
      enabledBorder: AppTheme.appEnabledBorderGrey(),
      focusedBorder: AppTheme.appFocusedBorderGrey(),
      errorBorder: AppTheme.appErrorBorderRed(),
      focusedErrorBorder: AppTheme.appErrorBorderRed(),
      contentPadding: const EdgeInsets.all(10),
      filled: true,
      fillColor: Colors.white,
    );
  }

  static greyfilledOutlinedField(String hinttext) {
    return InputDecoration(
      hintText: hinttext,
      hintStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 14,
      ),
      border: AppTheme.appBorderGrey(),
      enabledBorder: AppTheme.appEnabledBorderGrey(),
      focusedBorder: AppTheme.appFocusedBorderGrey(),
      errorBorder: AppTheme.appErrorBorderRed(),
      focusedErrorBorder: AppTheme.appErrorBorderRed(),
      contentPadding: const EdgeInsets.all(10),
      filled: true,
      fillColor: Colors.white,
    );
  }

  static greyfilledOutlinedFieldWithSuffixIcon(
      String hinttext, Icon suffixIcon, Color suffixIconColor) {
    return InputDecoration(
      hintText: hinttext,
      hintStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 14,
      ),
      border: AppTheme.appBorderGrey(),
      enabledBorder: AppTheme.appEnabledBorderGrey(),
      focusedBorder: AppTheme.appFocusedBorderGrey(),
      errorBorder: AppTheme.appErrorBorderRed(),
      focusedErrorBorder: AppTheme.appErrorBorderRed(),
      contentPadding: const EdgeInsets.all(10),
      filled: true,
      fillColor: Colors.white,
      suffixIcon: suffixIcon,
      suffixIconColor: suffixIconColor,
    );
  }

  static greyfilledOutlinedPassword(String hinttext) {
    return InputDecoration(
      hintText: hinttext,
      hintStyle: const TextStyle(
        color: Colors.grey,
      ),
      border: AppTheme.appBorderGrey(),
      enabledBorder: AppTheme.appEnabledBorderGrey(),
      focusedBorder: AppTheme.appFocusedBorderGrey(),
      errorBorder: AppTheme.appErrorBorderRed(),
      focusedErrorBorder: AppTheme.appErrorBorderRed(),
      contentPadding: const EdgeInsets.all(10),
      filled: true,
      fillColor: Colors.white,
    );
  }

  static greyfilledOutlinedSwitch(String hinttext) {
    return InputDecoration(
      hintText: hinttext,
      hintStyle: const TextStyle(
        color: Colors.grey,
      ),
      border: AppTheme.appBorderGrey(),
      enabledBorder: AppTheme.appEnabledBorderGrey(),
      focusedBorder: AppTheme.appFocusedBorderGrey(),
      errorBorder: AppTheme.appErrorBorderRed(),
      focusedErrorBorder: AppTheme.appErrorBorderRed(),
      contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      filled: true,
      fillColor: Colors.white,
    );
  }

  static greyfilledOutlinedDate(String hinttext) {
    return InputDecoration(
      hintText: hinttext,
      hintStyle: const TextStyle(
        color: Colors.grey,
      ),
      border: AppTheme.appBorderGrey(),
      enabledBorder: AppTheme.appEnabledBorderGrey(),
      focusedBorder: AppTheme.appFocusedBorderGrey(),
      errorBorder: AppTheme.appErrorBorderRed(),
      focusedErrorBorder: AppTheme.appErrorBorderRed(),
      contentPadding: const EdgeInsets.all(10),
      filled: true,
      fillColor: Colors.white,
      suffixIcon: const Icon(
        Icons.calendar_month,
        size: 18,
        color: Color.fromARGB(255, 95, 95, 95),
      ),
    );
  }

  //border

  static noInputBorder() {
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(0.0)),
      borderSide: BorderSide(
        width: 0,
        //color: Colors.white,
        style: BorderStyle.none,
      ),
    );
  }

  static appBorderGrey1() {
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
      borderSide: BorderSide(
        width: 1,
        style: BorderStyle.solid,
        color: Color.fromARGB(255, 147, 147, 147),
      ),
    );
  }

  static appBorderGrey() {
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
      borderSide: BorderSide(
        width: 2,
        style: BorderStyle.solid,
        color: Color.fromARGB(255, 147, 147, 147),
      ),
    );
  }

  //enabledBorder
  static appEnabledBorderGrey() {
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
      borderSide: BorderSide(
        width: 2,
        style: BorderStyle.solid,
        color: Color.fromARGB(255, 147, 147, 147),
      ),
    );
  }

  //focusedBorder
  static appFocusedBorderGrey() {
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
      borderSide: BorderSide(
        width: 2,
        style: BorderStyle.solid,
        color: Color.fromARGB(255, 106, 106, 106),
      ),
    );
  }

  //focusedBorder
  static appFocusedBorderGrey1() {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(4.0)),
      borderSide: BorderSide(
        width: 2,
        style: BorderStyle.solid,
        color: drawlyBlack.shade300,
      ),
    );
  }

  //errorBorder
  static appErrorBorderRed() {
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
      borderSide: BorderSide(
        width: 2,
        style: BorderStyle.solid,
        color: Colors.red,
      ),
    );
  }

  //Buttons

  static blackButton() {
    return TextButton.styleFrom(
      padding: const EdgeInsets.fromLTRB(20, 2, 20, 2),
      foregroundColor: Colors.white,
      backgroundColor: drawlyBlack.shade800,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    );
  }

  static blackButtonContainer(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
        border: Border.all(style: BorderStyle.none),
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        color: drawlyBlack.shade900,
      ),
      child: Text(
        text,
        style: AppTheme.text18InvertedBold(),
        textAlign: TextAlign.center,
      ),
    );
  }

  static blackGradientContainer(Widget widget) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(style: BorderStyle.none),
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        gradient: LinearGradient(
          colors: [
            drawlyBlack.shade900,
            drawlyBlack.shade600,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: widget,
    );
  }

  static greyGradientContainer(Widget widget) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(
          style: BorderStyle.solid,
          width: 2,
          color: drawlyBlack.shade400,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        gradient: LinearGradient(
          colors: [
            drawlyBlack.shade100,
            drawlyBlack.shade50,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: widget,
    );
  }

  static redButton() {
    return TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 12),
      foregroundColor: Colors.white,
      backgroundColor: drawlyRed.shade900,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
    );
  }

  static redButton2() {
    return TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
      foregroundColor: Colors.white,
      backgroundColor: drawlyRed.shade900,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
    );
  }

  static redFadedButton() {
    return TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 12),
      foregroundColor: Colors.white,
      backgroundColor: drawlyRed.shade700,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
    );
  }

  static greenButton() {
    return TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 12),
      foregroundColor: Colors.white,
      backgroundColor: Colors.green[700],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
    );
  }

  static blueButton() {
    return TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 12),
      foregroundColor: Colors.white,
      backgroundColor: Colors.blue[700],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
    );
  }

  static outlinedButton1() {
    return OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      side: BorderSide(
        width: 2,
        color: drawlyBlack.shade300,
      ),
    );
  }
}
