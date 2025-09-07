import 'package:flutter/material.dart';
import 'package:app/locale/locale_controller.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/frontend/ashaworkers/home.dart';
import 'package:app/frontend/ashaworkers/reports.dart';
import 'package:app/frontend/ashaworkers/profile.dart';

const Color _primaryBlue = Color(0xFF1E88E5);
const Color _border = Color(0xFFE5E7EB);

class AshaWorkerDataCollectionPage extends StatefulWidget {
  const AshaWorkerDataCollectionPage({super.key});

  @override
  State<AshaWorkerDataCollectionPage> createState() => _AshaWorkerDataCollectionPageState();
}

class _AshaWorkerDataCollectionPageState extends State<AshaWorkerDataCollectionPage> {
  int _currentIndex = 1;

  // Form state
  final _doorNo = TextEditingController();
  final _headName = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _village = TextEditingController();
  final _district = TextEditingController();

  final _notes = TextEditingController();
  String? _waterSource;
  bool _visitedHospital = false;
  String? _imageUrl; // simple URL-based attach for web/desktop/mobile compatibility

  // Family members demo list
  final List<Map<String, String>> _members = [
    {
      'title': 'Family Member 1',
      'summary': 'Name: Anya Sharma, Gender: Female, Age: 32, Symptoms: None, Notes: Healthy',
    },
    {
      'title': 'Family Member 2',
      'summary': 'Name: Rohan Sharma, Gender: Male, Age: 35, Symptoms: Fever, Notes: Mild fever',
    },
  ];

