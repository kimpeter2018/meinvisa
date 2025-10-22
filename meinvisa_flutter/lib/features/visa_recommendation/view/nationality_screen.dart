import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:country_picker/country_picker.dart';
import 'package:meinvisa/data/providers/visa_recommendation_provider.dart';

class PassportNationalityPage extends ConsumerStatefulWidget {
  final ValueChanged<String?> onNext;
  const PassportNationalityPage({super.key, required this.onNext});

  @override
  ConsumerState<PassportNationalityPage> createState() =>
      _PassportNationalityPageState();
}

class _PassportNationalityPageState
    extends ConsumerState<PassportNationalityPage> {
  Country? _selectedCountry;
  String _searchQuery = '';

  void _showCountryPicker() {
    final allCountries = CountryService().getAll(); // all countries
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filtered = allCountries.where((country) {
              final name = country.name.toLowerCase();
              return name.contains(_searchQuery.toLowerCase());
            }).toList();
            return Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Search country',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) => setModalState(() {
                      _searchQuery = value;
                    }),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final country = filtered[index];
                        return ListTile(
                          leading: Text(
                            country.flagEmoji, // show the flag
                            style: const TextStyle(fontSize: 24),
                          ),
                          title: Text(country.name),
                          onTap: () {
                            setState(() {
                              _selectedCountry = country;
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "What's your nationality?",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Text(
            "Please select your legal nationality exactly as stated on your passport.",
            style: TextStyle(color: Colors.grey, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: _showCountryPicker,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedCountry?.name ?? 'Select your country',
                    style: TextStyle(
                      fontSize: 16,
                      color: _selectedCountry == null
                          ? Colors.grey.shade600
                          : Colors.black,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => widget.onNext(null),
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
                child: const Text("Skip for now"),
              ),
              ElevatedButton(
                onPressed: _selectedCountry != null
                    ? () => widget.onNext(_selectedCountry!.countryCode)
                    : null,
                child: const Text("Next"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
