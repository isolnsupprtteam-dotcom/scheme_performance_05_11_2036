import 'package:flutter/material.dart';

void main() => runApp(const TenseApp());

const brandBlue = Color(0xFF324E9F);

class Fund {
  final String name;
  final String category;
  final String nav;
  final Map<String, String> returns;
  const Fund(this.name, this.category, this.nav, this.returns);
}

const funds = <Fund>[
  Fund('HDFC Flexi Cap Fund', 'Flexi Cap Fund', '1,842.56',
      {'3M': '4.2%', '6M': '8.1%', '1Y': '18.6%', '3Y': '15.2%', '5Y': '17.4%', '10Y': '14.8%'}),
  Fund('SBI Small Cap Fund', 'Small Cap Fund', '186.42',
      {'3M': '5.1%', '6M': '10.4%', '1Y': '22.3%', '3Y': '19.1%', '5Y': '21.0%', '10Y': '18.2%'}),
  Fund('ICICI Prudential Bluechip Fund', 'Large Cap Fund', '102.18',
      {'3M': '3.5%', '6M': '7.2%', '1Y': '16.4%', '3Y': '14.0%', '5Y': '15.6%', '10Y': '13.1%'}),
  Fund('Parag Parikh Flexi Cap Fund', 'Flexi Cap Fund', '89.75',
      {'3M': '4.8%', '6M': '9.6%', '1Y': '20.1%', '3Y': '18.0%', '5Y': '19.3%', '10Y': '—'}),
  Fund('Axis Midcap Fund', 'Mid Cap Fund', '96.31',
      {'3M': '2.9%', '6M': '6.8%', '1Y': '14.2%', '3Y': '13.6%', '5Y': '16.2%', '10Y': '15.0%'}),
  Fund('Kotak Emerging Equity Fund', 'Mid Cap Fund', '128.90',
      {'3M': '3.8%', '6M': '8.0%', '1Y': '17.5%', '3Y': '16.1%', '5Y': '18.4%', '10Y': '16.3%'}),
];

class TenseApp extends StatelessWidget {
  const TenseApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: '3Tense Scheme Performance',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: brandBlue),
      useMaterial3: true, scaffoldBackgroundColor: const Color(0xFFF6F7FB)),
    home: const SearchScreen(),
  );
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final search = TextEditingController();
  final Set<Fund> selected = {};
  @override
  void dispose() { search.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final filtered = funds.where((f) => f.name.toLowerCase().contains(search.text.toLowerCase())).toList();
    return Scaffold(
      appBar: AppBar(backgroundColor: brandBlue, foregroundColor: Colors.white,
        title: const Text('3Tense Scheme Performance'), centerTitle: false),
      body: Padding(padding: const EdgeInsets.all(16), child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Compare mutual funds', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text('Search and select up to 5 schemes', style: TextStyle(color: Colors.grey.shade700)),
          const SizedBox(height: 16),
          TextField(controller: search, onChanged: (_) => setState(() {}),
            decoration: InputDecoration(prefixIcon: const Icon(Icons.search),
              hintText: 'Search scheme name', filled: true, fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none))),
          const SizedBox(height: 14),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Available schemes', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('${selected.length}/5 selected', style: const TextStyle(color: brandBlue, fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 8),
          Expanded(child: ListView.builder(itemCount: filtered.length, itemBuilder: (context, i) {
            final fund = filtered[i]; final isSelected = selected.contains(fund);
            return Card(color: Colors.white, elevation: 0, margin: const EdgeInsets.only(bottom: 8),
              child: CheckboxListTile(value: isSelected, activeColor: brandBlue,
                title: Text(fund.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(fund.category), onChanged: (v) {
                  setState(() {
                    if (v == true && selected.length < 5) selected.add(fund);
                    if (v == false) selected.remove(fund);
                  });
                  if (v == true && selected.length == 5) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Maximum 5 schemes can be selected.')));
                  }
                }),
            );
          })),
          SizedBox(width: double.infinity, child: FilledButton(
            style: FilledButton.styleFrom(backgroundColor: brandBlue, padding: const EdgeInsets.symmetric(vertical: 16)),
            onPressed: selected.isEmpty ? null : () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => CompareScreen(funds: selected.toList()))),
            child: const Text('VIEW SCHEME PERFORMANCE')),
          ),
        ],
      )),
    );
  }
}

class CompareScreen extends StatelessWidget {
  final List<Fund> funds;
  const CompareScreen({super.key, required this.funds});
  @override
  Widget build(BuildContext context) {
    const periods = ['3M', '6M', '1Y', '3Y', '5Y', '10Y'];
    return Scaffold(
      appBar: AppBar(title: const Text('Scheme Comparison'), backgroundColor: brandBlue, foregroundColor: Colors.white),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text('${funds.length} schemes selected', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Card(color: Colors.white, elevation: 0, child: SingleChildScrollView(scrollDirection: Axis.horizontal,
          child: DataTable(columns: [
            const DataColumn(label: Text('Period')),
            ...funds.map((f) => DataColumn(label: SizedBox(width: 130, child: Text(f.name, maxLines: 3, overflow: TextOverflow.ellipsis)))),
          ], rows: periods.map((p) => DataRow(cells: [
            DataCell(Text(p, style: const TextStyle(fontWeight: FontWeight.bold))),
            ...funds.map((f) => DataCell(Text(f.returns[p] ?? '—'))),
          ])).toList()),
        )),
        const SizedBox(height: 16),
        const Text('Individual scheme details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...funds.map((f) => Card(color: Colors.white, elevation: 0, child: ListTile(
          title: Text(f.name, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text('${f.category}  •  Demo NAV: ₹${f.nav}'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(fund: f))),
        ))),
        const Padding(padding: EdgeInsets.all(8), child: Text(
          'Demo data for layout preview only. Returns and NAV are not live investment data.',
          style: TextStyle(color: Colors.grey, fontSize: 12))),
      ]),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final Fund fund;
  const DetailScreen({super.key, required this.fund});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Scheme Performance'), backgroundColor: brandBlue, foregroundColor: Colors.white),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      Text(fund.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      Text(fund.category, style: TextStyle(color: Colors.grey.shade700)),
      const SizedBox(height: 16),
      Card(color: Colors.white, elevation: 0, child: ListTile(
        title: const Text('Latest NAV (demo)'), subtitle: Text('₹${fund.nav}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)))),
      const SizedBox(height: 12),
      const Text('Returns', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      ...fund.returns.entries.map((e) => Card(color: Colors.white, elevation: 0,
        child: ListTile(title: Text(e.key), trailing: Text(e.value, style: const TextStyle(fontWeight: FontWeight.bold))))),
      const SizedBox(height: 12),
      const Text('Portfolio, sectors, holdings and risk metrics will be connected to your FinAPI in the next version.',
        style: TextStyle(color: Colors.grey)),
    ]),
  );
}
