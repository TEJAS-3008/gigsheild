import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const GigShieldApp());
}

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegistrationScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) {
        final Map<String, dynamic> userData = (state.extra as Map<String, dynamic>?) ?? {
          "name": "Guest Partner",
          "phone": "9876543210",
          "pin": "400053",
          "platform": "Zomato",
          "id": "ZOM-12345"
        };
        return DashboardWrapper(userData: userData);
      },
    ),
    GoRoute(
      path: '/alert',
      builder: (context, state) => const AlertScreen(),
    ),
    GoRoute(
      path: '/payout',
      builder: (context, state) => const PayoutScreen(),
    ),
  ],
);

// Unified styling constants
const Color colorOrange = Color(0xFFFF6D00);

class GigShieldApp extends StatelessWidget {
  const GigShieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp.router(
          title: 'GigShield',
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFF3F4F6),
            colorScheme: ColorScheme.fromSeed(
              brightness: Brightness.light,
              seedColor: colorOrange,
              primary: colorOrange,
              secondary: colorOrange,
              surface: Colors.white,
            ),
            appBarTheme: const AppBarTheme(backgroundColor: Colors.white, foregroundColor: Colors.black87, elevation: 0),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF121212),
            colorScheme: ColorScheme.fromSeed(
              brightness: Brightness.dark,
              seedColor: colorOrange,
              primary: colorOrange,
              secondary: colorOrange,
              surface: const Color(0xFF1E1E1E),
            ),
            appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF121212), foregroundColor: Colors.white, elevation: 0),
          ),
          routerConfig: _router,
        );
      },
    );
  }
}

