import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/locale/locale_controller.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/frontend/ashaworkers/home.dart';
import 'package:app/frontend/ashaworkers/reports.dart';
import 'package:app/frontend/ashaworkers/profile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Palette: Primary mint (#00D09E) with white and soft mint surfaces
const Color _primaryMint = Color(0xFF00D09E);
const Color _primaryMintDark = Color(0xFF00B18A);
const Color _softMint = Color(0xFFEAFBF6); // very light mint fill
const Color _border = Color(0xFFE5E7EB);
const Color _softGrey = Color(0xFFF7F9FB);

LinearGradient get _gbGradient => const LinearGradient(
  colors: [_primaryMint, _primaryMintDark],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

class AshaWorkerDataCollectionPage extends StatefulWidget {
  const AshaWorkerDataCollectionPage({super.key});

  @override
  State<AshaWorkerDataCollectionPage> createState() => _AshaWorkerDataCollectionPageState();
}

extension on _AshaWorkerDataCollectionPageState {
  Future<void> _submitToFirestore() async {
    final t = AppLocalizations.of(context).t;
    setState(() => _submitting = true);
    try {
      // Resolve identifiers for per-user scoping
      final prefs = await SharedPreferences.getInstance();
      final ashaUid = prefs.getString('asha_uid');
      final ashaId = prefs.getString('asha_id');
      final ashaName = prefs.getString('asha_name');
      final ashaVillage = prefs.getString('asha_village');
      final ashaDistrict = prefs.getString('asha_district');

      // Prepare payload
      final members = _members
          .map((m) => {
                'name': m.name,
                'gender': m.gender,
                'age': m.age,
                'symptoms': m.symptoms,
                'notes': m.notes,
              })
          .toList();

      String? imageBytesBase64;
      if (_imageBytes != null && _imageBytes!.isNotEmpty) {
        imageBytesBase64 = base64Encode(_imageBytes!);
      }

      // Basic derived stats for reports page
      final int totalMembers = members.length;
      final int affectedMembers = members.where((m) {
        final s = (m['symptoms'] as String?)?.trim();
        return s != null && s.isNotEmpty && s.toLowerCase() != 'none';
      }).length;

      final data = {
        'asha': {
          'uid': ashaUid,
          'ashaId': ashaId,
          'name': ashaName,
          'village': ashaVillage,
          'district': ashaDistrict,
        },
        'household': {
          'doorNo': _doorNo.text.trim(),
          'headName': _headName.text.trim(),
          'phone': _phone.text.trim(),
          'address': _address.text.trim(),
          'village': _village.text.trim(),
          'district': _district.text.trim(),
        },
        'members': members,
        'additional': {
          'waterSource': _waterSource,
          'visitedHospital': _visitedHospital,
          'notes': _notes.text.trim(),
        },
        'image': {
          'imageUrl': _imageUrl,
          if (imageBytesBase64 != null) 'imageBytesBase64': imageBytesBase64,
        },
        'stats': {
          'totalMembers': totalMembers,
          'affectedMembers': affectedMembers,
        },
        'createdAt': FieldValue.serverTimestamp(),
      };

      final docRef = await FirebaseFirestore.instance.collection('household_surveys').add(data);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${t('dc_form_submitted')} (ID: ${docRef.id})')));

      // Optionally clear form after submit
      setState(() {
        _doorNo.clear();
        _headName.clear();
        _phone.clear();
        _address.clear();
        _village.clear();
        _district.clear();
        _notes.clear();
        _waterSource = null;
        _visitedHospital = false;
        _imageUrl = null;
        _imageBytes = null;
        _members.clear();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to submit: $e')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool selected;
  const _NavIcon({required this.icon, required this.selected});

  @override
  Widget build(BuildContext context) {
    if (!selected) {
      return Icon(icon);
    }
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        gradient: _gbGradient,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: _primaryMint.withOpacity(0.25), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
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
  String? _imageUrl; // URL-based attach (optional)
  Uint8List? _imageBytes; // Picked image bytes for preview
  final ImagePicker _picker = ImagePicker();
  bool _submitting = false;

  // Family members (initially empty)
  final List<_Member> _members = [];

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

  Future<void> _showAttachImageSheet() async {
    final t = AppLocalizations.of(context).t;
    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Attach Image', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          Navigator.of(ctx).pop();
                          final XFile? file = await _picker.pickImage(source: ImageSource.camera, maxWidth: 1600, imageQuality: 85);
                          if (file != null) {
                            final bytes = await file.readAsBytes();
                            if (!mounted) return;
                            setState(() {
                              _imageBytes = bytes;
                              _imageUrl = null;
                            });
                          }
                        },
                        icon: const Icon(Icons.photo_camera_outlined),
                        label: const Text('Camera'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          Navigator.of(ctx).pop();
                          final XFile? file = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 1600, imageQuality: 85);
                          if (file != null) {
                            final bytes = await file.readAsBytes();
                            if (!mounted) return;
                            setState(() {
                              _imageBytes = bytes;
                              _imageUrl = null;
                            });
                          }
                        },
                        icon: const Icon(Icons.photo_library_outlined),
                        label: const Text('Gallery'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.of(ctx).pop();
                      await _promptImageUrl();
                    },
                    icon: const Icon(Icons.link_outlined),
                    label: Text(t('dc_attach_image_via_url')),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showAddMemberSheet() async {
    final name = TextEditingController();
    final age = TextEditingController();
    final notes = TextEditingController();
    String gender = 'Female';
    final symptoms = TextEditingController();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: MediaQuery.of(ctx).viewInsets.bottom + 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Add Member', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                TextField(controller: name, decoration: _decoration('Name')),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(child: TextField(controller: age, keyboardType: TextInputType.number, decoration: _decoration('Age'))),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InputDecorator(
                      decoration: _decoration('Gender'),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: gender,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(value: 'Female', child: Text('Female')),
                            DropdownMenuItem(value: 'Male', child: Text('Male')),
                            DropdownMenuItem(value: 'Other', child: Text('Other')),
                          ],
                          onChanged: (v) {
                            if (v != null) {
                              gender = v;
                              (ctx as Element).markNeedsBuild();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 10),
                TextField(controller: symptoms, decoration: _decoration('Symptoms (comma separated)')),
                const SizedBox(height: 10),
                TextField(controller: notes, maxLines: 3, decoration: _decoration('Notes')),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        if (name.text.trim().isEmpty || age.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter Name and Age')));
                          return;
                        }
                        setState(() {
                          _members.add(_Member(
                            name: name.text.trim(),
                            gender: gender,
                            age: age.text.trim(),
                            symptoms: symptoms.text.trim(),
                            notes: notes.text.trim(),
                          ));
                        });
                        Navigator.pop(ctx);
                      },
                      child: const Text('Add'),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
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
      backgroundColor: _softMint,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: _primaryMint,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          t('dc_title'),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 0.2),
        ),
        actions: [
          // Language selector (follows the app-wide locale)
          PopupMenuButton<String>(
            icon: const Icon(Icons.public, color: Colors.white),
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
              _PillButton(text: t('dc_scan_qr'), onTap: () {}, filled: false),
              const SizedBox(width: 8),
              _PillButton(text: t('dc_voice_bot'), onTap: () {}, filled: false),
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
          if (_members.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _softGrey,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _border),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12, offset: const Offset(0, 6)),
                ],
              ),
              child: const Text('No family members added yet.'),
            )
          else ...[
            ..._members.asMap().entries.map((e) => _FamilyMemberTile(index: e.key + 1, title: e.value.name, summary: e.value.summary)),
          ],
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _showAddMemberSheet,
              icon: const Icon(Icons.person_add_alt_1_rounded),
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
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _border),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 14, offset: const Offset(0, 6)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t('dc_attach_image'), style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final narrow = constraints.maxWidth < 420;
                    final preview = AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: _border),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Builder(
                          builder: (_) {
                            if (_imageBytes != null) {
                              return Image.memory(_imageBytes!, fit: BoxFit.cover);
                            }
                            if (_imageUrl != null) {
                              return Image.network(_imageUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_outlined, size: 40, color: Color(0xFF9CA3AF)));
                            }
                            return const Icon(Icons.image_outlined, size: 40, color: Color(0xFF9CA3AF));
                          },
                        ),
                      ),
                    );

                    final actions = ConstrainedBox(
                      constraints: const BoxConstraints.tightFor(width: 180),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _showAttachImageSheet,
                            icon: const Icon(Icons.add_a_photo_outlined),
                            label: const Text('Attach'),
                          ),
                          const SizedBox(height: 8),
                          OutlinedButton.icon(
                            onPressed: () {
                              // Placeholder upload action
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Image uploaded')));
                            },
                            icon: const Icon(Icons.cloud_upload_outlined),
                            label: Text(t('dc_upload')),
                          ),
                        ],
                      ),
                    );

                    if (narrow) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          preview,
                          const SizedBox(height: 12),
                          actions,
                        ],
                      );
                    }
                    return Row(
                      children: [
                        Expanded(child: preview),
                        const SizedBox(width: 12),
                        actions,
                      ],
                    );
                  },
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
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: _gbGradient,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: _primaryMint.withOpacity(0.25), blurRadius: 12, offset: const Offset(0, 6))],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: _submitting ? null : _submitToFirestore,
                    child: _submitting
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Text(t('dc_submit'), style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
        ],
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(top: BorderSide(color: _border)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), offset: const Offset(0, -2), blurRadius: 10)],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          elevation: 0,
          currentIndex: _currentIndex,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
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
          selectedItemColor: _primaryMint,
          unselectedItemColor: const Color(0xFF9CA3AF),
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: _NavIcon(icon: Icons.dashboard_customize_rounded, selected: _currentIndex == 0),
              label: t('nav_home_title'),
            ),
            BottomNavigationBarItem(
              icon: _NavIcon(icon: Icons.playlist_add_check_circle_outlined, selected: _currentIndex == 1),
              label: t('nav_data_collection'),
            ),
            BottomNavigationBarItem(
              icon: _NavIcon(icon: Icons.bar_chart_rounded, selected: _currentIndex == 2),
              label: t('nav_reports'),
            ),
            BottomNavigationBarItem(
              icon: _NavIcon(icon: Icons.account_circle_outlined, selected: _currentIndex == 3),
              label: t('nav_profile'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Member {
  final String name;
  final String gender;
  final String age;
  final String symptoms;
  final String notes;
  _Member({required this.name, required this.gender, required this.age, required this.symptoms, required this.notes});
  String get summary => 'Name: $name, Gender: $gender, Age: $age, Symptoms: ${symptoms.isEmpty ? 'None' : symptoms}, Notes: ${notes.isEmpty ? '—' : notes}';
}

InputDecoration _decoration(String label) {
  return InputDecoration(
    labelText: label,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _border)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _border)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _primaryMint)),
    filled: true,
    fillColor: _softMint,
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12, offset: const Offset(0, 6)),
        ],
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          gradient: filled ? _gbGradient : null,
          color: filled ? null : Colors.white,
          border: Border.all(color: filled ? Colors.transparent : _primaryMint.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            if (filled) BoxShadow(color: _primaryMint.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: filled ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
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