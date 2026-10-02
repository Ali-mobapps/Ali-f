import 'package:flutter/material.dart';

void main() {
  runApp(const StudentDigitalCardApp());
}

class StudentDigitalCardApp extends StatelessWidget {
  const StudentDigitalCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Digital ID & Campus Dashboard',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A), // Navy Blue
          primary: const Color(0xFF1E3A8A),
          secondary: const Color(0xFF0D9488),
        ),
        scaffoldBackgroundColor: const Color(0xFFF1F5F9),
      ),
      home: const CampusDashboardScreen(),
    );
  }
}

// Global Student Profile Data Model
class StudentProfile {
  static const String name = 'ALI HASSAN';
  static const String regNo = 'FA24-BSE-013';
  static const String department = 'Software Engineering';
  static const String semester = '2nd / 4th';
  static const String email = 'alihassan6236007@gmail.com';
  static const String campus = 'COMSATS University Islamabad';
  static const String cgpa = '3.72';
}

// Shared Enrolled Courses Data
final List<Map<String, String>> globalCourses = [
  {
    'code': 'CSC303',
    'name': 'Mobile Application Development',
    'instructor': 'Dr. Kashif / Lab Instructor',
    'credits': '3+1 Cr',
    'room': 'Lab 3',
    'day': 'Mon & Wed',
    'timing': '10:00 AM - 11:30 AM',
    'grade': 'A',
    'description': 'Flutter, Dart, Mobile UI Layouts, State Management, and Widget Architectures.',
  },
  {
    'code': 'CSC312',
    'name': 'Software Engineering',
    'instructor': 'Engr. Sarah Khan',
    'credits': '3 Cr',
    'room': 'Room 102',
    'day': 'Tue & Thu',
    'timing': '08:30 AM - 10:00 AM',
    'grade': 'A-',
    'description': 'SDLC models, Agile/Scrum methodologies, Requirement Engineering, and SRS.',
  },
  {
    'code': 'CSC354',
    'name': 'Database Systems',
    'instructor': 'Prof. M. Usman',
    'credits': '3+1 Cr',
    'room': 'Lab 1',
    'day': 'Mon & Fri',
    'timing': '11:30 AM - 01:00 PM',
    'grade': 'B+',
    'description': 'Relational database design, Normalization, SQL Queries, and ER diagrams.',
  },
  {
    'code': 'CSC322',
    'name': 'Computer Networks',
    'instructor': 'Dr. Tariq Mahmood',
    'credits': '3+1 Cr',
    'room': 'Room 205',
    'day': 'Wednesday',
    'timing': '01:30 PM - 04:30 PM',
    'grade': 'A',
    'description': 'OSI model, TCP/IP protocols, Subnetting, routing algorithms, and socket programming.',
  },
  {
    'code': 'HUM102',
    'name': 'Technical & Business Writing',
    'instructor': 'Ms. Ayesha Siddiqa',
    'credits': '3 Cr',
    'room': 'Room 304',
    'day': 'Thursday',
    'timing': '10:00 AM - 11:30 AM',
    'grade': 'A',
    'description': 'Professional emails, research papers, resumes, and presentation writing.',
  },
];

// ==========================================
// 1. MAIN DASHBOARD SCREEN (Responsive)
// ==========================================
class CampusDashboardScreen extends StatefulWidget {
  const CampusDashboardScreen({super.key});

  @override
  State<CampusDashboardScreen> createState() => _CampusDashboardScreenState();
}

class _CampusDashboardScreenState extends State<CampusDashboardScreen> {
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  // Search State
  bool _isSearching = false;
  String _searchQuery = '';

  // Online / Active status toggle
  bool _isOnline = true;

  // Quick Notes List
  final List<String> _quickNotes = [
    'MAD Lab Assignment submission due tomorrow.',
    'Prepare Software Engineering SRS document presentation.',
  ];

