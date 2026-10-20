import 'package:flutter_test/flutter_test.dart';
import 'package:mediapad_app/models/goal.dart';

void main() {
  test('Create a new valid goal', () {
    final Goal goal = Goal(mediaType: 'Books', goalCount: 12);

    expect(goal.mediaType, 'Books');
    expect(goal.goalCount, 12);
  });

  test('Invalid media type should throw error', () {
    expect(
      () => Goal(mediaType: 'Video Games', goalCount: 12),
      throwsA(isA<Exception>()),
    );
  });

  test('Negative goal should throw error', () {
    expect(
      () => Goal(mediaType: 'Movies', goalCount: -2),
      throwsA(isA<Exception>()),
    );
  });
}
