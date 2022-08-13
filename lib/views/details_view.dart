import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:peliculas_app/models/movie.dart';
import 'package:peliculas_app/widgets/casting_card.dart';

class DetailsView extends StatelessWidget {

  	const DetailsView({Key? key}) : super(key: key);

  	@override
  	Widget build(BuildContext context) {
		// TODO: Cambiar a uns instancia de movie

		final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;

    	return Scaffold(
			body: CustomScrollView(
				slivers: [
					_CustomAppbar(movie),

					SliverList(
						delegate: SliverChildListDelegate([
							_PosterAndTitle(movie),
							_OverView(movie),
							CastingCard(movie.id),
						])
					),
				],
			),
		);
  	}
}

class _CustomAppbar extends StatelessWidget {

	final Movie movie;

  	const _CustomAppbar(this.movie, { Key? key }) : super(key: key);

  	@override
  	Widget build(BuildContext context) {
		return SliverAppBar(
			backgroundColor: Colors.indigo,
			expandedHeight: 200,
			floating: false,
			pinned: true,
			flexibleSpace: FlexibleSpaceBar(
				centerTitle: true,
				titlePadding: const EdgeInsets.all(0),
				title: Container(
					width: double.infinity,
					alignment: Alignment.bottomCenter,
					padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
					color: Colors.black12,
					child: Text(movie.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center,),
				),
				background: FadeInImage(
					placeholder: AssetImage('assets/img/loading.gif'), 
					image: NetworkImage(movie.fullBackdropPath),
					fit: BoxFit.cover,
				),
			),

		);
  	}
}

class _PosterAndTitle extends StatelessWidget {

	final Movie movie;

  	const _PosterAndTitle(this.movie,{ Key? key }) : super(key: key);

  	@override
  	Widget build(BuildContext context) {
		
		final TextTheme textTheme = Theme.of(context).textTheme;
		final size = MediaQuery.of(context).size;

		return Container(
			margin: const EdgeInsets.only(top: 20),
			padding: const EdgeInsets.symmetric(horizontal: 20),
			child: Row(
				children: [
					Hero(
						tag: movie.heroId!,
						child: ClipRRect(
							borderRadius: BorderRadius.circular(20),
							child: FadeInImage(
								placeholder: AssetImage('assets/img/no-image.jpg'), 
								image: NetworkImage(movie.fullPosterMovie),
								height: 150,
								//width: 110,
							),
						),
					),

					const SizedBox(width: 20,),

					ConstrainedBox(
						constraints: BoxConstraints( maxWidth: size.width - 190 ),
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								Text( movie.title, style: textTheme.headline5, overflow: TextOverflow.ellipsis, maxLines: 2 ),
								Text( movie.originalTitle, style: textTheme.subtitle1, overflow: TextOverflow.ellipsis, maxLines: 2),
								Row(
									children: [
										Icon( Icons.star_outline, size: 15, color: Colors.grey ),
										SizedBox( width: 5 ),
										Text( '${movie.voteAverage}', style: textTheme.caption )
									],
								)
							],
						),
					),
				],
			),
		);
  	}
}

class _OverView extends StatelessWidget {
	final Movie movie;

  	const _OverView(this.movie, { Key? key }) : super(key: key);

  	@override
  	Widget build(BuildContext context) {
		return Container(
			padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
			child: Text(
				movie.overview,
				textAlign: TextAlign.justify,
				style: Theme.of(context).textTheme.subtitle1,
			),
		);
  	}
}