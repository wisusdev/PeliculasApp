import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:peliculas_app/models/movie.dart';

class CardSwiper extends StatelessWidget {

	final List<Movie> movies;

  	const CardSwiper({ Key? key, required this.movies }) : super(key: key);

  	@override
  	Widget build(BuildContext context) {

		final size = MediaQuery.of(context).size;

		if (movies.isEmpty) {
		  	return Container(
				width: double.infinity,
				height: size.height * 0.5,
				child: const Center(
					child: CircularProgressIndicator(),
				),
		  	);
		}

    	return Container(
			width: double.infinity,
			height: size.height * 0.5, // 0.5 = 50%
			color: Colors.white60,
			child: Swiper(
				itemCount: movies.length, 
				layout: SwiperLayout.STACK,
				itemWidth: size.width * 0.6,
				itemHeight: size.height * 0.5,
				itemBuilder: (BuildContext context, int index){

					final movie = movies[index];
					movie.heroId = 'swiper-${movie.id}';

					return GestureDetector(
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
									placeholder: const AssetImage('assets/img/no-image.jpg'), 
									image: NetworkImage(movie.fullPosterMovie),
									fit: BoxFit.cover,
								),
							),
						),
					);
				},
			),
		);
  	}
}