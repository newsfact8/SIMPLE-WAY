import 'package:flutter/material.dart';

void main() => runApp(const SimpleWayApp());

class SimpleWayApp extends StatelessWidget {
  const SimpleWayApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Simple Way',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1456A0)),
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF7F8FA),
    ),
    home: const HomePage(),
  );
}

class Category {
  final String name, emoji, description;
  const Category(this.name, this.emoji, this.description);
}

const categories = <Category>[
  Category('Flights', '✈️', 'Compare flight fares'),
  Category('Hotels', '🏨', 'Find hotel prices'),
  Category('Buses', '🚌', 'Compare bus tickets'),
  Category('Trains', '🚆', 'Explore train options'),
  Category('Cabs', '🚕', 'Compare cab estimates'),
  Category('Food', '🍔', 'Discover food offers'),
  Category('Groceries', '🛒', 'Compare grocery prices'),
  Category('Movies', '🎬', 'Find movie tickets'),
  Category('Shopping', '🛍️', 'Compare product prices'),
  Category('Recharge', '📱', 'Mobile and DTH plans'),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedTab = 0;
  String search = '';

  @override
  Widget build(BuildContext context) {
    final shown = categories.where((c) =>
      c.name.toLowerCase().contains(search.toLowerCase())).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Way', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(onPressed: () => _message('Profile coming soon'), icon: const Icon(Icons.account_circle_outlined)),
        ],
      ),
      body: IndexedStack(index: selectedTab, children: [
        _home(shown),
        const _PlaceholderPage(title: 'My Activity', icon: Icons.receipt_long),
        const _PlaceholderPage(title: 'Saved', icon: Icons.bookmark_border),
      ]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedTab,
        onDestinationSelected: (i) => setState(() => selectedTab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: 'Activity'),
          NavigationDestination(icon: Icon(Icons.bookmark_outline), label: 'Saved'),
        ],
      ),
    );
  }

  Widget _home(List<Category> shown) => ListView(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
    children: [
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF164F91), Color(0xFF2584C7)]),
          borderRadius: BorderRadius.circular(22),
        ),
        child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('One search. Better choices.', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Compare options across providers and choose where to book.', style: TextStyle(color: Colors.white70)),
        ]),
      ),
      const SizedBox(height: 18),
      TextField(
        onChanged: (v) => setState(() => search = v),
        decoration: InputDecoration(
          hintText: 'Search flights, hotels, food…',
          prefixIcon: const Icon(Icons.search),
          filled: true, fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        ),
      ),
      const SizedBox(height: 22),
      const Text('Explore categories', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      GridView.builder(
        shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        itemCount: shown.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.65,
        ),
        itemBuilder: (context, i) {
          final c = shown[i];
          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryPage(category: c))),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(c.emoji, style: const TextStyle(fontSize: 25)),
                const SizedBox(height: 5),
                Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(c.description, style: const TextStyle(fontSize: 11, color: Colors.black54)),
              ]),
            ),
          );
        },
      ),
      const SizedBox(height: 18),
      const Text('Sample price comparison', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      _sampleDeal('Cab ride · 8 km', [('Provider A', '₹149'), ('Provider B', '₹172'), ('Provider C', '₹185')]),
      _sampleDeal('Movie ticket · sample', [('Provider A', '₹180'), ('Provider B', '₹195'), ('Provider C', '₹210')]),
      const Padding(
        padding: EdgeInsets.only(top: 10),
        child: Text('Demo prices only. Live prices and booking links require approved provider integrations.', style: TextStyle(fontSize: 11, color: Colors.black54)),
      ),
    ],
  );

  Widget _sampleDeal(String title, List<(String, String)> offers) => Card(
    color: Colors.white, elevation: 0, margin: const EdgeInsets.only(bottom: 8),
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...offers.map((o) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(children: [Expanded(child: Text(o.$1)), Text(o.$2, style: const TextStyle(fontWeight: FontWeight.w700))]),
        )),
      ]),
    ),
  );

  void _message(String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

class CategoryPage extends StatelessWidget {
  final Category category;
  const CategoryPage({super.key, required this.category});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(category.name)),
    body: Center(child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(category.emoji, style: const TextStyle(fontSize: 56)),
        const SizedBox(height: 12),
        Text('Compare ${category.name.toLowerCase()} on Simple Way', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        const SizedBox(height: 8),
        const Text('Provider connections and verified live prices will appear here after integration approval.', textAlign: TextAlign.center),
      ]),
    )),
  );
}

class _PlaceholderPage extends StatelessWidget {
  final String title;
  final IconData icon;
  const _PlaceholderPage({required this.title, required this.icon});
  @override
  Widget build(BuildContext context) => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
    Icon(icon, size: 54, color: Colors.blueGrey), const SizedBox(height: 12),
    Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
    const Text('This section will be enabled in a later version.'),
  ]));
}
