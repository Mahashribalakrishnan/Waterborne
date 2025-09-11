import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/locale/locale_controller.dart';
import 'package:app/frontend/ashaworkers/reports.dart';
import 'package:app/frontend/ashaworkers/profile.dart';
import 'package:app/frontend/ashaworkers/data_collection.dart';
import 'package:app/frontend/ashaworkers/login.dart';
import 'package:app/services/dashboard_service.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AshaWorkerHomePage extends StatefulWidget {
  final String? userName;
  final String? village;
  final String? district;
  final String? outbreakStage; // e.g., Monitoring / Alert / Outbreak
  final int? reportsSubmitted;
  final String? riskLevel; // 'low' | 'medium' | 'high'

  const AshaWorkerHomePage({
    Key? key,
    this.userName,
    this.village,
    this.district,
    this.outbreakStage,
    this.reportsSubmitted,
    this.riskLevel,
  }) : super(key: key);

  @override
  State<AshaWorkerHomePage> createState() => _AshaWorkerHomePageState();
}

class _AshaWorkerHomePageState extends State<AshaWorkerHomePage> {
  int _currentIndex = 0;
  final _dashboard = DashboardService();

  Future<String>? _riskFuture;
  Future<({int daily, int weekly, int monthly})>? _countsFuture;
  Future<List<Map<String, dynamic>>>? _recentReportsFuture;
  Future<({double lat, double lon})?>? _geoFuture;

