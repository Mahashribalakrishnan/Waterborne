import 'package:flutter/material.dart';
import 'package:app/l10n/app_localizations.dart';

const Color primaryBlue = Color(0xFF1E88E5);

class AshaWorkerReportsPage extends StatelessWidget {
  const AshaWorkerReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.of(context).pop(),
            color: Colors.black87,
          ),
          title: Text(
            t('my_reports'),
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(44),
            child: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TabBar(
                labelColor: primaryBlue,
                unselectedLabelColor: const Color(0xFF9CA3AF),
                indicatorColor: primaryBlue,
                labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                tabs: [
                  Tab(text: t('tab_today')),
                  Tab(text: t('tab_this_week')),
                  Tab(text: t('tab_this_month')),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _ReportList(t: t),
            _ReportList(t: t),
            _ReportList(t: t),
          ],
        ),
      ),
    );
  }
}

class _ReportList extends StatelessWidget {
  final String Function(String) t;
  const _ReportList({required this.t});

  @override
  Widget build(BuildContext context) {
    // Demo static items to match screenshot
    final items = [
      _Item(
        surname: t('surname_sharma'),
        disease: t('malaria'),
        cases: 2,
      ),
      _Item(
        surname: t('surname_verma'),
        disease: t('dengue'),
        cases: 1,
      ),
      _Item(
        surname: t('surname_gupta'),
        disease: t('tuberculosis'),
        cases: 3,
      ),
      _Item(
        surname: t('surname_singh'),
        disease: t('covid19'),
        cases: 1,
      ),
    ];

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final it = items[index];
        final caseWord = it.cases == 1 ? t('case') : t('cases');
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left text block
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${it.disease} & ${it.cases} $caseWord',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${it.surname} ${t('family')}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Right synced pill
            _SyncedPill(text: t('synced')),
          ],
        );
      },
    );
  }
}

class _SyncedPill extends StatelessWidget {
  final String text;
  const _SyncedPill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: const Color(0xFF22C55E), // green
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(
              Icons.check,
              size: 14,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _Item {
  final String surname;
  final String disease;
  final int cases;
  _Item({required this.surname, required this.disease, required this.cases});
}