  @override
  void dispose() {
    _noteController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, String>> get _filteredCourses {
    if (_searchQuery.isEmpty) return globalCourses;
    return globalCourses.where((course) {
      final name = course['name']!.toLowerCase();
      final code = course['code']!.toLowerCase();
      final instructor = course['instructor']!.toLowerCase();
      final q = _searchQuery.toLowerCase();
      return name.contains(q) || code.contains(q) || instructor.contains(q);
    }).toList();
  }

  void _addQuickNote() {
    final text = _noteController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter text before submitting!'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _quickNotes.insert(0, text);
      _noteController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('Note saved to dashboard!'),
          ],
        ),
        backgroundColor: Colors.teal.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _deleteNote(int index) {
    final removed = _quickNotes[index];
    setState(() {
      _quickNotes.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Note deleted: "$removed"'),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.yellow,
          onPressed: () {
            setState(() {
              _quickNotes.insert(index, removed);
            });
          },
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _toggleStatus() {
    setState(() {
      _isOnline = !_isOnline;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isOnline ? 'Status: Active (Online)' : 'Status: Inactive (Offline)'),
        backgroundColor: _isOnline ? Colors.green.shade700 : Colors.grey.shade700,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showCourseDetails(Map<String, String> course) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A8A),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                course['code']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                course['name']!,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _detailRow(Icons.person, 'Instructor', course['instructor']!),
              const SizedBox(height: 10),
              _detailRow(Icons.meeting_room, 'Room', course['room']!),
              const SizedBox(height: 10),
              _detailRow(Icons.access_time, 'Schedule', '${course['day']} (${course['timing']})'),
              const SizedBox(height: 10),
              _detailRow(Icons.credit_card, 'Credit Hours', course['credits']!),
              const Divider(height: 24),
              const Text(
                'Course Description:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                course['description']!,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 13, height: 1.4),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String title, String val) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF1E3A8A)),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black87, fontSize: 13),
              children: [
                TextSpan(text: '$title: ', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                TextSpan(text: val, style: TextStyle(color: Colors.grey.shade800)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _navigateDrawerScreen(Widget screen) {
    Navigator.pop(context); // Close Drawer
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to log out of Campus Dashboard?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. HEADER & NAVIGATION - AppBar
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search courses, codes, instructors...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onChanged: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                },
              )
            : const Text(
                'Campus Dashboard',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
              ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        elevation: 2,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            tooltip: 'Drawer Menu',
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            tooltip: _isSearching ? 'Close Search' : 'Search Courses',
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchQuery = '';
                  _searchController.clear();
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
        ],
      ),

      // 1. HEADER & NAVIGATION - Drawer
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              currentAccountPicture: GestureDetector(
                onTap: _toggleStatus,
                child: Stack(
                  children: [
                    const CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 33,
                        backgroundColor: Color(0xFFDBEAFE),
                        child: Icon(Icons.person, size: 40, color: Color(0xFF1E3A8A)),
                      ),
                    ),
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color: _isOnline ? Colors.greenAccent.shade700 : Colors.grey,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              accountName: const Text(
                StudentProfile.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              accountEmail: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    StudentProfile.regNo,
                    style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                  SizedBox(height: 2),
                  Text(
                    StudentProfile.email,
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.badge, color: Color(0xFF1E3A8A)),
              title: const Text('Digital Student ID'),
              subtitle: const Text('Official ID Card & QR Code'),
              trailing: const Icon(Icons.chevron_right, size: 18),
              onTap: () => _navigateDrawerScreen(DigitalIdScreen(isOnline: _isOnline, onToggleStatus: _toggleStatus)),
            ),
            ListTile(
              leading: const Icon(Icons.book, color: Color(0xFF1E3A8A)),
              title: const Text('Registered Courses'),
              subtitle: Text('${globalCourses.length} enrolled subjects'),
              trailing: const Icon(Icons.chevron_right, size: 18),
              onTap: () => _navigateDrawerScreen(const RegisteredCoursesScreen()),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month, color: Color(0xFF1E3A8A)),
              title: const Text('Academic Schedule'),
              subtitle: const Text('Class timings & locations'),
              trailing: const Icon(Icons.chevron_right, size: 18),
              onTap: () => _navigateDrawerScreen(const AcademicScheduleScreen()),
            ),
            ListTile(
              leading: const Icon(Icons.grade, color: Color(0xFF1E3A8A)),
              title: const Text('Grades & Transcript'),
              subtitle: const Text('GPA and academic standing'),
              trailing: const Icon(Icons.chevron_right, size: 18),
              onTap: () => _navigateDrawerScreen(const GradesTranscriptScreen()),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.wifi_tethering, color: Color(0xFF0D9488)),
              title: const Text('Status (Online/Offline)'),
              subtitle: Text(_isOnline ? 'Active Online' : 'Inactive Offline'),
              trailing: Switch(
                value: _isOnline,
                onChanged: (val) {
                  _toggleStatus();
                  Navigator.pop(context);
                },
                activeThumbColor: const Color(0xFF0D9488),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.grey),
              title: const Text('Settings'),
              trailing: const Icon(Icons.chevron_right, size: 18),
              onTap: () => _navigateDrawerScreen(const SettingsScreen()),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                _showLogoutDialog();
              },
            ),
          ],
        ),
      ),

      // Main Screen Content (Wrapped in SafeArea for Mobile Screens)
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section 1: Digital ID Card (Tap-able to open full screen ID view)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DigitalIdScreen(isOnline: _isOnline, onToggleStatus: _toggleStatus),
                      ),
                    );
                  },
                  child: _buildDigitalIdCard(),
                ),

                const SizedBox(height: 18),

                // Section 2: Header for Courses (Overflow-safe)
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _isSearching ? 'Search Results' : 'Enrolled Courses (Current Semester)',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDBEAFE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_filteredCourses.length} Subjects',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E3A8A),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // 4. COURSES / SUBJECTS LIST (ListView.builder & ListTile)
                if (_filteredCourses.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Icon(Icons.search_off, size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 8),
                        Text(
                          'No courses matching "$_searchQuery"',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                        ),
                      ],
                    ),
                  )
                else
                  ListView.builder(
                    itemCount: _filteredCourses.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final course = _filteredCourses[index];
                      return Card(
                        elevation: 1.5,
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => _showCourseDetails(course),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            leading: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E3A8A).withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  course['code']!.substring(0, 3),
                                  style: const TextStyle(
                                    color: Color(0xFF1E3A8A),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              course['name']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13.5,
                                color: Color(0xFF1E293B),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Text(
                                '${course['code']} • ${course['instructor']} • ${course['room']}',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: Colors.grey.shade600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.teal.shade50,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.teal.shade200),
                              ),
                              child: Text(
                                course['credits']!,
                                style: TextStyle(
                                  color: Colors.teal.shade800,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                const SizedBox(height: 16),

                // 5. QUICK NOTES / SEARCH INPUT (TextField & ElevatedButton)
                const Text(
                  'Quick Notes / Search Query',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),

                Card(
                  elevation: 1.5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _noteController,
                          onSubmitted: (_) => _addQuickNote(),
                          decoration: InputDecoration(
                            hintText: 'Type a quick reminder, note, or query...',
                            hintStyle: const TextStyle(fontSize: 13),
                            prefixIcon: const Icon(Icons.note_alt_outlined, size: 20),
                            suffixIcon: _noteController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 18),
                                    onPressed: () {
                                      setState(() {
                                        _noteController.clear();
                                      });
                                    },
                                  )
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                '${_quickNotes.length} notes saved',
                                style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: _addQuickNote,
                              icon: const Icon(Icons.send_rounded, size: 16),
                              label: const Text('Submit Note', style: TextStyle(fontSize: 13)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E3A8A),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                if (_quickNotes.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Your Quick Notes:',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A8A),
                        ),
                      ),
                      Text(
                        'Swipe or tap trash to delete',
                        style: TextStyle(fontSize: 10.5, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    itemCount: _quickNotes.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final note = _quickNotes[index];
                      return Dismissible(
                        key: Key('$note$index'),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => _deleteNote(index),
                        background: Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.red.shade400,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.centerRight,
                          child: const Icon(Icons.delete, color: Colors.white, size: 20),
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 3,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.bookmark_border,
                                color: Color(0xFF1E3A8A),
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  note,
                                  style: const TextStyle(fontSize: 12.5, height: 1.3),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                                tooltip: 'Delete Note',
                                onPressed: () => _deleteNote(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 2. PROFILE & ID CARD (Stack & Card - Overflow-Safe)
  // 3. STUDENT INFO & ALIGNMENT (Column & Row, SizedBox, Padding)
  Widget _buildDigitalIdCard() {
    return Card(
      elevation: 5,
      shadowColor: const Color(0xFF1E3A8A).withValues(alpha: 0.35),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF1E3A8A), // Deep Navy Blue
              Color(0xFF1E40AF),
              Color(0xFF2563EB), // Vibrant Blue
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Institution Header (Row)
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: const [
                      Icon(Icons.school, color: Colors.white, size: 24),
                      SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'CAMPUS DIGITAL ID',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '2024 - 2028',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const Divider(color: Colors.white24, height: 20, thickness: 1),

            // Profile Picture with Stack + Student Info
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 2. STACK WIDGET with CircleAvatar and Green Active/Online Dot
                GestureDetector(
                  onTap: _toggleStatus,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2.5),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const CircleAvatar(
                          radius: 34,
                          backgroundColor: Color(0xFFDBEAFE),
                          child: Icon(
                            Icons.person,
                            size: 46,
                            color: Color(0xFF1E3A8A),
                          ),
                        ),
                      ),
                      // Green Active/Online Dot Overlay
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Tooltip(
                          message: _isOnline ? 'Online / Active' : 'Offline',
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: _isOnline ? Colors.greenAccent.shade400 : Colors.grey.shade400,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2.5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 3,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 14),

                // 3. STUDENT DETAILS (Column & Row)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        StudentProfile.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Reg No: ${StudentProfile.regNo}',
                        style: TextStyle(
                          color: Colors.yellowAccent.shade100,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                StudentProfile.department,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10.5,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Card Bottom Details (Row with 3 Columns)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(child: _buildCardMetric('DEPARTMENT', 'Software Eng.')),
                  Container(width: 1, height: 24, color: Colors.white24),
                  Expanded(child: _buildCardMetric('SEMESTER', StudentProfile.semester)),
                  Container(width: 1, height: 24, color: Colors.white24),
                  Expanded(child: _buildCardMetric('STATUS', _isOnline ? 'Active' : 'Offline')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardMetric(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 8.5,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

// ==========================================
// 2. DEDICATED DIGITAL STUDENT ID SCREEN
// ==========================================
class DigitalIdScreen extends StatelessWidget {
  final bool isOnline;
  final VoidCallback onToggleStatus;

  const DigitalIdScreen({
    super.key,
    required this.isOnline,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Student ID'),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: const [
                                Icon(Icons.school, color: Colors.white, size: 24),
                                SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    'STUDENT IDENTIFICATION',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      letterSpacing: 0.8,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.greenAccent.shade400,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'VERIFIED',
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.white30, height: 24),
                      Center(
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const CircleAvatar(
                                radius: 46,
                                backgroundColor: Color(0xFFDBEAFE),
                                child: Icon(Icons.person, size: 60, color: Color(0xFF1E3A8A)),
                              ),
                            ),
                            Positioned(
                              bottom: 4,
                              right: 4,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: isOnline ? Colors.greenAccent.shade400 : Colors.grey,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        StudentProfile.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Registration #: ${StudentProfile.regNo}',
                        style: TextStyle(
                          color: Colors.yellowAccent.shade100,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '${StudentProfile.department} • ${StudentProfile.semester}',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 18),

                      // QR Code Simulator
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.qr_code_2, size: 90, color: Color(0xFF1E3A8A)),
                            const SizedBox(height: 4),
                            Text(
                              'Scan for Gate Verification',
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade700, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.wifi_tethering, color: Color(0xFF0D9488)),
                  title: const Text('Active Status'),
                  subtitle: Text(isOnline ? 'Currently Online & Active' : 'Currently Offline'),
                  trailing: ElevatedButton(
                    onPressed: onToggleStatus,
                    child: Text(isOnline ? 'Go Offline' : 'Go Online'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 3. DEDICATED REGISTERED COURSES SCREEN
// ==========================================
class RegisteredCoursesScreen extends StatelessWidget {
  const RegisteredCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registered Courses'),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(14),
          itemCount: globalCourses.length,
          itemBuilder: (ctx, idx) {
            final course = globalCourses[idx];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          course['code']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xFF1E3A8A),
                          ),
                        ),
                        Chip(
                          label: Text(course['credits']!, style: const TextStyle(fontSize: 11)),
                          backgroundColor: Colors.teal.shade50,
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                    Text(
                      course['name']!,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text('Instructor: ${course['instructor']}', style: const TextStyle(fontSize: 12.5)),
                    Text('Location: ${course['room']}', style: const TextStyle(fontSize: 12.5)),
                    Text('Timings: ${course['day']} (${course['timing']})', style: const TextStyle(fontSize: 12.5)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ==========================================
// 4. DEDICATED ACADEMIC SCHEDULE SCREEN
// ==========================================
class AcademicScheduleScreen extends StatelessWidget {
  const AcademicScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Academic Schedule'),
          backgroundColor: const Color(0xFF1E3A8A),
          foregroundColor: Colors.white,
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            indicatorColor: Colors.amberAccent,
            tabs: [
              Tab(text: 'Monday'),
              Tab(text: 'Tuesday'),
              Tab(text: 'Wednesday'),
              Tab(text: 'Thursday'),
              Tab(text: 'Friday'),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              _scheduleDay(['CSC303', 'CSC354']),
              _scheduleDay(['CSC312']),
              _scheduleDay(['CSC303', 'CSC322']),
              _scheduleDay(['CSC312', 'HUM102']),
              _scheduleDay(['CSC354']),
            ],
          ),
        ),
      ),
    );
  }

  Widget _scheduleDay(List<String> codes) {
    final dayCourses = globalCourses.where((c) => codes.contains(c['code'])).toList();
    if (dayCourses.isEmpty) {
      return const Center(child: Text('No classes scheduled for this day!'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: dayCourses.length,
      itemBuilder: (ctx, idx) {
        final c = dayCourses[idx];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: const Icon(Icons.access_time_filled, color: Color(0xFF1E3A8A), size: 32),
            title: Text('${c['code']} - ${c['name']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
            subtitle: Text('Time: ${c['timing']}\nRoom: ${c['room']} | ${c['instructor']}', style: const TextStyle(fontSize: 12)),
          ),
        );
      },
    );
  }
}

// ==========================================
// 5. DEDICATED GRADES & TRANSCRIPT SCREEN
// ==========================================
class GradesTranscriptScreen extends StatelessWidget {
  const GradesTranscriptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grades & Transcript'),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: const Color(0xFF1E3A8A),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _statCol('CGPA', StudentProfile.cgpa, Colors.yellowAccent),
                      _statCol('CREDITS', '48', Colors.white),
                      _statCol('STANDING', 'Good', Colors.greenAccent),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Current Semester Course Grades:',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...globalCourses.map(
                (c) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(c['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                    subtitle: Text('${c['code']} • ${c['credits']}', style: const TextStyle(fontSize: 12)),
                    trailing: CircleAvatar(
                      radius: 18,
                      backgroundColor: const Color(0xFF1E3A8A),
                      child: Text(
                        c['grade']!,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCol(String label, String val, Color valColor) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(val, style: TextStyle(color: valColor, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

// ==========================================
// 6. DEDICATED SETTINGS SCREEN
// ==========================================
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            SwitchListTile(
              title: const Text('Push Notifications'),
              subtitle: const Text('Receive class reminders and campus alerts'),
              value: _notifications,
              onChanged: (val) => setState(() => _notifications = val),
            ),
            SwitchListTile(
              title: const Text('Dark Mode Preview'),
              subtitle: const Text('Toggle dark theme layout'),
              value: _darkMode,
              onChanged: (val) => setState(() => _darkMode = val),
            ),
            const Divider(),
            const ListTile(
              title: Text('App Version'),
              subtitle: Text('1.0.0 (Build 2024.1)'),
              leading: Icon(Icons.info_outline),
            ),
          ],
        ),
      ),
    );
  }
}