  @override
  void initState() {
    super.initState();
    // Prepare async fetches when we have location context
    if ((widget.village ?? '').isNotEmpty && (widget.district ?? '').isNotEmpty) {
      final v = widget.village!.trim();
      final d = widget.district!.trim();
      _riskFuture = _dashboard.fetchRiskLevel(district: d, village: v);
      _countsFuture = _dashboard.fetchCaseCounts(village: v);
      _recentReportsFuture = _dashboard.fetchRecentReports(village: v, limit: 5);
      _geoFuture = _dashboard.geocodeVillage(village: v, district: d);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final name = (widget.userName != null && widget.userName!.trim().isNotEmpty)
        ? widget.userName!
        : AppLocalizations.of(context).t('hello_priya').replaceAll('Hello, ', '');
    final village = widget.village ?? AppLocalizations.of(context).t('village_rampur');
    final district = widget.district ?? AppLocalizations.of(context).t('district_jaipur');
    final stage = widget.outbreakStage ?? 'Monitoring';
    final risk = (widget.riskLevel ?? 'low').toLowerCase();

    Color riskColor;
    String riskLabel;
    switch (risk) {
      case 'high':
      case 'red':
        riskColor = const Color(0xFFEF4444);
        riskLabel = 'High Risk';
        break;
      case 'medium':
      case 'yellow':
        riskColor = const Color(0xFFF59E0B);
        riskLabel = 'Medium Risk';
        break;
      default:
        riskColor = const Color(0xFF22C55E);
        riskLabel = 'Low Risk';
    }
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
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('isReturningUser');
              if (!context.mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const AshaWorkerLoginPage()),
                (route) => false,
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hello, $name',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _InfoChip(icon: Icons.location_city, label: 'Village: $village'),
                      _InfoChip(icon: Icons.map, label: 'District: $district'),
                      _InfoChip(icon: Icons.coronavirus_outlined, label: 'Outbreak: $stage'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Case Count Cards: Daily, Weekly, Monthly
            FutureBuilder<({int daily, int weekly, int monthly})>(
              future: _countsFuture,
              builder: (context, snapshot) {
                final daily = snapshot.data?.daily ?? 0;
                final weekly = snapshot.data?.weekly ?? 0;
                final monthly = snapshot.data?.monthly ?? 0;
                return Row(
                  children: [
                    Expanded(child: _StatCard(title: 'Daily Cases', value: daily.toString(), color: const Color(0xFF0EA5E9))),
                    const SizedBox(width: 12),
                    Expanded(child: _StatCard(title: 'Weekly Cases', value: weekly.toString(), color: const Color(0xFFF59E0B))),
                    const SizedBox(width: 12),
                    Expanded(child: _StatCard(title: 'Monthly Cases', value: monthly.toString(), color: const Color(0xFF22C55E))),
                  ],
                );
              },
            ),

            const SizedBox(height: 16),

            // Risk Box (dynamic)
            FutureBuilder<String>(
              future: _riskFuture,
              builder: (context, snap) {
                final rr = (snap.data ?? risk).toLowerCase();
                Color rc;
                String rl;
                switch (rr) {
                  case 'high':
                  case 'red':
                    rc = const Color(0xFFEF4444);
                    rl = 'High Risk';
                    break;
                  case 'medium':
                  case 'yellow':
                    rc = const Color(0xFFF59E0B);
                    rl = 'Medium Risk';
                    break;
                  default:
                    rc = const Color(0xFF22C55E);
                    rl = 'Low Risk';
                }
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: rc.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: rc, width: 1.2),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.shield_outlined, color: rc),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text('$rl for $village',
                            style: TextStyle(color: rc, fontSize: 16, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // Geo Risk Map header
            Text(
              AppLocalizations.of(context).t('geo_risk_map'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),

            // Interactive map using flutter_map
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: FutureBuilder<({double lat, double lon})?>(
                  future: _geoFuture,
                  builder: (context, snap) {
                    if (!snap.hasData || snap.data == null) {
                      return Container(
                        color: Colors.white,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.map_outlined, color: Color(0xFF9CA3AF), size: 48),
                            const SizedBox(height: 8),
                            Text('$village, $district',
                                style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
                          ],
                        ),
                      );
                    }
                    final pos = LatLng(snap.data!.lat, snap.data!.lon);
                    return FlutterMap(
                      options: MapOptions(initialCenter: pos, initialZoom: 13),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: const ['a', 'b', 'c'],
                          userAgentPackageName: 'app',
                        ),
                        MarkerLayer(markers: [
                          Marker(point: pos, width: 40, height: 40, child: const Icon(Icons.location_on, color: Colors.redAccent, size: 36)),
                        ]),
                      ],
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 8),
            Center(
              child: Text(
                riskLabel,
                style: TextStyle(
                  fontSize: 14,
                  color: riskColor,
                  fontWeight: FontWeight.w600,
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

            // Recent report items (dynamic)
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _recentReportsFuture,
              builder: (context, snap) {
                final items = snap.data ?? const [];
                if (items.isEmpty) {
                  return Text('No recent reports', style: TextStyle(color: Colors.grey.shade600));
                }
                return Column(
                  children: [
                    for (int i = 0; i < items.length; i++) ...[
                      _ReportRow(
                        dateTime: _fmtDate(items[i]['createdAt']),
                        subText: '${items[i]['count'] ?? items[i]['cases'] ?? 0} ' + AppLocalizations.of(context).t('reports_collected_suffix'),
                        synced: (items[i]['synced'] ?? true) == true,
                      ),
                      if (i != items.length - 1) const SizedBox(height: 14),
                    ],
                  ],
                );
              },
            ),

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

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  const _StatCard({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280), fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.insert_chart_outlined_rounded, color: color),
              const SizedBox(width: 8),
              Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }
}

String _fmtDate(dynamic ts) {
  try {
    if (ts is Timestamp) {
      final d = ts.toDate();
      return _format(d);
    } else if (ts is int) {
      return _format(DateTime.fromMillisecondsSinceEpoch(ts));
    } else if (ts is String) {
      return _format(DateTime.tryParse(ts) ?? DateTime.now());
    }
  } catch (_) {}
  return _format(DateTime.now());
}

String _format(DateTime d) {
  // Simple formatted date
  return '${d.day.toString().padLeft(2, '0')} ${_month(d.month)} ${d.year}, '
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
}

String _month(int m) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  return months[(m - 1).clamp(0, 11)];
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

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 2),
          Icon(icon, size: 16, color: const Color(0xFF6B7280)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF374151),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 2),
        ],
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