import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:peliculas_app/models/credits_response.dart';
import 'package:peliculas_app/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class CastingCard extends StatelessWidget {

	final int movieId;

  	const CastingCard(this.movieId, {Key? key}) : super(key: key);

  	@override
  	Widget build(BuildContext context) {

		final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

		return FutureBuilder(
			
			future: moviesProvider.getMovieCast(movieId),

			builder: (BuildContext context, AsyncSnapshot<List<Cast>> snapshot){

				if (!snapshot.hasData) {
				  	return Container(
						constraints: BoxConstraints(maxWidth: 100),
						height: 180,
						//color: Colors.cyanAccent,
						child: CupertinoActivityIndicator(),
				  	);
				}

				final List<Cast> movieCast = snapshot.data!;

				return Container(
					margin: const EdgeInsetsDirectional.only(bottom: 30),
					width: double.infinity,
					height: 180,
					//color: Colors.cyanAccent,
					child: ListView.builder(
						itemCount: 10,
						scrollDirection: Axis.horizontal,
						itemBuilder: (context, int index) => _CastCard(movieCast[index]),
					),
				);
			},
		);
  	}
}

class _CastCard extends StatelessWidget {

	final Cast actor;

	const _CastCard(this.actor, {Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		
		return Container(
			margin: const EdgeInsets.symmetric(horizontal: 10),
			width: 110,
			height: 100,
			//color: Colors.deepPurple,
			child: Column(
				children: [
					ClipRRect(
						borderRadius: BorderRadius.circular(20),
						child: FadeInImage(
							placeholder: AssetImage('assets/img/no-image.jpg'), 
							image: NetworkImage(actor.fullProfilePath),
							height: 140,
							width: 100,
							fit: BoxFit.cover,
						),
					),
					
					const SizedBox(height: 5,),

					Text(actor.name, maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,)
				],
			),
		);
	}
}