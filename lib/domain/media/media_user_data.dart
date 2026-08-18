import 'package:cybershelf/domain/date_only.dart';
import 'package:cybershelf/domain/media_status.dart';

class MediaUserData {
  const MediaUserData({
    required this.status,
    this.rating,
    this.startedOn,
    this.finishedOn,
    this.review,
  });

  final MediaStatus status;
  final int? rating;
  final DateOnly? startedOn;
  final DateOnly? finishedOn;
  final String? review;

  MediaUserData copyWith({
    MediaStatus? status,
    Object? rating = _unset,
    Object? startedOn = _unset,
    Object? finishedOn = _unset,
    Object? review = _unset,
  }) {
    return MediaUserData(
      status: status ?? this.status,
      rating: identical(rating, _unset) ? this.rating : rating as int?,
      startedOn:
      identical(startedOn, _unset) ? this.startedOn : startedOn as DateOnly?,
      finishedOn: identical(finishedOn, _unset)
          ? this.finishedOn
          : finishedOn as DateOnly?,
      review: identical(review, _unset) ? this.review : review as String?,
    );
  }
}

const _unset = Object();