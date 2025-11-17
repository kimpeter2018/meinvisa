import 'package:meinvisa/data/models/visa_questionnaire_model/visa_questionnaire_model.dart';

extension VisaQuestionnaireX on VisaQuestionnaire {
  /// Dynamically updates a field by its `fieldKey`.
  /// Returns a *new* updated copy.
  VisaQuestionnaire copyWithField(String fieldKey, dynamic value) {
    final json = toJson();
    json[fieldKey] = value;
    return VisaQuestionnaire.fromJson(json);
  }

  /// Dynamically reads a value by its `fieldKey`
  dynamic getField(String fieldKey) {
    final json = toJson();
    return json[fieldKey];
  }

  /// Returns all answered fields as Map<String, dynamic>
  Map<String, dynamic> get answeredFields {
    final json = toJson();
    return Map.fromEntries(
      json.entries.where(
        (e) => e.value != null && e.value.toString().isNotEmpty,
      ),
    );
  }
}
