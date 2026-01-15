import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? firstName;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final data = await FirebaseService().getUserData(user.uid);
        if (mounted) {
          setState(() {
            firstName = data['firstName'] ?? '';
            _loading = false;
          });
        }
      } else {
        setState(() => _loading = false);
      }
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;

        // Breakpoints
        final bool isTablet = width >= 600 && width < 1000;
        final bool isWeb = width >= 1000;

        // Cross Axis Count (Grid)
        int crossCount = 2;
        if (isTablet) crossCount = 3;
        if (isWeb) crossCount = 4;

        // Page padding
        double pagePadding = isWeb ? 40 : (isTablet ? 28 : 16);

        // Title font sizes
        double heroTitle = isWeb ? 32 : (isTablet ? 28 : 24);
        double heroSubtitle = isWeb ? 18 : (isTablet ? 16 : 14);

        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            elevation: 4,
            backgroundColor: Colors.blue[800],
            foregroundColor: Colors.white,
            title: const Text('Dashboard',
                style: TextStyle(fontWeight: FontWeight.bold)),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () => Navigator.pushNamed(context, '/fraudalerts'),
              ),
              IconButton(
                icon: const Icon(Icons.person_outline),
                onPressed: () => Navigator.pushNamed(context, '/profile'),
              ),
            ],
          ),
          body: _loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: EdgeInsets.all(pagePadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ⭐ HERO CARD
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(isWeb
                            ? 40
                            : isTablet
                                ? 32
                                : 24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue[900]!,
                              Colors.blue[700]!,
                              Colors.blue[500]!,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.25),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              firstName != null && firstName!.isNotEmpty
                                  ? 'Welcome back, $firstName'
                                  : 'Welcome',
                              style: TextStyle(
                                fontSize: heroTitle,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Monitor fraud, manage cards, and stay secure',
                              style: TextStyle(
                                fontSize: heroSubtitle,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ⭐ QUICK ACTIONS TITLE
                      Text(
                        "Quick Actions",
                        style: TextStyle(
                          fontSize: isWeb
                              ? 28
                              : isTablet
                                  ? 24
                                  : 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ⭐ GRID (Fully Responsive)
                      GridView.count(
                        crossAxisCount: crossCount,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: isWeb
                            ? 1.2
                            : isTablet
                                ? 1.1
                                : 1,
                        children: [
                          _actionCard(
                            icon: Icons.credit_card,
                            title: "Credit Cards",
                            subtitle: "Manage cards",
                            color: Colors.green,
                            onTap: () =>
                                Navigator.pushNamed(context, '/addcards'),
                          ),
                          _actionCard(
                            icon: Icons.receipt_long,
                            title: "Transactions",
                            subtitle: "View history",
                            color: Colors.orange,
                            onTap: () =>
                                Navigator.pushNamed(context, '/transactions'),
                          ),
                          _actionCard(
                            icon: Icons.security_rounded,
                            title: "Realtime Check",
                            subtitle: "Live monitoring",
                            color: Colors.purple,
                            onTap: () =>
                                Navigator.pushNamed(context, '/realtimecheck'),
                          ),
                          _actionCard(
                            icon: Icons.block,
                            title: "Freeze Card",
                            subtitle: "Lock instantly",
                            color: Colors.indigo,
                            onTap: () =>
                                Navigator.pushNamed(context, '/freezeunfreeze'),
                          ),
                          _actionCard(
                            icon: Icons.warning_amber,
                            title: "Fraud Alerts",
                            subtitle: "Suspicious activity",
                            color: Colors.red,
                            onTap: () =>
                                Navigator.pushNamed(context, '/fraudalerts'),
                          ),
                          _actionCard(
                            icon: Icons.assessment,
                            title: "Reports",
                            subtitle: "Generate data",
                            color: Colors.teal,
                            onTap: () => Navigator.pushNamed(
                                context, '/generate_report'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // ⭐ SIGN OUT BUTTON
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.logout),
                          label: const Text(
                            'Sign Out',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () =>
                              Navigator.pushReplacementNamed(context, '/login'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  // ⭐ ACTION CARD (Auto Responsive)
  Widget _actionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double box = constraints.maxWidth;

        final double iconSize = box > 100 ? 40 : 32;
        final double titleSize = box > 100 ? 16 : 14;
        final double subtitleSize = box > 100 ? 13 : 12;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: EdgeInsets.all(box > 150 ? 20 : 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(icon, size: iconSize, color: color),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: titleSize,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: subtitleSize,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
