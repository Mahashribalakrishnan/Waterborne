import 'package:flutter/material.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/locale/locale_controller.dart';
import 'package:app/frontend/ashaworkers/reports.dart';

const Color primaryBlue = Color(0xFF1E88E5);

class AshaWorkerHomePage extends StatefulWidget {
  const AshaWorkerHomePage({Key? key}) : super(key: key);

  @override
  State<AshaWorkerHomePage> createState() => _AshaWorkerHomePageState();
}

class _AshaWorkerHomePageState extends State<AshaWorkerHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(
          AppLocalizations.of(context).t('nav_home_title'),
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          // Globe language selector
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
              PopupMenuItem(value: 'ne', child: Text('Nepali')),
              PopupMenuItem(value: 'en', child: Text('English')),
              PopupMenuItem(value: 'as', child: Text('Assamese')),
              PopupMenuItem(value: 'hi', child: Text('Hindi')),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_none, color: Colors.black87),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context).t('hello_priya'),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            // Village / District / Stage - plain text (no links)
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                Text(
                  '${AppLocalizations.of(context).t('village_label')}: ${AppLocalizations.of(context).t('village_rampur')}',
                  style: const TextStyle(fontSize: 13, color: primaryBlue),
                ),
                const _Separator(),
                Text(
                  '${AppLocalizations.of(context).t('district_label')}: ${AppLocalizations.of(context).t('district_jaipur')}',
                  style: const TextStyle(fontSize: 13, color: primaryBlue),
                ),
                const _Separator(),
                Text(
                  '${AppLocalizations.of(context).t('outbreak_stage_label')}: Monitoring',
                  style: const TextStyle(fontSize: 13, color: primaryBlue),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Geo Risk Map header
            Text(
              AppLocalizations.of(context).t('geo_risk_map'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            // Map image card with rounded corners
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  // Static map-like image; replace with your own URL or an asset if preferred
                  'https://maps.gstatic.com/tactile/pane/default_geocode-2x.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) {
                    return Container(
                      color: const Color(0xFFE6F0FA),
                      alignment: Alignment.center,
                      child: const Icon(Icons.map_outlined, color: Color(0xFF9CA3AF), size: 48),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 8),
            Center(
              child: Text(
                AppLocalizations.of(context).t('risk_level_low'),
                style: const TextStyle(
                  fontSize: 14,
                  color: primaryBlue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Recent Reports header
            Text(
              AppLocalizations.of(context).t('recent_reports'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            // Report items (static to match the screenshot exactly)
            _ReportRow(
              dateTime: '06 Sep 2025, 09:15 AM',
              subText: '12 ' + AppLocalizations.of(context).t('reports_collected_suffix'),
              synced: true,
            ),
            const SizedBox(height: 14),
            _ReportRow(
              dateTime: '05 Sep 2025, 11:30 AM',
              subText: '8 ' + AppLocalizations.of(context).t('reports_collected_suffix'),
              synced: true,
            ),
            const SizedBox(height: 14),
            // Third row without dot, and a Submit button aligned to the right (as in screenshot section bottom)
            _ReportRow(
              dateTime: '04 Sep 2025, 02:45 PM',
              subText: '5 ' + AppLocalizations.of(context).t('reports_collected_suffix'),
              synced: false,
            ),
            const SizedBox(height: 12),

            const SizedBox(height: 12),
          ],
        ),
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
            if (i == 2) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const AshaWorkerReportsPage(),
                ),
              );
            }
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: primaryBlue,
          unselectedItemColor: const Color(0xFF9CA3AF),
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fact_check_outlined),
              label: 'Data Collection',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              label: 'Reports',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class _LinkPill extends StatelessWidget {
  final String text;
  const _LinkPill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 13,
        color: primaryBlue,
        decoration: TextDecoration.underline,
        decorationColor: primaryBlue,
      ),
    );
  }
}

class _Separator extends StatelessWidget {
  const _Separator();

  @override
  Widget build(BuildContext context) {
    return const Text(
      '|',
      style: TextStyle(
        fontSize: 13,
        color: Color(0xFF9CA3AF),
      ),
    );
  }
}

class _ReportRow extends StatelessWidget {
  final String dateTime;
  final String subText;
  final bool synced;

  const _ReportRow({
    super.key,
    required this.dateTime,
    required this.subText,
    required this.synced,
  });

  @override
  Widget build(BuildContext context) {
    final label = synced
        ? AppLocalizations.of(context).t('synced')
        : AppLocalizations.of(context).t('not_synced');
    final bgColor = synced ? const Color(0xFF22C55E) : const Color(0xFFEF4444);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left texts
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dateTime,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subText,
                style: const TextStyle(
                  fontSize: 13,
                  color: primaryBlue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        // Right status pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}