  Future<void> _promptImageUrl() async {
    final controller = TextEditingController(text: _imageUrl ?? '');
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context).t('dc_attach_image_via_url'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ).copyWith(labelText: AppLocalizations.of(context).t('dc_image_url')),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.pop(ctx), child: Text(AppLocalizations.of(context).t('cancel'))),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(ctx, controller.text.trim()),
                    child: Text(AppLocalizations.of(context).t('attach')),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    if (!mounted) return;
    if (result != null && result.isNotEmpty) {
      setState(() => _imageUrl = result);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).t('dc_image_attached'))));
    }
  }

  @override
  void dispose() {
    _doorNo.dispose();
    _headName.dispose();
    _phone.dispose();
    _address.dispose();
    _village.dispose();
    _district.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          t('dc_title'),
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w700),
        ),
        actions: [
          // Language selector (follows the app-wide locale)
          PopupMenuButton<String>(
            icon: const Icon(Icons.public, color: Colors.black87),
            onSelected: (code) {
              switch (code) {
                case 'ne':
                case 'en':
                case 'as':
                case 'hi':
                  LocaleController.instance.setLocale(Locale(code));
                  break;
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'en', child: Text('English')),
              PopupMenuItem(value: 'hi', child: Text('हिन्दी')),
              PopupMenuItem(value: 'ne', child: Text('नेपाली')),
              PopupMenuItem(value: 'as', child: Text('অসমীয়া')),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        children: [
          // Segmented header
          Row(
            children: [
              _PillButton(text: t('dc_scan_qr'), onTap: () {}),
              const SizedBox(width: 8),
              _PillButton(text: t('dc_voice_bot'), onTap: () {}),
              const SizedBox(width: 8),
              _PillButton(
                text: t('dc_fill_manually'),
                filled: true,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Household Details
          _SectionHeader(t('dc_household_details')),
          _TextField(label: t('dc_household_door_no'), hint: t('dc_enter_door_number'), controller: _doorNo),
          _TextField(label: t('dc_head_name'), hint: t('dc_enter_name'), controller: _headName),
          _TextField(label: t('dc_phone_number'), hint: t('dc_enter_phone_number'), controller: _phone, keyboardType: TextInputType.phone),
          _TextField(label: t('dc_address'), hint: t('dc_enter_address'), controller: _address),
          _TextField(label: t('dc_village'), hint: t('dc_enter_village'), controller: _village),
          _TextField(label: t('dc_district'), hint: t('dc_enter_district'), controller: _district),

          const SizedBox(height: 12),

          // Family Members
          _SectionHeader(t('dc_family_members')),
          ..._members.asMap().entries.map((e) => _FamilyMemberTile(index: e.key + 1, title: e.value['title']!, summary: e.value['summary']!)),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _members.add({
                    'title': 'Member ${_members.length + 1}',
                    'summary': 'Name: , Gender: , Age: , Symptoms: , Notes: ',
                  });
                });
              },
              icon: const Icon(Icons.add),
              label: Text(t('dc_add_member')),
            ),
          ),

          const SizedBox(height: 12),

          // Additional Info
          _SectionHeader(t('dc_additional_info')),
          // Drinking water source
          InputDecorator(
            decoration: _decoration(t('dc_drinking_water_source')),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _waterSource,
                isExpanded: true,
                hint: Text(t('dc_select_source')),
                items: [
                  DropdownMenuItem(value: 'Tap', child: Text(t('dc_source_tap'))),
                  DropdownMenuItem(value: 'Well', child: Text(t('dc_source_well'))),
                  DropdownMenuItem(value: 'Hand Pump', child: Text(t('dc_source_hand_pump'))),
                  DropdownMenuItem(value: 'Borewell', child: Text(t('dc_source_borewell'))),
                  DropdownMenuItem(value: 'River/Pond', child: Text(t('dc_source_river_pond'))),
                ],
                onChanged: (v) => setState(() => _waterSource = v),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Attach image (URL based) + preview
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t('dc_attach_image'), style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: _border),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: _imageUrl == null
                              ? const Icon(Icons.image_outlined, size: 40, color: Color(0xFF9CA3AF))
                              : Image.network(_imageUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_outlined, size: 40, color: Color(0xFF9CA3AF))),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _promptImageUrl,
                      child: Text(t('dc_upload')),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Visited hospital toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(t('dc_visited_hospital_recently')),
              Switch(
                value: _visitedHospital,
                onChanged: (v) => setState(() => _visitedHospital = v),
              ),
            ],
          ),

          const SizedBox(height: 8),
          _MultilineField(label: t('dc_notes'), hint: t('dc_enter_notes'), controller: _notes),

          const SizedBox(height: 14),

          // Footer buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t('dc_draft_saved'))));
                  },
                  child: Text(t('dc_save_draft')),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: _primaryBlue),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t('dc_form_submitted'))));
                  },
                  child: Text(t('dc_submit')),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
        ],
      ),

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: _border)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) {
            setState(() => _currentIndex = i);
            if (i == 0) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const AshaWorkerHomePage()),
                (route) => false,
              );
            } else if (i == 2) {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AshaWorkerReportsPage()),
              );
            } else if (i == 3) {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AshaWorkerProfilePage()),
              );
            }
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: _primaryBlue,
          unselectedItemColor: const Color(0xFF9CA3AF),
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_rounded),
              label: t('nav_home_title'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.fact_check_outlined),
              label: t('nav_data_collection'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.receipt_long_outlined),
              label: t('nav_reports'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline_rounded),
              label: t('nav_profile'),
            ),
          ],
        ),
      ),
    );
  }
}

InputDecoration _decoration(String label) {
  return InputDecoration(
    labelText: label,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _border)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _border)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _primaryBlue)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  );
}

class _TextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  const _TextField({required this.label, required this.hint, required this.controller, this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: _decoration(hint),
          ),
        ],
      ),
    );
  }
}

class _MultilineField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  const _MultilineField({required this.label, required this.hint, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: 4,
          decoration: _decoration(hint),
        ),
      ],
    );
  }
}

class _FamilyMemberTile extends StatelessWidget {
  final int index;
  final String title;
  final String summary;
  const _FamilyMemberTile({required this.index, required this.title, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.black87)),
          const SizedBox(height: 6),
          Text(summary, style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
        ],
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final String text;
  final bool filled;
  final VoidCallback onTap;
  const _PillButton({required this.text, this.filled = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: filled ? const Color(0xFFE8F1FB) : Colors.white,
          border: Border.all(color: filled ? _primaryBlue : _border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: filled ? _primaryBlue : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black87),
      ),
    );
  }
}