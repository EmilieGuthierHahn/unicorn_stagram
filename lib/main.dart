// lib/main.dart

// On importe les outils de base de Flutter.
import 'package:flutter/material.dart';
// On importe le paquet pour charger notre fichier .env.
import 'package:flutter_dotenv/flutter_dotenv.dart';
// On importe le paquet pour les polices d'écriture.
import 'package:google_fonts/google_fonts.dart';
// On importe notre Provider pour les likes.
import 'package:provider/provider.dart';
import 'package:unicorn_stagram/providers/Likes_provider.dart';
// On importe notre page d'accueil.
import 'package:unicorn_stagram/screens/home_screen.dart'; 




// C'est la fonction qui lance toute l'application.
// Elle est "async" car elle doit attendre que le fichier .env soit chargé.
Future<void> main() async {
  // On s'assure que Flutter est prêt avant de faire quoi que ce soit.
  WidgetsFlutterBinding.ensureInitialized();
  // On charge les variables (notre clé d'API) depuis le fichier .env.
  await dotenv.load(fileName: ".env");

  // On lance l'application.
  runApp(
    // ChangeNotifierProvider permet de rendre notre LikesProvider accessible
    // partout dans l'application. C'est lui qui gère l'état des likes.
    ChangeNotifierProvider(
      create: (context) => LikesProvider(),
      child: const MyApp(),
    ),
  );
}

// C'est le widget principal de notre application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp est le widget qui configure l'application (titre, thème, etc.).
    return MaterialApp(
      title: 'Unicor_stagram',
      // On enlève la petite bannière "Debug" en haut à droite.
      debugShowCheckedModeBanner: false,
      // On définit le thème "Licorne" de notre application.
      theme: ThemeData(
        // On choisit nos couleurs principales.
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pinkAccent,
          brightness: Brightness.light,
          primary: Colors.pink.shade200,
          secondary: Colors.purple.shade200,
        ),
        // On choisit les polices d'écriture.
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ).copyWith(
          headlineSmall: GoogleFonts.pacifico(fontSize: 22),
          bodyMedium: const TextStyle(fontSize: 15),
          bodySmall: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: Colors.grey.shade700),
        ),
        // On personnalise l'apparence de la barre de titre.
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0.5,
          centerTitle: true,
          titleTextStyle:
              GoogleFonts.pacifico(fontSize: 24, color: Colors.pink.shade300),
        ),
        useMaterial3: true,
      ),
      // On dit à l'application quelle page afficher au démarrage.
      home: const HomeScreen(),
    );
  }
}
