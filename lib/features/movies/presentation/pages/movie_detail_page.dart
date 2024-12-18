import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movies_app_challenge/features/movies/domain/entities/movie.dart';
import 'package:movies_app_challenge/features/movies/presentation/blocs/genres/genres_bloc.dart';
import 'package:movies_app_challenge/features/movies/presentation/blocs/genres/genres_state.dart';
import 'package:movies_app_challenge/features/movies/presentation/widgets/movie_details.dart';
import 'package:movies_app_challenge/features/movies/presentation/widgets/poster.dart';

class MovieDetailPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailPage({required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          movie.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Poster(movie: movie),
              const SizedBox(height: 16, width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.overview,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    MovieDetails(
                      title: localizations.releaseDate,
                      data: movie.releaseDate,
                    ),
                    const SizedBox(height: 8),
                    BlocBuilder<GenresBloc, GenresState>(
                      builder: (context, state) {
                        // Change the genre id's to genre's name in GenreListLoaded
                        if (state is GenreListLoaded) {
                          final genres = state.genres
                              .where(
                                  (genre) => movie.genreIds.contains(genre.id))
                              .map((genre) => genre.name)
                              .join(', ');
                          return MovieDetails(
                            title: localizations.genres,
                            data: genres,
                          );
                        }
                        return const CircularProgressIndicator();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
