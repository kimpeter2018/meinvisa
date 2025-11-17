// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visa_recommendation_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VisaRecommendationResponse _$VisaRecommendationResponseFromJson(
  Map json,
) => $checkedCreate(
  '_VisaRecommendationResponse',
  json,
  ($checkedConvert) {
    final val = _VisaRecommendationResponse(
      recommended: $checkedConvert(
        'recommended',
        (v) => VisaOption.fromJson(Map<String, dynamic>.from(v as Map)),
      ),
      alternatives: $checkedConvert(
        'alternatives',
        (v) =>
            (v as List<dynamic>?)
                ?.map(
                  (e) =>
                      VisaOption.fromJson(Map<String, dynamic>.from(e as Map)),
                )
                .toList() ??
            const [],
      ),
      notes: $checkedConvert(
        'notes',
        (v) =>
            (v as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      ),
      applicationMetadata: $checkedConvert(
        'application_metadata',
        (v) => v == null
            ? null
            : ApplicationMetadata.fromJson(Map<String, dynamic>.from(v as Map)),
      ),
    );
    return val;
  },
  fieldKeyMap: const {'applicationMetadata': 'application_metadata'},
);

Map<String, dynamic> _$VisaRecommendationResponseToJson(
  _VisaRecommendationResponse instance,
) => <String, dynamic>{
  'recommended': instance.recommended.toJson(),
  'alternatives': instance.alternatives.map((e) => e.toJson()).toList(),
  'notes': instance.notes,
  'application_metadata': instance.applicationMetadata?.toJson(),
};

_VisaOption _$VisaOptionFromJson(Map json) =>
    $checkedCreate('_VisaOption', json, ($checkedConvert) {
      final val = _VisaOption(
        code: $checkedConvert('code', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        summary: $checkedConvert('summary', (v) => v as String),
        requirements: $checkedConvert(
          'requirements',
          (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
        ),
        notes: $checkedConvert(
          'notes',
          (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$VisaOptionToJson(_VisaOption instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'summary': instance.summary,
      'requirements': instance.requirements,
      'notes': instance.notes,
    };

_ApplicationMetadata _$ApplicationMetadataFromJson(Map json) => $checkedCreate(
  '_ApplicationMetadata',
  json,
  ($checkedConvert) {
    final val = _ApplicationMetadata(
      cityPortals: $checkedConvert(
        'city_portals',
        (v) =>
            (v as List<dynamic>?)
                ?.map(
                  (e) =>
                      CityPortal.fromJson(Map<String, dynamic>.from(e as Map)),
                )
                .toList() ??
            const [],
      ),
      requiredDocuments: $checkedConvert(
        'required_documents',
        (v) =>
            (v as List<dynamic>?)
                ?.map(
                  (e) => RequiredDocument.fromJson(
                    Map<String, dynamic>.from(e as Map),
                  ),
                )
                .toList() ??
            const [],
      ),
      additionalQuestions: $checkedConvert(
        'additional_questions',
        (v) =>
            (v as List<dynamic>?)
                ?.map(
                  (e) => ApplicationQuestion.fromJson(
                    Map<String, dynamic>.from(e as Map),
                  ),
                )
                .toList() ??
            const [],
      ),
      preFilledFields: $checkedConvert(
        'pre_filled_fields',
        (v) =>
            (v as List<dynamic>?)
                ?.map(
                  (e) => PreFilledField.fromJson(
                    Map<String, dynamic>.from(e as Map),
                  ),
                )
                .toList() ??
            const [],
      ),
      estimatedProcessingTime: $checkedConvert(
        'estimated_processing_time',
        (v) => v as String?,
      ),
      appointmentBookingUrl: $checkedConvert(
        'appointment_booking_url',
        (v) => v as String?,
      ),
      specialInstructions: $checkedConvert(
        'special_instructions',
        (v) =>
            (v as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'cityPortals': 'city_portals',
    'requiredDocuments': 'required_documents',
    'additionalQuestions': 'additional_questions',
    'preFilledFields': 'pre_filled_fields',
    'estimatedProcessingTime': 'estimated_processing_time',
    'appointmentBookingUrl': 'appointment_booking_url',
    'specialInstructions': 'special_instructions',
  },
);

Map<String, dynamic> _$ApplicationMetadataToJson(
  _ApplicationMetadata instance,
) => <String, dynamic>{
  'city_portals': instance.cityPortals.map((e) => e.toJson()).toList(),
  'required_documents': instance.requiredDocuments
      .map((e) => e.toJson())
      .toList(),
  'additional_questions': instance.additionalQuestions
      .map((e) => e.toJson())
      .toList(),
  'pre_filled_fields': instance.preFilledFields.map((e) => e.toJson()).toList(),
  'estimated_processing_time': instance.estimatedProcessingTime,
  'appointment_booking_url': instance.appointmentBookingUrl,
  'special_instructions': instance.specialInstructions,
};

_CityPortal _$CityPortalFromJson(Map json) => $checkedCreate(
  '_CityPortal',
  json,
  ($checkedConvert) {
    final val = _CityPortal(
      id: $checkedConvert('id', (v) => v as String),
      city: $checkedConvert('city', (v) => v as String),
      state: $checkedConvert('state', (v) => v as String?),
      portalUrl: $checkedConvert('portal_url', (v) => v as String),
      appointmentRequired: $checkedConvert(
        'appointment_required',
        (v) => v as bool,
      ),
      appointmentBookingUrl: $checkedConvert(
        'appointment_booking_url',
        (v) => v as String?,
      ),
      contactEmail: $checkedConvert('contact_email', (v) => v as String?),
      contactPhone: $checkedConvert('contact_phone', (v) => v as String?),
      address: $checkedConvert('address', (v) => v as String?),
      operatingHours: $checkedConvert('operating_hours', (v) => v as String?),
      specialInstructions: $checkedConvert(
        'special_instructions',
        (v) => v as String?,
      ),
      averageWaitTimeDays: $checkedConvert(
        'average_wait_time_days',
        (v) => (v as num?)?.toInt(),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'portalUrl': 'portal_url',
    'appointmentRequired': 'appointment_required',
    'appointmentBookingUrl': 'appointment_booking_url',
    'contactEmail': 'contact_email',
    'contactPhone': 'contact_phone',
    'operatingHours': 'operating_hours',
    'specialInstructions': 'special_instructions',
    'averageWaitTimeDays': 'average_wait_time_days',
  },
);

Map<String, dynamic> _$CityPortalToJson(_CityPortal instance) =>
    <String, dynamic>{
      'id': instance.id,
      'city': instance.city,
      'state': instance.state,
      'portal_url': instance.portalUrl,
      'appointment_required': instance.appointmentRequired,
      'appointment_booking_url': instance.appointmentBookingUrl,
      'contact_email': instance.contactEmail,
      'contact_phone': instance.contactPhone,
      'address': instance.address,
      'operating_hours': instance.operatingHours,
      'special_instructions': instance.specialInstructions,
      'average_wait_time_days': instance.averageWaitTimeDays,
    };

_RequiredDocument _$RequiredDocumentFromJson(Map json) => $checkedCreate(
  '_RequiredDocument',
  json,
  ($checkedConvert) {
    final val = _RequiredDocument(
      id: $checkedConvert('id', (v) => v as String),
      documentType: $checkedConvert('document_type', (v) => v as String),
      documentName: $checkedConvert('document_name', (v) => v as String),
      description: $checkedConvert('description', (v) => v as String?),
      required: $checkedConvert('required', (v) => v as bool),
      canGenerate: $checkedConvert('can_generate', (v) => v as bool),
      instructions: $checkedConvert('instructions', (v) => v as String?),
      orderIndex: $checkedConvert('order_index', (v) => (v as num).toInt()),
      uploaded: $checkedConvert('uploaded', (v) => v as bool? ?? false),
    );
    return val;
  },
  fieldKeyMap: const {
    'documentType': 'document_type',
    'documentName': 'document_name',
    'canGenerate': 'can_generate',
    'orderIndex': 'order_index',
  },
);

Map<String, dynamic> _$RequiredDocumentToJson(_RequiredDocument instance) =>
    <String, dynamic>{
      'id': instance.id,
      'document_type': instance.documentType,
      'document_name': instance.documentName,
      'description': instance.description,
      'required': instance.required,
      'can_generate': instance.canGenerate,
      'instructions': instance.instructions,
      'order_index': instance.orderIndex,
      'uploaded': instance.uploaded,
    };

_ApplicationQuestion _$ApplicationQuestionFromJson(Map json) => $checkedCreate(
  '_ApplicationQuestion',
  json,
  ($checkedConvert) {
    final val = _ApplicationQuestion(
      id: $checkedConvert('id', (v) => v as String),
      fieldKey: $checkedConvert('field_key', (v) => v as String),
      question: $checkedConvert('question', (v) => v as String),
      questionType: $checkedConvert('question_type', (v) => v as String),
      required: $checkedConvert('required', (v) => v as bool),
      options: $checkedConvert(
        'options',
        (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
      ),
      validationRules: $checkedConvert(
        'validation_rules',
        (v) => (v as Map?)?.map((k, e) => MapEntry(k as String, e)),
      ),
      helpText: $checkedConvert('help_text', (v) => v as String?),
      placeholder: $checkedConvert('placeholder', (v) => v as String?),
      section: $checkedConvert('section', (v) => v as String),
      orderIndex: $checkedConvert('order_index', (v) => (v as num).toInt()),
    );
    return val;
  },
  fieldKeyMap: const {
    'fieldKey': 'field_key',
    'questionType': 'question_type',
    'validationRules': 'validation_rules',
    'helpText': 'help_text',
    'orderIndex': 'order_index',
  },
);

Map<String, dynamic> _$ApplicationQuestionToJson(
  _ApplicationQuestion instance,
) => <String, dynamic>{
  'id': instance.id,
  'field_key': instance.fieldKey,
  'question': instance.question,
  'question_type': instance.questionType,
  'required': instance.required,
  'options': instance.options,
  'validation_rules': instance.validationRules,
  'help_text': instance.helpText,
  'placeholder': instance.placeholder,
  'section': instance.section,
  'order_index': instance.orderIndex,
};

_PreFilledField _$PreFilledFieldFromJson(Map json) => $checkedCreate(
  '_PreFilledField',
  json,
  ($checkedConvert) {
    final val = _PreFilledField(
      formFieldKey: $checkedConvert('form_field_key', (v) => v as String),
      formFieldLabel: $checkedConvert('form_field_label', (v) => v as String),
      formSection: $checkedConvert('form_section', (v) => v as String?),
      sourceFieldKey: $checkedConvert('source_field_key', (v) => v as String),
      value: $checkedConvert('value', (v) => v),
      confidence: $checkedConvert('confidence', (v) => v as String),
      requiresVerification: $checkedConvert(
        'requires_verification',
        (v) => v as bool,
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'formFieldKey': 'form_field_key',
    'formFieldLabel': 'form_field_label',
    'formSection': 'form_section',
    'sourceFieldKey': 'source_field_key',
    'requiresVerification': 'requires_verification',
  },
);

Map<String, dynamic> _$PreFilledFieldToJson(_PreFilledField instance) =>
    <String, dynamic>{
      'form_field_key': instance.formFieldKey,
      'form_field_label': instance.formFieldLabel,
      'form_section': instance.formSection,
      'source_field_key': instance.sourceFieldKey,
      'value': instance.value,
      'confidence': instance.confidence,
      'requires_verification': instance.requiresVerification,
    };
