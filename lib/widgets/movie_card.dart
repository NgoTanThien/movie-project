import 'package:flutter/material.dart';
import 'package:movie/models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onTap;
  MovieCard({super.key, required this.movie, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 350,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Color(0xFF1A1A1A),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                SizedBox(
                  height: 220,
                  width: double.infinity,
                  child: _buildPoster(),
                ),
                _buildInfo()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPoster(){
    return Stack(
      fit: StackFit.expand,
      children: [
        movie.posterUrl.isNotEmpty
            ? Image.network(
          movie.posterUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Color(0xFF2A2A2A),
              child: Icon(Icons.movie, color: Colors.grey,size: 50,),
            );
        } ,
        ) : Container(
          color: Color(0xFF2A2A2A),
          child: Icon(Icons.movie, color: Colors.grey,size: 50,),
        ),
      ],
    );
  }

  Widget _buildInfo() {
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
              movie.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold
              ),
          ),
          SizedBox(height: 4,),
          Text(
            movie.language.isNotEmpty
                ? '${movie.year} • ${movie.language}'
                : '${movie.year}',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
