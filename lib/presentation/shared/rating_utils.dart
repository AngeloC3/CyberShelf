import 'package:flutter/material.dart';

class RatingUtils {
  RatingUtils._();

  static const double starSize = 20.0;
  static const int maxStars = 10;
  static const int maxRating = 100;

  /// Get a color based on the rating value
  static Color getRatingColor(int? rating) {
    if (rating == null) return Colors.grey;
    if (rating >= 95) return const Color(0xFF00C853);
    if (rating >= 85) return const Color(0xFF69F0AE);
    if (rating >= 75) return const Color(0xFFAEEA00);
    if (rating >= 65) return const Color(0xFFFFD600);
    if (rating >= 55) return const Color(0xFFFFAB00);
    if (rating >= 45) return const Color(0xFFFF6D00);
    if (rating >= 35) return const Color(0xFFFF3D00);
    if (rating >= 25) return const Color(0xFFD50000);
    return const Color(0xFFAA0000);
  }

  /// Get a color with alpha for background use
  static Color getRatingColorWithAlpha(int? rating, int alpha) {
    return getRatingColor(rating).withAlpha(alpha);
  }

  /// Get the number of filled stars based on rating (rounded to nearest 5)
  /// Returns a double where .5 represents a half star
  static double getFilledStarsDouble(int? rating) {
    if (rating == null) return 0;
    // Round to nearest 5
    final rounded = (rating / 5).round() * 5;
    // Convert to stars (each star = 10 points)
    return rounded / 10;
  }

  /// Get the number of full stars (for display)
  static int getFullStars(int? rating) {
    return getFilledStarsDouble(rating).floor();
  }

  /// Check if there should be a half star
  static bool hasHalfStar(int? rating) {
    final stars = getFilledStarsDouble(rating);
    return stars - stars.floor() >= 0.5;
  }

  /// Build a row of stars for a rating (with half star support)
  static Widget buildStars(int? rating, {double size = starSize}) {
    final fullStars = getFullStars(rating);
    final halfStar = hasHalfStar(rating);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(fullStars, (index) {
          return Icon(
            Icons.star,
            color: Colors.amber,
            size: size,
          );
        }),
        if (halfStar)
          Icon(
            Icons.star_half,
            color: Colors.amber,
            size: size,
          ),
        ...List.generate(
          maxStars - fullStars - (halfStar ? 1 : 0),
              (index) {
            return Icon(
              Icons.star_border,
              color: Colors.amber,
              size: size,
            );
          },
        ),
      ],
    );
  }

  /// Build a circular progress indicator with the rating number inside
  static Widget buildRatingCircle({
    required int? rating,
    required double size,
    double strokeWidth = 4,
  }) {
    final hasRating = rating != null;
    final color = getRatingColor(rating);
    final progress = hasRating ? rating / maxRating : 0.0;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: hasRating ? color.withAlpha(26) : Colors.grey.shade200,
            ),
          ),
          // Progress indicator
          if (hasRating)
            SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: strokeWidth,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          // Rating number inside
          if (hasRating)
            Text(
              rating.toString(),
              style: TextStyle(
                fontSize: size * 0.32,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            )
          else
            Icon(
              Icons.star_border,
              size: size * 0.4,
              color: Colors.grey.shade400,
            ),
        ],
      ),
    );
  }

  /// Build a compact rating display with circle and stars
  static Widget buildRatingDisplay({
    required int? rating,
    required BuildContext context,
    double circleSize = 80,
    double starSize = 20,
  }) {
    final hasRating = rating != null;

    return Row(
      children: [
        buildRatingCircle(
          rating: rating,
          size: circleSize,
          strokeWidth: 4,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hasRating ? 'Your Rating' : 'Not Rated',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (hasRating) ...[
                const SizedBox(height: 4),
                buildStars(rating, size: starSize),
              ] else ...[
                const SizedBox(height: 4),
                Text(
                  'Tap the edit button to rate this',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  /// Build just the stars as a compact widget
  static Widget buildCompactStars(int? rating, {double size = 16}) {
    return buildStars(rating, size: size);
  }

  /// Build a compact rating circle for list tiles
  static Widget buildCompactRatingCircle(int? rating, {double size = 36}) {
    return buildRatingCircle(
      rating: rating,
      size: size,
      strokeWidth: 3,
    );
  }
}