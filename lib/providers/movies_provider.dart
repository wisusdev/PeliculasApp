import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas_app/helpers/debouncer.dart';
import 'package:peliculas_app/models/movie.dart';
import 'package:peliculas_app/models/now_playing.dart';
import 'package:peliculas_app/models/credits_response.dart';
import 'package:peliculas_app/models/popular_response.dart';
import 'package:peliculas_app/models/search_response.dart';

class MoviesProvider extends ChangeNotifier {

	final String _apiKey = '4b785c8ff786860ea59a371f9fbcb91b';
	final String _baseURL = 'api.themoviedb.org';
	final String _language = 'es-ES';

	List<Movie> onDisplayMovies = [];
	List<Movie> onPopularMovies = [];

	Map<int, List<Cast>> movieCast = {};

	int _popularPage = 0;

	final debouncer = Debouncer(duration: Duration(milliseconds: 500));

	final StreamController<List<Movie>> _suggestionsStreamController = StreamController.broadcast();
	Stream<List<Movie>> get suggestionsStrings => _suggestionsStreamController.stream;

  	MoviesProvider(){
		getOnDisplayMovies();
		getPopularMovies();
  	}

	Future<String> _getJsonData(String endPoint, [int page = 1]) async {
		final url = Uri.https( _baseURL, endPoint, {
			'api_key': _apiKey,
			'language' : _language,
			'page' : '$page'
		});

		final response = await http.get(url);

		return response.body;
	}
	
	getOnDisplayMovies() async {

		final jsonData = await _getJsonData('3/movie/now_playing');
		final nowPlayingResponse = NowPlaying.fromJson(jsonData);

		onDisplayMovies = nowPlayingResponse.results;

		notifyListeners();
	}

	getPopularMovies() async {

		_popularPage++;

		final jsonData = await _getJsonData('3/movie/popular', _popularPage );
		final popularResponse = PopularResponse.fromJson( jsonData );
		
		onPopularMovies = [ ...onPopularMovies, ...popularResponse.results ];
		notifyListeners();
	}

	Future<List<Cast>> getMovieCast(int movieId) async {
		// Revisando el mapa
		if (movieCast.containsKey(movieId)) {
			return movieCast[movieId]!;
		}

		final jsonData = await _getJsonData('3/movie/$movieId/credits');
		final creditsResponse = CreditsResponse.fromJson(jsonData);

		movieCast[movieId] = creditsResponse.cast;

		return creditsResponse.cast;
	}

	Future<List<Movie>> searchMovies( String query) async {

		final url = Uri.https( _baseURL, '3/search/movie', {
			'api_key': _apiKey,
			'language' : _language,
			'query' : query
		});

		final response = await http.get(url);
		final searchResponse = SearchResponse.fromJson(response.body);

		return searchResponse.results;
	}

	void getSuggestionsByQuery(String query){
		debouncer.value = '';

		debouncer.onValue = ( value ) async {
			print('Estamos busnanco $value');
			final results = await searchMovies(query);
			_suggestionsStreamController.add(results);
		};

		final timer = Timer.periodic( const Duration(milliseconds: 300), ( value ) {debouncer.value = query; });

		Future.delayed(const Duration(milliseconds: 301)).then((value) => timer.cancel());
	}
}