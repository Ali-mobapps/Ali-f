import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '100 Flutter Tasks',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A1A1A),
          secondary: const Color(0xFF0066FF),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}

// ==================== TASK 1: Welcome Screen ====================
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Center(
                child: Container(
                  height: 180,
                  width: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.spa_rounded,
                    size: 80,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'PRISTINE MINIMAL ☁️',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Clean typography, serene whitespace, and ultra-refined floating aesthetics.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Color(0xFF666666), height: 1.4, fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A1A1A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text('EXPLORE PRISTINE', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: 1)),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== TASK 2: Login Page UI ====================
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Color(0xFF1A1A1A))),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'WELCOME BACK ✨',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFF1A1A1A), letterSpacing: 1),
                ),
                const SizedBox(height: 8),
                const Text('Sign in securely to your pristine workspace', style: TextStyle(fontSize: 15, color: Color(0xFF666666), fontWeight: FontWeight.w500)),
                const SizedBox(height: 40),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    labelStyle: const TextStyle(color: Color(0xFF888888), fontWeight: FontWeight.w600),
                    prefixIcon: const Icon(Icons.mail_outline_rounded, color: Color(0xFF1A1A1A)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF1A1A1A), width: 1.5)),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Color(0xFF888888), fontWeight: FontWeight.w600),
                    prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFF1A1A1A)),
                    suffixIcon: const Icon(Icons.visibility_off, color: Color(0xFF888888)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF1A1A1A), width: 1.5)),
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                      );
                    },
                    child: const Text('Forgot Password?', style: TextStyle(color: Color(0xFF0066FF), fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const pristine_audio_pod()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A1A1A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text('SIGN IN', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: 1)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== TASK 3: Signup Page UI ====================
class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Color(0xFF1A1A1A))),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'CREATE ACCOUNT 🌿',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFF1A1A1A), letterSpacing: 1),
                ),
                const SizedBox(height: 8),
                const Text('Join the pristine design environment today', style: TextStyle(fontSize: 15, color: Color(0xFF666666), fontWeight: FontWeight.w500)),
                const SizedBox(height: 35),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    labelStyle: const TextStyle(color: Color(0xFF888888), fontWeight: FontWeight.w600),
                    prefixIcon: const Icon(Icons.person_outline_rounded, color: Color(0xFF1A1A1A)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF1A1A1A), width: 1.5)),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    labelStyle: const TextStyle(color: Color(0xFF888888), fontWeight: FontWeight.w600),
                    prefixIcon: const Icon(Icons.mail_outline_rounded, color: Color(0xFF1A1A1A)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF1A1A1A), width: 1.5)),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Color(0xFF888888), fontWeight: FontWeight.w600),
                    prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFF1A1A1A)),
                    suffixIcon: const Icon(Icons.visibility_off, color: Color(0xFF888888)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF1A1A1A), width: 1.5)),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const OtpVerificationPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A1A1A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text('SIGN UP', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: 1)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== TASK 4: Forgot Password Page ====================
class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Color(0xFF1A1A1A))),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('RECOVER ACCESS 🔐', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFF1A1A1A), letterSpacing: 1)),
            const SizedBox(height: 8),
            const Text('Enter your email to receive a secure recovery link.', style: TextStyle(fontSize: 15, color: Color(0xFF666666), fontWeight: FontWeight.w500)),
            const SizedBox(height: 40),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email Address',
                labelStyle: const TextStyle(color: Color(0xFF888888), fontWeight: FontWeight.w600),
                prefixIcon: const Icon(Icons.mail_outline_rounded, color: Color(0xFF1A1A1A)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF1A1A1A), width: 1.5)),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A1A1A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: const Text('SEND RECOVERY LINK', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: 1)),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== TASK 5: OTP Verification Screen ====================
class OtpVerificationPage extends StatelessWidget {
  const OtpVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Color(0xFF1A1A1A))),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('VERIFY CODE 🔒', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFF1A1A1A), letterSpacing: 1)),
            const SizedBox(height: 8),
            const Text('Enter the 4-digit verification code sent to you.', style: TextStyle(fontSize: 15, color: Color(0xFF666666), fontWeight: FontWeight.w500)),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) => SizedBox(
                width: 60,
                height: 60,
                child: TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1A1A1A)),
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF1A1A1A), width: 1.5)),
                  ),
                ),
              )),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const pristine_audio_pod()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A1A1A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: const Text('VERIFY & PROCEED', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: 1)),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ==================== TASKS 6-31 Placeholders ====================
