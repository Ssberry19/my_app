import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  // Основной цвет приложения
  primarySwatch: Colors.deepPurple,
  primaryColor: Colors.deepPurple,
  hintColor: Colors.deepPurpleAccent, // Акцентный цвет для некоторых элементов

  // Общая яркость темы (светлая)
  brightness: Brightness.light,

  // Цвета для Scaffold (фона большинства страниц)
  scaffoldBackgroundColor: Colors.white,

  // Улучшенные цвета для TextSelection (выделение текста)
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colors.deepPurple,
    // ignore: deprecated_member_use
    selectionColor: Colors.deepPurple.withOpacity(0.2), // Мягкое выделение
    selectionHandleColor: Colors.deepPurple,
  ),

  // Тема AppBar
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.deepPurple, // Фон AppBar
    foregroundColor: Colors.white, // Цвет текста и иконок на AppBar
    centerTitle: true, // Заголовок по центру
    elevation: 0, // Убираем тень для более современного вида
    // shadowColor: Colors.deepPurpleAccent, // Можно убрать, если elevation 0
    titleTextStyle: TextStyle( // Стиль текста заголовка
      color: Colors.white,
      fontSize: 22, // Чуть больше
      fontWeight: FontWeight.w700, // Более жирный
      letterSpacing: 0.5, // Небольшой межбуквенный интервал
    ),
  ),

  // Тема ElevatedButton (для кнопок "Далее", "Назад" и т.д.)
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white, // Цвет текста на кнопке
      backgroundColor: Colors.deepPurple, // Цвет фона кнопки
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16), // Чуть больше отступы
      shape: RoundedRectangleBorder( // Закругленные углы
        borderRadius: BorderRadius.circular(12), // Более округлые
      ),
      textStyle: const TextStyle( // Стиль текста кнопки
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      elevation: 4, // Умеренная тень
      // ignore: deprecated_member_use
      shadowColor: Colors.deepPurple.shade300.withOpacity(0.4), // Мягкая тень
    ),
  ),

  // Тема TextButton (для текстовых кнопок без фона)
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.deepPurple, // Цвет текста
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),

  // Тема OutlinedButton (для кнопок с обводкой)
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.deepPurple, // Цвет текста
      side: const BorderSide(color: Colors.deepPurple, width: 1.5), // Обводка
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),

  // Тема TextFormField и DropdownButtonFormField (через InputDecorationTheme)
  inputDecorationTheme: InputDecorationTheme(
    filled: true, // Заполненный фон
    // ignore: deprecated_member_use
    fillColor: Colors.deepPurple.withOpacity(0.05), // Легкий фиолетовый фон
    border: OutlineInputBorder( // Общая граница
      borderRadius: BorderRadius.circular(12), // Более округлые углы
      borderSide: BorderSide.none, // Без видимой границы по умолчанию
    ),
    enabledBorder: OutlineInputBorder( // Граница, когда поле активно, но не в фокусе
      borderRadius: BorderRadius.circular(12),
      // ignore: deprecated_member_use
      borderSide: BorderSide(color: Colors.deepPurple.shade200.withOpacity(0.5), width: 1), // Более мягкая граница
    ),
    focusedBorder: OutlineInputBorder( // Граница, когда поле в фокусе
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.deepPurple, width: 2), // Выраженная обводка
    ),
    errorBorder: OutlineInputBorder( // Граница при ошибке
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder( // Граница при ошибке и в фокусе
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red, width: 2.5),
    ),
    labelStyle: TextStyle(color: Colors.deepPurple.shade700, fontWeight: FontWeight.w500), // Стиль текста метки
    hintStyle: TextStyle(color: Colors.grey.shade600), // Стиль текста подсказки
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14), // Внутренние отступы
  ),

  // Тема Text (для общей типографики)
  textTheme: TextTheme(
    displayLarge: TextStyle(fontSize: 96, fontWeight: FontWeight.w800, color: Colors.deepPurple.shade900, letterSpacing: -1.5),
    displayMedium: TextStyle(fontSize: 60, fontWeight: FontWeight.w700, color: Colors.deepPurple.shade900, letterSpacing: -0.5),
    displaySmall: TextStyle(fontSize: 48, fontWeight: FontWeight.w700, color: Colors.deepPurple.shade800),
    headlineMedium: TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: Colors.deepPurple.shade800, letterSpacing: 0.25),
    headlineSmall: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.deepPurple.shade700),
    titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.deepPurple.shade700, letterSpacing: 0.15),
    titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.deepPurple.shade600, letterSpacing: 0.15),
    titleSmall: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.deepPurple.shade600, letterSpacing: 0.1),
    bodyLarge: const TextStyle(fontSize: 16, color: Colors.black87, letterSpacing: 0.5), // Основной текст
    bodyMedium: const TextStyle(fontSize: 14, color: Colors.black87, letterSpacing: 0.25), // Второстепенный текст
    labelLarge: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600, letterSpacing: 1.25), // Для кнопок и т.п.
    bodySmall: const TextStyle(fontSize: 12, color: Colors.black54, letterSpacing: 0.4), // Мелкий текст
    labelSmall: const TextStyle(fontSize: 11, color: Colors.black54, fontWeight: FontWeight.w400, letterSpacing: 1.5), // Очень мелкий текст
  ),

  // Тема иконок
  iconTheme: const IconThemeData(
    color: Colors.deepPurple,
    size: 26, // Чуть больше размер
    opacity: 0.9,
  ),

  // Тема FloatingActionButton (для плавающих кнопок)
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.deepPurpleAccent,
    foregroundColor: Colors.white,
    elevation: 8,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), // Более округлые
  ),

  // Тема Card (для карточек)
  cardTheme: CardThemeData(
    elevation: 6, // Более мягкая тень
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18), // Более округлые углы
    ),
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Уменьшаем горизонтальные отступы, добавляем вертикальные
    color: Colors.white, // Цвет карточки
    // ignore: deprecated_member_use
    shadowColor: Colors.deepPurple.withOpacity(0.15), // Более мягкая и менее насыщенная тень
  ),

  // Тема Dialog (для всплывающих окон)
  dialogTheme: DialogThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20), // Более округлые
    ),
    backgroundColor: Colors.white,
    elevation: 10,
    titleTextStyle: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: Colors.deepPurple.shade800,
    ),
    contentTextStyle: const TextStyle(
      fontSize: 16,
      color: Colors.black87,
    ),
  ),

  // Тема BottomNavigationBar (для нижней навигационной панели)
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Colors.deepPurple,
    unselectedItemColor: Colors.grey.shade600,
    selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
    elevation: 8,
    type: BottomNavigationBarType.fixed, // Чтобы все элементы были видны
  ),

  // Тема TabBar (для вкладок)
  tabBarTheme: TabBarThemeData(
    labelColor: Colors.deepPurple,
    unselectedLabelColor: Colors.grey.shade600,
    indicatorSize: TabBarIndicatorSize.tab,
    indicator: const UnderlineTabIndicator(
      borderSide: BorderSide(color: Colors.deepPurple, width: 3),
    ),
    labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
  ),

  // Тема Slider (для ползунков)
  sliderTheme: SliderThemeData(
    activeTrackColor: Colors.deepPurple,
    inactiveTrackColor: Colors.deepPurple.shade100,
    thumbColor: Colors.deepPurpleAccent,
    // ignore: deprecated_member_use
    overlayColor: Colors.deepPurple.withOpacity(0.2),
    valueIndicatorColor: Colors.deepPurple.shade700,
    valueIndicatorTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
  ),

  // Тема Switch (для переключателей)
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.deepPurple;
      }
      return Colors.grey.shade400;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.deepPurple.shade200;
      }
      return Colors.grey.shade300;
    }),
  ),

  // Тема Checkbox и Radio
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.deepPurple;
      }
      return Colors.grey.shade400;
    }),
    checkColor: WidgetStateProperty.all(Colors.white),
  ),
  radioTheme: RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.deepPurple;
      }
      return Colors.grey.shade400;
    }),
  ),

  // Тема SnackBar (для всплывающих сообщений)
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.deepPurple.shade700,
    contentTextStyle: const TextStyle(color: Colors.white, fontSize: 16),
    actionTextColor: Colors.deepPurpleAccent.shade100,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    behavior: SnackBarBehavior.floating, // Чтобы SnackBar был плавающим
  ),

  // Тема Tooltip (для всплывающих подсказок)
  tooltipTheme: TooltipThemeData(
    decoration: BoxDecoration(
      // ignore: deprecated_member_use
      color: Colors.deepPurple.shade900.withOpacity(0.9),
      borderRadius: BorderRadius.circular(8),
    ),
    textStyle: const TextStyle(color: Colors.white, fontSize: 14),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
  ),

  // Тема ProgressIndicator (для индикаторов прогресса)
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: Colors.deepPurple,
    linearTrackColor: Colors.deepPurple.shade100,
    circularTrackColor: Colors.deepPurple.shade100,
  ),

  // Тема Chip (для чипов/тегов)
  chipTheme: ChipThemeData(
    backgroundColor: Colors.deepPurple.shade100,
    selectedColor: Colors.deepPurple,
    labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    labelStyle: TextStyle(color: Colors.deepPurple.shade800, fontSize: 14),
    secondaryLabelStyle: const TextStyle(color: Colors.white, fontSize: 14),
    brightness: Brightness.light,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    deleteIconColor: Colors.deepPurple.shade600,
    // ignore: deprecated_member_use
    shadowColor: Colors.deepPurple.withOpacity(0.1),
    elevation: 2,
  ),
);