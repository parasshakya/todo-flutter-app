import 'dart:math';

generateRandomNumber() {
  Random random = Random();

  // Generate a random integer between 0 (inclusive) and 100 (exclusive)
  int randomInt = random.nextInt(100); // Range: 0 to 99
  return randomInt;
}