// ----------------------------------------------------------------------
// Screen 0: Login
// ----------------------------------------------------------------------
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController(text: "9876543210");
  final TextEditingController pinController = TextEditingController(text: "1234");
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [if (!isDark) const BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 10))],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    child: Container(
                      height: 140,
                      color: isDark ? Colors.black26 : const Color(0xFFFFF5EC),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: isDark ? Colors.orange.withOpacity(0.2) : const Color(0xFFFFE8D6), shape: BoxShape.circle),
                          child: const Icon(Icons.security, color: colorOrange, size: 48),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('Welcome back', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('Log in to your GigShield account', style: TextStyle(fontSize: 16, color: Theme.of(context).hintColor)),
                        const SizedBox(height: 32),
                        TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.phone_outlined),
                            labelText: 'Phone number',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: pinController,
                          obscureText: _obscureText,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(_obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                              onPressed: () => setState(() => _obscureText = !_obscureText),
                            ),
                            labelText: 'Password',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('4-digit PIN', style: TextStyle(color: Theme.of(context).hintColor, fontSize: 12)),
                            TextButton(onPressed: () {}, child: const Text('Forgot PIN?', style: TextStyle(color: colorOrange, fontWeight: FontWeight.bold))),
                          ],
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => context.go('/dashboard'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorOrange,
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(56),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text('Log In', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), SizedBox(width: 8), Icon(Icons.arrow_forward)],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0), child: Text('or', style: TextStyle(color: Theme.of(context).hintColor))),
                            const Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: 24),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Text('G', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 24)),
                          label: const Text('Continue with Google', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(56),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('New to GigShield? ', style: TextStyle(color: Theme.of(context).hintColor)),
                            GestureDetector(
                              onTap: () => context.go('/register'),
                              child: const Text('Register here', style: TextStyle(color: colorOrange, fontWeight: FontWeight.bold, decoration: TextDecoration.underline, decorationColor: colorOrange)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------
// Screen 1: Registration
// ----------------------------------------------------------------------
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String selectedPlatform = 'Zomato';
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  final TextEditingController idController = TextEditingController();

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Account', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.person_add_alt_1, size: 64, color: colorOrange),
            const SizedBox(height: 24),
            TextField(controller: nameController, decoration: InputDecoration(labelText: 'Full Name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
            const SizedBox(height: 16),
            TextField(controller: phoneController, decoration: InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            TextField(controller: pinController, decoration: InputDecoration(labelText: 'Pin Code (Delivery Zone)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedPlatform,
              items: ['Zomato', 'Swiggy', 'Zepto', 'Blinkit', 'UberEats'].map((String p) {
                return DropdownMenuItem(value: p, child: Text(p));
              }).toList(),
              onChanged: (String? v) {
                if (v != null) setState(() => selectedPlatform = v);
              },
              decoration: InputDecoration(labelText: 'Service Platform', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(height: 16),
            TextField(controller: idController, decoration: InputDecoration(labelText: 'Partner/Driver ID', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Map<String, dynamic> userMap = {
                  "name": nameController.text.isNotEmpty ? nameController.text : "User",
                  "phone": phoneController.text,
                  "pin": pinController.text.isNotEmpty ? pinController.text : "400053",
                  "platform": selectedPlatform,
                  "id": idController.text.isNotEmpty ? idController.text : "ID-1234"
                };
                context.go('/dashboard', extra: userMap);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorOrange,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Activate My Shield', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            const SizedBox(height: 16),
            TextButton(onPressed: () => context.go('/'), child: Text('Back to Login', style: TextStyle(color: Theme.of(context).hintColor))),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------
// Wrapper: Dashboard
// ----------------------------------------------------------------------
class DashboardWrapper extends StatefulWidget {
  final Map<String, dynamic> userData;
  const DashboardWrapper({super.key, required this.userData});

  @override
  State<DashboardWrapper> createState() => _DashboardWrapperState();
}

class _DashboardWrapperState extends State<DashboardWrapper> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _HomeView(userData: widget.userData),
          Center(child: Text("Claims History (Coming Soon)", style: TextStyle(fontSize: 18, color: Theme.of(context).hintColor))),
          _ProfileView(userData: widget.userData),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: colorOrange,
        unselectedItemColor: Colors.grey,
        onTap: (idx) => setState(() => _currentIndex = idx),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Claims'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Settings'),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------------
// View: Home
// ----------------------------------------------------------------------
class _HomeView extends StatefulWidget {
  final Map<String, dynamic> userData;
  const _HomeView({required this.userData});

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  double temp = 0.0;
  double rain = 0.0;
  int aqi = 0;
  String mappedLocation = "Locating...";
  bool isLoading = true;

  double computedLat = 19.0760;
  double computedLon = 72.8777;

  @override
  void initState() {
    super.initState();
    _fetchLiveEnvironmentData();
  }

  Future<void> _fetchLiveEnvironmentData() async {
    setState(() => isLoading = true);
    
    try {
      final req = await HttpClient().getUrl(Uri.parse('https://api.zippopotam.us/IN/${widget.userData["pin"]}'));
      final res = await req.close();
      final body = await res.transform(utf8.decoder).join();
      final data = jsonDecode(body);
      if (data['places'] != null && data['places'].isNotEmpty) {
        String place = data['places'][0]['place name'];
        String state = data['places'][0]['state abbreviation'] ?? data['places'][0]['state'];
        computedLat = double.tryParse(data['places'][0]['latitude'].toString()) ?? computedLat;
        computedLon = double.tryParse(data['places'][0]['longitude'].toString()) ?? computedLon;
        mappedLocation = "$place, $state";
      } else {
        mappedLocation = "Zone ${widget.userData["pin"]}";
      }
    } catch (_) {
      mappedLocation = "Zone ${widget.userData["pin"]}";
    }

    try {
      final req = await HttpClient().getUrl(Uri.parse('https://api.waqi.info/feed/geo:$computedLat;$computedLon/?token=demo'));
      final res = await req.close();
      final body = await res.transform(utf8.decoder).join();
      final data = jsonDecode(body);
      if (data['status'] == 'ok') {
        aqi = (data['data']['aqi'] is int) ? data['data']['aqi'] : 0;
      }
    } catch (_) {}

    try {
      final req = await HttpClient().getUrl(Uri.parse('https://api.open-meteo.com/v1/forecast?latitude=$computedLat&longitude=$computedLon&current=temperature_2m,precipitation'));
      final res = await req.close();
      final body = await res.transform(utf8.decoder).join();
      final data = jsonDecode(body);
      if (data['current'] != null) {
        temp = (data['current']['temperature_2m'] ?? 0.0).toDouble();
        rain = (data['current']['precipitation'] ?? 0.0).toDouble();
      }
    } catch (_) {}

    if (mounted) setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('GigShield Home', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.warning_amber_rounded, color: Colors.amber), onPressed: () => context.go('/alert'), tooltip: 'Simulate Alert Trigger'),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Hello ${widget.userData["name"]}, 👋', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(16), boxShadow: [if(!isDark) const BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))]),
              child: Column(
                children: [
                  const Icon(Icons.security, size: 48, color: Colors.green),
                  const SizedBox(height: 8),
                  const Text('POLICY ACTIVE', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1.2)),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, color: colorOrange),
                            const SizedBox(width: 8),
                            Expanded(child: Text(mappedLocation, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                      ),
                      IconButton(icon: Icon(Icons.refresh, color: Theme.of(context).hintColor), onPressed: _fetchLiveEnvironmentData),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            isLoading 
              ? const Padding(padding: EdgeInsets.all(32.0), child: Center(child: CircularProgressIndicator(color: colorOrange)))
              : Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: isDark ? Colors.orange.withOpacity(0.1) : const Color(0xFFFFF5EC), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFFFE8D6))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Live Metrics', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('Lat/Lon Map Bound', style: TextStyle(fontSize: 12, color: isDark ? Colors.orange[200] : Colors.orange[800])),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.thermostat, color: colorOrange, size: 20),
                          const SizedBox(width: 8),
                          Text('Temperature: ${temp}°C', style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.water_drop, color: rain > 50 ? Colors.red : Colors.blue, size: 20),
                          const SizedBox(width: 8),
                          Text('Rainfall: ${rain} mm/hr', style: TextStyle(fontSize: 16, fontWeight: rain > 50 ? FontWeight.bold : FontWeight.normal, color: rain > 50 ? Colors.redAccent : null)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.air, color: aqi > 400 ? Colors.red : (aqi > 150 ? Colors.orange : Colors.green), size: 20),
                          const SizedBox(width: 8),
                          Text('Pollution AQI: $aqi', style: TextStyle(fontSize: 16, fontWeight: aqi > 400 ? FontWeight.bold : FontWeight.normal, color: aqi > 400 ? Colors.redAccent : null)),
                        ],
                      ),
                    ],
                  ),
                ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(16), boxShadow: [if(!isDark) const BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Trust Score', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('87/100', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(value: 0.87, backgroundColor: Colors.grey[200], color: Colors.green, minHeight: 8, borderRadius: BorderRadius.circular(4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------
// View: Profile & Settings
// ----------------------------------------------------------------------
class _ProfileView extends StatelessWidget {
  final Map<String, dynamic> userData;
  const _ProfileView({required this.userData});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CircleAvatar(radius: 50, backgroundColor: colorOrange, child: Icon(Icons.person, size: 50, color: Colors.white)),
            const SizedBox(height: 16),
            Text(userData["name"], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(userData["phone"] ?? '', style: TextStyle(fontSize: 16, color: Theme.of(context).hintColor)),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(16), boxShadow: [if(!isDark) const BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))]),
              child: Column(
                children: [
                  ValueListenableBuilder<ThemeMode>(
                    valueListenable: themeNotifier,
                    builder: (context, currentMode, child) {
                      return SwitchListTile(
                        secondary: Icon(currentMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode, color: colorOrange),
                        title: const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.bold)),
                        value: currentMode == ThemeMode.dark,
                        activeColor: colorOrange,
                        onChanged: (val) {
                          themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                        },
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.work, color: colorOrange),
                    title: Text('Service Provider', style: TextStyle(color: Theme.of(context).hintColor, fontSize: 14)),
                    subtitle: Text(userData["platform"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.badge, color: colorOrange),
                    title: Text('Partner ID', style: TextStyle(color: Theme.of(context).hintColor, fontSize: 14)),
                    subtitle: Text(userData["id"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.location_on, color: colorOrange),
                    title: Text('Registered Zone', style: TextStyle(color: Theme.of(context).hintColor, fontSize: 14)),
                    subtitle: Text(userData["pin"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              onPressed: () => context.go('/'),
              icon: const Icon(Icons.logout),
              label: const Text('Logout', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                foregroundColor: Colors.redAccent,
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.redAccent)),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------
// Screen 3: Alert
// ----------------------------------------------------------------------
class AlertScreen extends StatefulWidget {
  const AlertScreen({super.key});
  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) context.go('/payout');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 80),
              const SizedBox(height: 24),
              const Text('Danger Threshold Breached', textAlign: TextAlign.center, style: TextStyle(color: Colors.redAccent, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              const Text('Automated Verification Started', textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
              const SizedBox(height: 48),
              Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: const Text('Trigger verified locally.\nFraud model analysis pending...', textAlign: TextAlign.center, style: TextStyle(color: colorOrange, fontSize: 16))),
              const SizedBox(height: 48),
              const CircularProgressIndicator(color: colorOrange),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------
// Screen 4: Payout
// ----------------------------------------------------------------------
class PayoutScreen extends StatelessWidget {
  const PayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 100),
              const SizedBox(height: 24),
              const Text('₹900 sent to your UPI', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(16)),
                child: const Text('Payout Breakdown:\n1.5 disruption days × ₹600 daily avg = ₹900', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, height: 1.5)),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () => context.go('/dashboard'),
                style: ElevatedButton.styleFrom(backgroundColor: colorOrange, foregroundColor: Colors.white, minimumSize: const Size(200, 56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                child: const Text('Back to Home', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
