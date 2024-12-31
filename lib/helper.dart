import 'dart:math';

generateRandomNumber() {
  Random random = Random();

  // Generate a random integer between 0 (inclusive) and 100 (exclusive)
  int randomInt = random.nextInt(100) + 6; // Range: 6 to 106
  return randomInt;
}
