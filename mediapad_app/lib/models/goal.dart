import 'package:cloud_firestore/cloud_firestore.dart';

class Goal {
  // accepted media list
  final List<String> _mediaTypes = ['books', 'movies'];

  // properties
  late String _mediaType;
  late int _goalCount;

  // constructors
  Goal({required String mediaType, required int goalCount}) {
    this.mediaType = mediaType;
    this.goalCount = goalCount;
  }

  factory Goal.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Goal(mediaType: data!['mediaType'], goalCount: data['goalCount']);
  }

  // getters and setters
  String get mediaType => _mediaType;

  set mediaType(String value) {
    if (!_mediaTypes.contains(value.toLowerCase())) {
      throw Exception('Media type must be one of the accepted types');
    }
    _mediaType = value.toLowerCase();
  }

  int get goalCount => _goalCount;

  set goalCount(int value) {
    if (value < 0) {
      throw Exception('Goal cannot be a negative number');
    }
    _goalCount = value;
  }

  // this is so it can match to the right goal with remove
  @override
  bool operator ==(Object other) =>
      other is Goal && other.mediaType == mediaType;

  // toMap function for firestore inserts
  Map<String, dynamic> toMap() {
    return {'mediaType': mediaType, 'goalCount': goalCount};
  }

  // methods
}
