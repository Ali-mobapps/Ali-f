import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/dynetix_widgets.dart';
import '../widgets/add_team_member_modal.dart';

class TeamManagementScreen extends StatefulWidget {
  const TeamManagementScreen({super.key});

  @override
  State<TeamManagementScreen> createState() => _TeamManagementScreenState();
}

class _TeamManagementScreenState extends State<TeamManagementScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _teamMembers = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _roleFilter = 'all'; // 'all', 'admin', 'team_member'

  @override
  void initState() {
    super.initState();
    _fetchTeamMembers();
  }

  Future<void> _fetchTeamMembers() async {
    setState(() => _isLoading = true);
    try {
      final List<dynamic> response = await _supabase
          .from('users')
          .select()
          .order('name', ascending: true);

      final List<Map<String, dynamic>> allUsers =
          List<Map<String, dynamic>>.from(response);

      // Filter users who are admins, team_members, or whitelisted
      final filtered = allUsers.where((user) {
        final role = (user['role'] ?? '').toString().toLowerCase();
        final isWhitelisted = user['is_whitelisted'] == true;
        final email = (user['email'] ?? '').toString().toLowerCase();

        return role == 'admin' ||
            role == 'team_member' ||
            isWhitelisted ||
            email == 'info@dynetixhub.com';
      }).toList();

      setState(() {
        _teamMembers = filtered;
        _isLoading = false;
      });
    } catch (e) {
      // Fallback default list if DB offline or empty
      setState(() {
        _teamMembers = [
          {
            'id': '1',
            'name': 'Master Admin',
            'email': 'info@dynetixhub.com',
            'role': 'admin',
            'is_whitelisted': true,
            'temp_password': 'MasterPassword',
          },
        ];
        _isLoading = false;
      });
    }
  }

  Future<void> _updateMemberRole(String email, String newRole) async {
    try {
      await _supabase.from('users').update({
        'role': newRole,
        'is_whitelisted': true,
      }).eq('email', email);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Updated role to ${newRole == "admin" ? "Admin" : "Team Member"}'),
          backgroundColor: AppColors.success,
        ),
      );
      _fetchTeamMembers();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update role: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _removeTeamMember(String email, String name) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Access?'),
        content: Text('Are you sure you want to revoke admin/team access for "$name"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('REMOVE'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _supabase.from('users').update({
        'role': 'customer',
        'is_whitelisted': false,
      }).eq('email', email);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Revoked access for "$name"'),
          backgroundColor: AppColors.success,
        ),
      );
      _fetchTeamMembers();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to remove member: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _teamMembers.where((member) {
      final name = (member['name'] ?? '').toString().toLowerCase();
      final email = (member['email'] ?? '').toString().toLowerCase();
      final role = (member['role'] ?? '').toString().toLowerCase();

      final matchesSearch =
          name.contains(_searchQuery.toLowerCase()) || email.contains(_searchQuery.toLowerCase());

      final matchesRole = _roleFilter == 'all' ||
          (_roleFilter == 'admin' && role == 'admin') ||
          (_roleFilter == 'team_member' && role == 'team_member');

      return matchesSearch && matchesRole;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'TEAM & WHITELIST',
          style: TextStyle(letterSpacing: 2, fontSize: 14, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.primary),
            onPressed: _fetchTeamMembers,
            tooltip: 'Refresh List',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => AddTeamMemberModal.show(
          context,
          onMemberAdded: _fetchTeamMembers,
        ),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'Add Member',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // Top Banner / Add Trigger
          Container(
            padding: const EdgeInsets.all(20),
            color: AppColors.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Authorized Management',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Manage administrators and whitelisted team members with access.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textDisabled,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () => AddTeamMemberModal.show(
                        context,
                        onMemberAdded: _fetchTeamMembers,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
                      label: const Text(
                        'Whitelist Member',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Search & Filter Row
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (val) => setState(() => _searchQuery = val),
                        decoration: InputDecoration(
                          hintText: 'Search by name or email...',
                          hintStyle: const TextStyle(fontSize: 13, color: AppColors.textDisabled),
                          prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.textDisabled),
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                          filled: true,
                          fillColor: AppColors.softGrey,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Role Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All Members', 'all'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Admins Only', 'admin'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Team Members', 'team_member'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Member List View
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : filteredList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shield_outlined,
                                size: 60, color: AppColors.primary.withValues(alpha: 0.3)),
                            const SizedBox(height: 16),
                            const Text(
                              'No team members found',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Tap "+ Whitelist Member" to add a new administrator.',
                              style: TextStyle(fontSize: 12, color: AppColors.textDisabled),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: () => AddTeamMemberModal.show(
                                context,
                                onMemberAdded: _fetchTeamMembers,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                              ),
                              icon: const Icon(Icons.add),
                              label: const Text('Add Team Member / Whitelist'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final member = filteredList[index];
                          final name = member['name'] ?? 'Unnamed Member';
                          final email = member['email'] ?? '';
                          final role = (member['role'] ?? 'team_member').toString().toLowerCase();
                          final tempPassword = member['temp_password'] ?? '';
                          final isAdmin = role == 'admin';

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: GlassPanel(
                              padding: 16,
                              borderColor: isAdmin
                                  ? AppColors.primary.withValues(alpha: 0.3)
                                  : AppColors.glassBorder,
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 22,
                                    backgroundColor: isAdmin
                                        ? AppColors.primary.withValues(alpha: 0.1)
                                        : Colors.grey.withValues(alpha: 0.1),
                                    child: Icon(
                                      isAdmin
                                          ? Icons.shield_rounded
                                          : Icons.person_rounded,
                                      color: isAdmin ? AppColors.primary : AppColors.textSecondary,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                name,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: isAdmin
                                                    ? AppColors.primary.withValues(alpha: 0.1)
                                                    : Colors.grey.withValues(alpha: 0.15),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                isAdmin ? 'ADMIN' : 'TEAM MEMBER',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: isAdmin
                                                      ? AppColors.primary
                                                      : AppColors.textSecondary,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          email,
                                          style: const TextStyle(
                                            fontSize: 12.5,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        if (tempPassword.toString().isNotEmpty) ...[
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(Icons.key_rounded,
                                                  size: 12, color: AppColors.textDisabled),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Pass: $tempPassword',
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  color: AppColors.textDisabled,
                                                  fontFamily: 'monospace',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_vert_rounded,
                                        color: AppColors.textDisabled),
                                    onSelected: (value) {
                                      if (value == 'make_admin') {
                                        _updateMemberRole(email, 'admin');
                                      } else if (value == 'make_member') {
                                        _updateMemberRole(email, 'team_member');
                                      } else if (value == 'remove') {
                                        _removeTeamMember(email, name);
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      if (!isAdmin)
                                        const PopupMenuItem(
                                          value: 'make_admin',
                                          child: Row(
                                            children: [
                                              Icon(Icons.shield_outlined,
                                                  size: 18, color: AppColors.primary),
                                              SizedBox(width: 10),
                                              Text('Grant Full Admin'),
                                            ],
                                          ),
                                        ),
                                      if (isAdmin && email != 'info@dynetixhub.com')
                                        const PopupMenuItem(
                                          value: 'make_member',
                                          child: Row(
                                            children: [
                                              Icon(Icons.person_outline, size: 18),
                                              SizedBox(width: 10),
                                              Text('Change to Team Member'),
                                            ],
                                          ),
                                        ),
                                      if (email != 'info@dynetixhub.com')
                                        const PopupMenuItem(
                                          value: 'remove',
                                          child: Row(
                                            children: [
                                              Icon(Icons.remove_circle_outline_rounded,
                                                  size: 18, color: AppColors.error),
                                              SizedBox(width: 10),
                                              Text('Revoke Access',
                                                  style: TextStyle(color: AppColors.error)),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _roleFilter == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => setState(() => _roleFilter = value),
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.softGrey,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        color: isSelected ? Colors.white : AppColors.textSecondary,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
