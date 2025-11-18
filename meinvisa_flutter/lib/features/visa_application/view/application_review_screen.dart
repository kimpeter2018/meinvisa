import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meinvisa/data/models/visa_recommendation_response_model/visa_recommendation_response_model.dart';
import 'package:meinvisa/data/providers/application_form_provider.dart';
import 'package:meinvisa/features/visa_application/widgets/additional_questions_section.dart';
import 'package:meinvisa/features/visa_application/widgets/pre_filled_section.dart';
import 'package:meinvisa/features/visa_application/widgets/progress_indicator_widget.dart';

class ApplicationReviewScreen extends ConsumerStatefulWidget {
  static const routeName = '/application-review';

  final VisaRecommendationResponse recommendation;

  const ApplicationReviewScreen({super.key, required this.recommendation});

  @override
  ConsumerState<ApplicationReviewScreen> createState() => _ApplicationReviewScreenState();
}

class _ApplicationReviewScreenState extends ConsumerState<ApplicationReviewScreen> {
  final _scrollController = ScrollController();
  bool _showStickyButton = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Show sticky button when scrolled down
    if (_scrollController.offset > 300 && !_showStickyButton) {
      setState(() => _showStickyButton = true);
    } else if (_scrollController.offset <= 300 && _showStickyButton) {
      setState(() => _showStickyButton = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formNotifier = ref.watch(applicationFormProvider(widget.recommendation).notifier);
    final formData = ref.watch(applicationFormProvider(widget.recommendation));
    final metadata = widget.recommendation.applicationMetadata;

    if (metadata == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Application Review')),
        body: const Center(child: Text('No metadata available')),
      );
    }

    final completionPercentage = formNotifier.getCompletionPercentage();
    final isComplete = formNotifier.isFormComplete();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Application'),
        actions: [
          // Save draft button
          TextButton.icon(
            onPressed: () => _saveDraft(context),
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save Draft'),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main content
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Header with progress
              SliverToBoxAdapter(child: _buildHeader(context, completionPercentage, isComplete)),

              // Pre-filled information section
              if (metadata.preFilledFields.isNotEmpty)
                SliverToBoxAdapter(
                  child: PreFilledSection(
                    fields: metadata.preFilledFields,
                    formData: formData,
                    onEdit: (fieldKey, value) {
                      formNotifier.updateField(fieldKey, value);
                    },
                    onVerify: (fieldKey) {
                      formNotifier.verifyField(fieldKey);
                    },
                  ),
                ),

              // Additional questions section
              if (metadata.additionalQuestions.isNotEmpty)
                SliverToBoxAdapter(
                  child: AdditionalQuestionsSection(
                    questions: metadata.additionalQuestions,
                    formData: formData,
                    onAnswerChanged: (fieldKey, value) {
                      formNotifier.updateAdditionalAnswer(fieldKey, value);
                    },
                  ),
                ),

              // Required documents preview
              SliverToBoxAdapter(
                child: _buildDocumentsPreview(context, metadata.requiredDocuments),
              ),

              // Bottom padding for sticky button
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),

          // Sticky submit button (shows when scrolled)
          if (_showStickyButton)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildStickySubmitButton(context, isComplete, completionPercentage),
            ),
        ],
      ),

      // Bottom navigation bar with submit
      bottomNavigationBar: !_showStickyButton
          ? _buildBottomBar(context, isComplete, completionPercentage)
          : null,
    );
  }

  Widget _buildHeader(BuildContext context, double completionPercentage, bool isComplete) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).primaryColor.withOpacity(0.1), Colors.transparent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Visa type badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              widget.recommendation.recommended.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Title
          const Text(
            'Review Your Application',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Text(
            'Please review and verify all information before submitting',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),

          const SizedBox(height: 20),

          // Progress indicator
          ProgressIndicatorWidget(percentage: completionPercentage, isComplete: isComplete),
        ],
      ),
    );
  }

  Widget _buildDocumentsPreview(BuildContext context, List<RequiredDocument> documents) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.folder_open, color: Theme.of(context).primaryColor),
                const SizedBox(width: 12),
                const Text(
                  'Required Documents',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Text(
              'You\'ll need to upload ${documents.where((d) => d.required).length} required documents in the next step.',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),

            const SizedBox(height: 16),

            // Show first 3 documents
            ...documents
                .take(3)
                .map(
                  (doc) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Icon(
                          doc.canGenerate ? Icons.auto_awesome : Icons.description_outlined,
                          size: 20,
                          color: doc.canGenerate ? Colors.purple[600] : Colors.grey[600],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doc.documentName,
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                              if (doc.canGenerate)
                                Text(
                                  'We can help you create this',
                                  style: TextStyle(fontSize: 12, color: Colors.purple[600]),
                                ),
                            ],
                          ),
                        ),
                        if (doc.required)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Required',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.red[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

            if (documents.length > 3)
              Text(
                '+${documents.length - 3} more documents',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),

            const SizedBox(height: 16),

            OutlinedButton.icon(
              onPressed: () {
                // Navigate to documents screen
                _showDocumentsDialog(context, documents);
              },
              icon: const Icon(Icons.list),
              label: const Text('View All Documents'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, bool isComplete, double completionPercentage) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -2),
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Completion status
            if (!isComplete)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 20, color: Colors.orange[700]),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Please complete all required fields (${completionPercentage.toStringAsFixed(0)}% done)',
                        style: TextStyle(fontSize: 13, color: Colors.orange[900]),
                      ),
                    ),
                  ],
                ),
              ),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: isComplete ? () => _proceedToDocuments(context) : null,
                style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Text('Continue to Documents'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStickySubmitButton(
    BuildContext context,
    bool isComplete,
    double completionPercentage,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, -4),
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        child: FilledButton(
          onPressed: isComplete ? () => _proceedToDocuments(context) : null,
          style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
          child: Text(
            isComplete
                ? 'Continue to Documents'
                : 'Complete form (${completionPercentage.toStringAsFixed(0)}%)',
          ),
        ),
      ),
    );
  }

  void _saveDraft(BuildContext context) {
    // TODO: Save to database
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Draft saved successfully'), backgroundColor: Colors.green),
    );
  }

  void _proceedToDocuments(BuildContext context) {
    // Navigate to documents upload screen
    context.push('/application-documents', extra: widget.recommendation);
  }

  void _showDocumentsDialog(BuildContext context, List<RequiredDocument> documents) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'All Required Documents',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final doc = documents[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Icon(
                          doc.canGenerate ? Icons.auto_awesome : Icons.description_outlined,
                          color: doc.canGenerate ? Colors.purple[600] : Colors.grey[600],
                        ),
                        title: Text(doc.documentName),
                        subtitle: doc.description != null ? Text(doc.description!) : null,
                        trailing: doc.required
                            ? Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.red[50],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Required',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.red[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
