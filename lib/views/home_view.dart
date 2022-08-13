import 'package:flutter/material.dart';
import 'package:peliculas_app/helpers/search_delegate.dart';
import 'package:peliculas_app/providers/movies_provider.dart';
import 'package:peliculas_app/widgets/card_swiper.dart';
import 'package:peliculas_app/widgets/movie_slider.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {

	
  	const HomeView({Key? key}) : super(key: key);

  	@override
  	Widget build(BuildContext context) {
		
		final movieProvider = Provider.of<MoviesProvider>(context, listen: true);

    	return Scaffold(
			appBar: AppBar(
				title: const Text('Peliculas en cartelera'),
				elevation: 0,
				actions: [
					IconButton(
						icon: const Icon(Icons.search),
						onPressed: () => showSearch(
							context: context, 
							delegate: MovieSearchDelegate(),
						), 
					)
				],
			),
			body: SingleChildScrollView(
				child: Column(
					children: <Widget>[
						Padding(padding: EdgeInsets.only(top: 20)),
						// Peliculas principales
						CardSwiper(movies: movieProvider.onDisplayMovies,),

						Padding(padding: EdgeInsets.only(top: 20)),
						// Listado horizontal
						MovieSlider(
							movies: movieProvider.onPopularMovies, 
							title: 'Peliculas populares', 
							onNextPage: () => movieProvider.getPopularMovies(),
						),
					],
				),
			)
		);
  	}
}