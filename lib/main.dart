import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:peliculas_app/views/home_view.dart';
import 'package:peliculas_app/views/details_view.dart';
import 'package:peliculas_app/providers/movies_provider.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  	const AppState({Key? key}) : super(key: key);

  	@override
  	Widget build(BuildContext context) {
		return MultiProvider(
			providers: [
				ChangeNotifierProvider( create: (BuildContext context) => MoviesProvider(), lazy: false, ),
			],
			child: const MyApp(),
		);
  	}
}

class MyApp extends StatelessWidget {
  	const MyApp({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
	    return MaterialApp(
					debugShowCheckedModeBanner: false,
	        title: 'Movies',

            initialRoute: 'home',
            routes: {
                'home' : ( BuildContext context ) => const HomeView(),
                'details' : ( BuildContext context ) => const DetailsView(),
            },
            theme: ThemeData.light().copyWith(
                appBarTheme: const AppBarTheme(
                    color: Colors.amber,
                )
            ),
	    );
    }
}