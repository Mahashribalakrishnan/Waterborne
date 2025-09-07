import 'package:flutter/material.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/locale/locale_controller.dart';
import 'package:app/frontend/ashaworkers/home.dart';
import 'package:app/frontend/ashaworkers/reports.dart';
import 'package:app/frontend/ashaworkers/data_collection.dart';

const Color _primaryBlue = Color(0xFF1E88E5);

class AshaWorkerProfilePage extends StatefulWidget {
  const AshaWorkerProfilePage({super.key});

  @override
  State<AshaWorkerProfilePage> createState() => _AshaWorkerProfilePageState();
}

class _AshaWorkerProfilePageState extends State<AshaWorkerProfilePage> {
  int _currentIndex = 3;

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
        title: Text(
          t('profile_title'),
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.settings_outlined, color: Colors.black87),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          const SizedBox(height: 12),
          // Avatar
          Center(
            child: CircleAvatar(
              radius: 44,
              backgroundColor: const Color(0xFFEDE9E3),
              backgroundImage: const NetworkImage(
                'https://images.unsplash.com/photo-1550525811-e5869dd03032?q=80&w=200&auto=format&fit=crop',
              ),
              onBackgroundImageError: (_, __) {},
            ),
          ),
          const SizedBox(height: 16),

          // Name and basic details
          Center(
            child: Column(
              children: [
                Text(
                  'Dr. Anya Sharma',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${t('worker_id_prefix')} 123456',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    '${t('linked_phc_prefix')} Rural Health Center',
                    style: const TextStyle(
                      fontSize: 13,
                      color: _primaryBlue,
                      decoration: TextDecoration.underline,
                      decorationColor: _primaryBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Change Language (Expansion)
          _SectionCard(
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 12),
                childrenPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                leading: const Icon(Icons.public, color: Colors.black87),
                title: Text(
                  t('change_language'),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                children: const [
                  _LanguageRow(),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Personal Information
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              t('personal_information'),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
          const _InfoTile(
            icon: Icons.person_outline,
            titleKey: 'name_label',
            value: 'Dr. Anya Sharma',
          ),
          const _InfoTile(
            icon: Icons.badge_outlined,
            titleKey: 'worker_id_label',
            value: '123456',
          ),
          const _InfoTile(
            icon: Icons.phone_outlined,
            titleKey: 'contact_number_label',
            value: '+91 9876543210',
            valueColor: _primaryBlue,
          ),
          const _InfoTile(
            icon: Icons.local_hospital_outlined,
            titleKey: 'linked_phc_label',
            value: 'Rural Health Center',
            valueColor: _primaryBlue,
          ),

          const SizedBox(height: 10),

          // Support
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              t('support'),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
          _ActionTile(icon: Icons.help_outline, label: t('help_faqs'), onTap: () {}),
          _ActionTile(icon: Icons.headset_mic_outlined, label: t('contact_admin'), onTap: () {}),

          const SizedBox(height: 10),

          // Account Management
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              t('account_management'),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
          _ActionTile(icon: Icons.edit_outlined, label: t('edit_profile'), onTap: () {}),
          _ActionTile(icon: Icons.lock_outline, label: t('change_password'), onTap: () {}),
          _ActionTile(
            icon: Icons.logout,
            label: t('logout'),
            trailing: const Icon(Icons.arrow_right_alt, color: Colors.black87),
            onTap: () {},
          ),
          const SizedBox(height: 24),
        ],
      ),

      // Bottom Navigation
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
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
            } else if (i == 1) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const AshaWorkerDataCollectionPage(),
                ),
              );
            } else if (i == 2) {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AshaWorkerReportsPage()),
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

class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: child,
    );
  }
}

class _LanguageRow extends StatelessWidget {
  const _LanguageRow();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: const [
        _LangChip(label: 'English', code: 'en'),
        _LangChip(label: 'हिन्दी', code: 'hi'),
        _LangChip(label: 'नेपाली', code: 'ne'),
        _LangChip(label: 'অসমীয়া', code: 'as'),
      ],
    );
  }
}

class _LangChip extends StatelessWidget {
  final String label;
  final String code;
  const _LangChip({required this.label, required this.code});

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: false,
      onSelected: (_) => LocaleController.instance.setLocale(Locale(code)),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String titleKey;
  final String value;
  final Color? valueColor;

  const _InfoTile({
    required this.icon,
    required this.titleKey,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(
        t(titleKey),
        style: const TextStyle(
          fontSize: 13,
          color: Color(0xFF6B7280),
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        value,
        style: TextStyle(
          fontSize: 14,
          color: valueColor ?? Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Widget? trailing;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.black54),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}