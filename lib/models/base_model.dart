/// Base model class for all models
/// All models should extend this class
abstract class BaseModel {
  /// Convert model to JSON
  Map<String, dynamic> toJson();

  /// Create model from JSON
  BaseModel fromJson(Map<String, dynamic> json);
}