class ProfileCardPage extends StatelessWidget {
  const ProfileCardPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Profile Card')));
}
class UserInfoCardPage extends StatelessWidget {
  const UserInfoCardPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('User Info Card')));
}
class ContactCardPage extends StatelessWidget {
  const ContactCardPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Contact Card')));
}
class ProductCardPage extends StatelessWidget {
  const ProductCardPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Product Card')));
}
class ArticleCardPage extends StatelessWidget {
  const ArticleCardPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Article Card')));
}
class WeatherCardPage extends StatelessWidget {
  const WeatherCardPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Weather Card')));
}
class MusicPlayerCardPage extends StatelessWidget {
  const MusicPlayerCardPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Music Player Card')));
}
class FitnessCardPage extends StatelessWidget {
  const FitnessCardPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Fitness Card')));
}
class RecipeCardPage extends StatelessWidget {
  const RecipeCardPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Recipe Card')));
}
class HotelCardPage extends StatelessWidget {
  const HotelCardPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Hotel Card')));
}
class EventCardPage extends StatelessWidget {
  const EventCardPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Event Card')));
}
class JobCardPage extends StatelessWidget {
  const JobCardPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Job Card')));
}
class NotificationCardPage extends StatelessWidget {
  const NotificationCardPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Notification Card')));
}
class WalletCardPage extends StatelessWidget {
  const WalletCardPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Wallet Card')));
}
class AnalyticsCardPage extends StatelessWidget {
  const AnalyticsCardPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Analytics Card')));
}
class FlashSaleCardPage extends StatelessWidget {
  const FlashSaleCardPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Flash Sale Card')));
}
class audio_podcast_card extends StatelessWidget {
  const audio_podcast_card({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Audio Podcast Card')));
}
class skill_progress_card extends StatelessWidget {
  const skill_progress_card({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Skill Progress Card')));
}
class crypto_portfolio_card extends StatelessWidget {
  const crypto_portfolio_card({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Crypto Portfolio Card')));
}
class cyberpunk_event_pass extends StatelessWidget {
  const cyberpunk_event_pass({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Cyberpunk Event Pass')));
}
class system_metrics_card extends StatelessWidget {
  const system_metrics_card({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('System Metrics Card')));
}
class neural_implant_card extends StatelessWidget {
  const neural_implant_card({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Neural Implant Card')));
}
class brutal_creative_card extends StatelessWidget {
  const brutal_creative_card({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Brutal Creative Card')));
}
class glass_cyber_profile extends StatelessWidget {
  const glass_cyber_profile({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Glass Cyber Profile')));
}
class cyber_neon_grid extends StatelessWidget {
  const cyber_neon_grid({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Cyber Neon Grid')));
}
class pristine_minimal_card extends StatelessWidget {
  const pristine_minimal_card({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Pristine Minimal Card')));
}

// ==================== TASK 32: Pristine Minimalist Audio Frequency Pod ====================
class pristine_audio_pod extends StatefulWidget {
  const pristine_audio_pod({super.key});

  @override
  State<pristine_audio_pod> createState() => _pristine_audio_podState();
}

class _pristine_audio_podState extends State<pristine_audio_pod> {
  bool isPlaying = false;
  double sliderVal = 0.45;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text('FREQUENCY POD', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, letterSpacing: 1.5)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF1A1A1A)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 35,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F2F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'FREQUENCY 432Hz',
                        style: TextStyle(
                          color: Color(0xFF1A1A1A),
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const Icon(Icons.waves_rounded, color: Color(0xFF0066FF), size: 22),
                  ],
                ),
                const SizedBox(height: 22),
                const Text(
                  'Deep Focus Alpha',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Binaural soundwave for absolute concentration and serenity.',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF666666),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                // Simulated Waveform Bars
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(18, (index) {
                    final heights = [12.0, 24.0, 36.0, 18.0, 42.0, 28.0, 34.0, 15.0, 40.0, 25.0, 30.0, 45.0, 20.0, 38.0, 22.0, 32.0, 16.0, 26.0];
                    return Container(
                      width: 4,
                      height: heights[index % heights.length],
                      decoration: BoxDecoration(
                        color: index.isEven && isPlaying ? const Color(0xFF0066FF) : const Color(0xFFD1D5DB),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: const Color(0xFF1A1A1A),
                    inactiveTrackColor: const Color(0xFFE5E7EB),
                    thumbColor: const Color(0xFF1A1A1A),
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                  ),
                  child: Slider(
                    value: sliderVal,
                    onChanged: (val) {
                      setState(() {
                        sliderVal = val;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isPlaying = !isPlaying;
                        });
                      },
                      icon: Icon(
                        isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded,
                        size: 56,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}