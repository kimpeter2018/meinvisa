import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meinvisa/features/visa_recommendation/repository/visa_question_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final visaQuestionRepositoryProvider = Provider<VisaQuestionRepository>((ref) {
  final supabase = Supabase.instance.client;
  return VisaQuestionRepository(supabase);
});

final visaQuestionsProvider = FutureProvider((ref) async {
  final repo = ref.read(visaQuestionRepositoryProvider);
  return repo.getAllQuestions();
});
