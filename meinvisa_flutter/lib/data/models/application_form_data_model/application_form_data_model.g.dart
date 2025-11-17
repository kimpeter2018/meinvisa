// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_form_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApplicationFormData _$ApplicationFormDataFromJson(Map json) => $checkedCreate(
  '_ApplicationFormData',
  json,
  ($checkedConvert) {
    final val = _ApplicationFormData(
      preFilledData: $checkedConvert(
        'pre_filled_data',
        (v) => (v as Map?)?.map((k, e) => MapEntry(k as String, e)) ?? const {},
      ),
      additionalData: $checkedConvert(
        'additional_data',
        (v) => (v as Map?)?.map((k, e) => MapEntry(k as String, e)) ?? const {},
      ),
      editedData: $checkedConvert(
        'edited_data',
        (v) => (v as Map?)?.map((k, e) => MapEntry(k as String, e)) ?? const {},
      ),
      fieldVerified: $checkedConvert(
        'field_verified',
        (v) =>
            (v as Map?)?.map((k, e) => MapEntry(k as String, e as bool)) ??
            const {},
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'preFilledData': 'pre_filled_data',
    'additionalData': 'additional_data',
    'editedData': 'edited_data',
    'fieldVerified': 'field_verified',
  },
);

Map<String, dynamic> _$ApplicationFormDataToJson(
  _ApplicationFormData instance,
) => <String, dynamic>{
  'pre_filled_data': instance.preFilledData,
  'additional_data': instance.additionalData,
  'edited_data': instance.editedData,
  'field_verified': instance.fieldVerified,
};
