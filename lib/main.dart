import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rubik/src/providers/app_provider.dart';
import 'package:rubik/src/ui/screens/test_page.dart';
import 'package:transparent_pointer/transparent_pointer.dart';
import 'package:video_player/video_player.dart';

import 'src/enums/culture.dart';
import 'src/managers/data_manager.dart';
import 'src/managers/page_manager.dart';
import 'src/support/futuristic_custom.dart';
import 'src/support/network/network.dart';
import 'src/ui/components/loading_component.dart';
import 'src/ui/screens/home_page.dart';
import 'src/utils/app_localizations.dart';
import 'src/utils/functions_utils.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) async {
    _MyHomePageState? state =
        context.findAncestorStateOfType<_MyHomePageState>();
    state!.changeLanguage(newLocale);
  }

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyApp> {
  late Locale _locale = const Locale("es", '');
  RubikController _controller = RubikController();
  late List<VideoPlayerController> videoControllerList = [];

  @override
  void initState() {
    for (var i = 0; i < 10000; i++) {
      videoControllerList.add(VideoPlayerController.network(
        'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      )..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {
            //videoControllerList[i].play();
          });
        }));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.black));

    return MaterialApp(
      // supportedLocales: const [
      //   Locale('es', ''),
      //   Locale('en', ''),
      // ],

      navigatorKey: PageManager().navigatorKey,
      locale: _locale,
      onGenerateRoute: (settings) {
        return PageManager().getRoute(settings);
      },
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      theme: ThemeData(
        fontFamily: 'Roboto',
        scrollbarTheme: ScrollbarThemeData(
          trackColor: MaterialStateProperty.all(Colors.grey),
          thumbColor: MaterialStateProperty.all(Colors.grey),
          trackBorderColor: MaterialStateProperty.all(Colors.grey),
        ),
        //primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //theme: ThemeData(fontFamily: 'Sans'),
      title: 'Template',
      home: Scaffold(
        appBar: AppBar(),
        body: _getRubik(),
      ),
    );
  }

  Widget _getRubik() {
    List<Widget> _test = [];
    for (int i = 0; i < 10000; i++) {
      _test.add(
        GestureDetector(
          onTap: () {
            log(i.toString());
            // log(_controller.indexOfCenter.toString());
          },
          child: Container(
            alignment: Alignment.center,
            height: double.infinity,
            width: double.infinity,
            color: Colors.blueGrey,
            margin: const EdgeInsets.all(5),
            child: VideoPlayer(videoControllerList[i]),
          ),
        ),
      );
    }
    return RubikComponent(
      itemList: _test,
      rubikController: _controller,
    );
  }

  changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  getCode(Culture code) {
    switch (code) {
      case Culture.es:
        return 'es';
      case Culture.en:
        return 'en';
    }
  }

  _home() {
    return FuturisticCustom<void>(
      autoStart: true,
      futureBuilder: () => _initApp(),
      busyBuilder: (context) => SizedBox(
          height: MediaQuery.of(context).size.height * 0.37,
          child: loadingComponent(true, colorContainer: Colors.white)),
      dataBuilder: (context, data) => _initPage(),
      onError: (error, retry) => onErrorFunction(
          context: context, error: error as HttpResult?, onRetry: retry),
    );
  }

  _initPage() {
    // if (DataManager().hasSession()) {
    //   // Si ya tengo sesion, el provider nunca se carga por el login (ya que nos saltamos esa pantalla), por lo que ademas de ir al DashBoard, tenemos que cargar el profile de provider
    //   return const HomePage(null);
    // } else {
    //   return const HomePage(null);
    //   // return LoginPage(null);
    // }
  }

  _initApp() async {
    // await DataManager().init();
    // await AppProvider().init();
    //---------

    //---------

    /*
    setState(() {
      _locale = Locale(getCode(DataManager().getCulture()), '');
    });*/
  }
}
