import 'package:flutter/material.dart';
import 'package:peliculas_app/models/movie.dart';
import 'package:peliculas_app/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate {

	@override
  	// TODO: implement searchFieldLabel
  	String? get searchFieldLabel => 'Buscar pelìcula';

	@override
	List<Widget>? buildActions(BuildContext context) {
		return [
			IconButton(
				icon: Icon(Icons.clear),
				onPressed: () => query = '', 
			)
		];
	}

	@override
	Widget? buildLeading(BuildContext context) {
		return IconButton(
			icon: Icon(Icons.arrow_back),
			onPressed: () => close(context, null), 
		);
	}

	@override
	Widget buildResults(BuildContext context) {
		return Text('buildResults');
	}

	Widget _emptyContainer(){
		return Container(
			child: const Center(
				child: Icon(Icons.movie_creation_outlined, color: Colors.black38, size: 100,),
			),
		);
	}

	@override
	Widget buildSuggestions(BuildContext context) {
		if (query.isEmpty) {
		  	return _emptyContainer();
		}

		final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
		moviesProvider.getSuggestionsByQuery(query);

		return StreamBuilder(
			stream: moviesProvider.suggestionsStrings,
			builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot){
				if (!snapshot.hasData) {
				  return _emptyContainer();
				}

				print('http request');

				final movies = snapshot.data!;

				return ListView.builder(
					itemCount: movies.length,
					itemBuilder: (_, int index) => _MovieItem(movies[index]),
				);
			}
		);
	}

}

class _MovieItem extends StatelessWidget {

	final Movie movie;

  	const _MovieItem(this.movie, {Key? key}) : super(key: key);

  	@override
  	Widget build(BuildContext context) {

		movie.heroId = 'search-${movie.id}';

		return ListTile(
			leading: Hero(
				tag: movie.heroId!,
				child: FadeInImage(
					placeholder: AssetImage('assets/img/loading.gif'), 
					image: NetworkImage( movie.fullPosterMovie ),
					width: 50,
					fit: BoxFit.contain,
				),
			),
			title: Text(movie.title),
			subtitle: Text(movie.originalTitle),
			onTap: (){
				Navigator.pushNamed(context, 'details', arguments: movie);
			},
		);
  	}
}