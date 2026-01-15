import 'package:tflite_flutter/tflite_flutter.dart';

class FraudDetector {
  Interpreter? _interpreter;
  bool loaded = false;

  /// Load the TFLite model
  Future<void> loadModel(String path) async {
    try {
      _interpreter = await Interpreter.fromAsset(path);
      print(
          "MODEL IS LOADED SUCESSFULY NAME $path: INTERPRETER: $_interpreter");
    } catch (e) {
      print(" FAILED TO LOAD MODEL: $e  ->NAME : $path ");
    }
  }

  /// Run prediction on a single transaction
  Future<int> predict(
    time,
    amount,
  ) async {
    if (!loaded) return 0;

    // Model expects 2 values
    var input = [
      [time.toDouble(), amount]
    ];

    // Output shape [1][1]
    var output = List.generate(1, (_) => List.filled(1, 0.0));

    _interpreter?.run(input, output);

    return output[0][0].round(); // 0 or 1
  }
}
