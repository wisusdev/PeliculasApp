import 'package:flutter/material.dart';
import 'package:peliculas_app/models/movie.dart';

class MovieSlider extends StatefulWidget {

	final List<Movie> movies;
	final String? title;
	final Function onNextPage;

  	const MovieSlider({ Key? key, required this.movies, this.title, required this.onNextPage}) : super(key: key);

	@override
	State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {

	final ScrollController scrollController = ScrollController();

	@override
  	void initState() {
    	super.initState();
    	scrollController.addListener(() {
			if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 500) {
				widget.onNextPage();
			}
		});
  	}

	@override
	void dispose() {
		
		super.dispose();
	}

  	@override
  	Widget build(BuildContext context) {
    	return Container(
			width: double.infinity,
			height: 300,
			color: const Color(0xffffffff),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					
					if (widget.title != null)   
						Padding(
							padding: EdgeInsets.all(8.0),
							child: Center(
								child: Text(widget.title!, style: TextStyle( color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold)),
							),
						),

					const SizedBox(height: 10,),

					Expanded(
						child: ListView.builder(
							controller: scrollController,
							scrollDirection: Axis.horizontal,
							itemCount: widget.movies.length,
							itemBuilder: (BuildContext context, int index) => _MoviePoster(widget.movies[index], '${ widget.title }-$index-${widget.movies[index].id}')
						),
					)
				],
			),
    	);
  	}
}

class _MoviePoster extends StatelessWidget {
	
	final Movie movie;
	final String heroId;

  	const _MoviePoster( this.movie, this.heroId);

  	@override
  	Widget build(BuildContext context) {

		movie.heroId = heroId;

		return Container(
			width: 130,
			height: 190,
			//color: Colors.greenAccent,
			margin: const EdgeInsets.symmetric(horizontal: 10),
			child: Column(
				children: [
					GestureDetector(
						onTap: () => Navigator.pushNamed(
							context,
							'details', // details es la ruta
							arguments: movie
						),
						child: Hero(
							tag: movie.heroId!,
							child: ClipRRect(
								borderRadius: BorderRadius.circular(20),
								child: FadeInImage(
									placeholder: AssetImage('assets/img/no-image.jpg'), 
									image: NetworkImage(movie.fullPosterMovie),
									width: 130,
									height: 190,
									fit: BoxFit.cover,
								),
							),
						),
					),

					const SizedBox(height: 5,),

					Text(
						movie.title, 
						overflow: TextOverflow.ellipsis,
						maxLines: 2,
						textAlign: TextAlign.center,
						style: TextStyle( color: Colors.black)
					)
				],
			),
		);
  	}
}