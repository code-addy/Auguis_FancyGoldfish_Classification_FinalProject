/*************  ✨ Windsurf Command 🌟  *************/
/// Represents a prediction made by the image classifier model.
library;

import 'package:cloud_firestore/cloud_firestore.dart';

class Prediction {
  /// Unique identifier for the prediction.
  final String id;

  /// Label associated with the prediction.
  final String label;

  /// Confidence of the prediction.
  final double confidence;

  /// Timestamp when the prediction was made.
  final DateTime timestamp;

  /// Path to the image associated with the prediction.
  final String imagePath;

  /// Creates a new prediction with the given values.
  ///
  /// [id] is the unique identifier for the prediction.
  /// [label] is the label associated with the prediction.
  /// [confidence] is the confidence of the prediction.
  /// [timestamp] is the timestamp when the prediction was made.
  /// [imagePath] is the path to the image associated with the prediction.
  Prediction({
    required this.id,
    required this.label,
    required this.confidence,
    required this.timestamp,
    required this.imagePath,
  });

  /// Converts the prediction to a Firestore document.
  ///
  /// Returns a map of the prediction's values.
  // Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'confidence': confidence,
      'timestamp': timestamp,
      'imagePath': imagePath,
    };
  }

  /// Creates a new prediction from a Firestore document.
  ///
  /// [id] is the unique identifier for the prediction.
  /// [map] is the map of values from the Firestore document.
  ///
  /// Returns a new prediction with the given values.
  // Create from Firestore document
  factory Prediction.fromMap(String id, Map<String, dynamic> map) {
    DateTime parsedTime;
    final timeValue = map['timestamp'];

    if (timeValue is Timestamp) {
      parsedTime = timeValue.toDate();
    } else if (timeValue is DateTime) {
      parsedTime = timeValue;
    } else {
      parsedTime = DateTime.now();
    }

    return Prediction(
      id: id,
      label: map['label'] ?? 'Unknown',
      confidence: (map['confidence'] ?? 0.0).toDouble(),
      timestamp: parsedTime,
      imagePath: map['imagePath'] ?? '',
    );
  }
}


/*******  6d1f57ab-e81c-4d1c-904f-95f9dc5f5d6d  *******/