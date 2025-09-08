import 'package:flutter/material.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/locale/locale_controller.dart';
import 'package:app/frontend/ashaworkers/reports.dart';
import 'package:app/frontend/ashaworkers/profile.dart';
import 'package:app/frontend/ashaworkers/data_collection.dart';

class AshaWorkerHomePage extends StatefulWidget {
  final String? userName;
  const AshaWorkerHomePage({Key? key, this.userName}) : super(key: key);

  @override
  State<AshaWorkerHomePage> createState() => _AshaWorkerHomePageState();
}

class _AshaWorkerHomePageState extends State<AshaWorkerHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context).t('nav_home_title'),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          // Globe language selector
          PopupMenuButton<String>(
            icon: const Icon(Icons.public),
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
            child: Icon(Icons.notifications_none),
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
              (widget.userName != null && widget.userName!.trim().isNotEmpty)
                  ? 'Hello, ${widget.userName}'
                  : AppLocalizations.of(context).t('hello_priya'),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
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
                  style: TextStyle(fontSize: 13, color: cs.primary),
                ),
                const _Separator(),
                Text(
                  '${AppLocalizations.of(context).t('district_label')}: ${AppLocalizations.of(context).t('district_jaipur')}',
                  style: TextStyle(fontSize: 13, color: cs.primary),
                ),
                const _Separator(),
                Text(
                  '${AppLocalizations.of(context).t('outbreak_stage_label')}: Monitoring',
                  style: TextStyle(fontSize: 13, color: cs.primary),
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
                      color: cs.background,
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
                style: TextStyle(
                  fontSize: 14,
                  color: cs.primary,
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
          border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) {
            setState(() => _currentIndex = i);
            if (i == 1) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const AshaWorkerDataCollectionPage(),
                ),
              );
            } else if (i == 2) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const AshaWorkerReportsPage(),
                ),
              );
            } else if (i == 3) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const AshaWorkerProfilePage(),
                ),
              );
            }
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: cs.primary,
          unselectedItemColor: const Color(0xFF9CA3AF),
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.fact_check_outlined), label: 'Data Collection'),
            BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: 'Reports'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'Profile'),
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
    final cs = Theme.of(context).colorScheme;
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 13,
        color: cs.primary,
        decoration: TextDecoration.underline,
        decorationColor: cs.primary,
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
    final cs = Theme.of(context).colorScheme;
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
                style: TextStyle(
                  fontSize: 13,
                  color: cs.primary,
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