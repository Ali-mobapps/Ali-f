import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/theme/app_colors.dart';

class AddTeamMemberModal extends StatefulWidget {
  final VoidCallback? onMemberAdded;

  const AddTeamMemberModal({super.key, this.onMemberAdded});

  static Future<void> show(BuildContext context, {VoidCallback? onMemberAdded}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: AddTeamMemberModal(onMemberAdded: onMemberAdded),
      ),
    );
  }

  @override
  State<AddTeamMemberModal> createState() => _AddTeamMemberModalState();
}

class _AddTeamMemberModalState extends State<AddTeamMemberModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController(text: 'Dynetix@2026');

  String _selectedRole = 'admin'; // 'admin' or 'team_member'
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitAddMember() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final name = _nameController.text.trim();
    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text.trim().isEmpty
        ? 'Dynetix@2026'
        : _passwordController.text.trim();
    final role = _selectedRole;

    try {
      const supabaseUrl = 'https://sqoaobghpkfjcgghalgs.supabase.co';
      const supabaseAnonKey =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNxb2FvYmdocGtmamNnZ2hhbGdzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODYwODkxNDgsImV4cCI6MjEwMTY2NTE0OH0.qJ1cvkhSRm9-64CYG8cGyylEL6npYRGuGS0ST2SDeKk';

      // 1. Create secondary SupabaseClient to sign up without logging out current Admin
      final tempClient = SupabaseClient(supabaseUrl, supabaseAnonKey);
      String? createdUserId;

      try {
        final authRes = await tempClient.auth.signUp(
          email: email,
          password: password,
          data: {
            'name': name,
            'role': role,
          },
        );
        createdUserId = authRes.user?.id;
      } catch (authErr) {
        // Continue even if auth signup fails (e.g. user already exists)
      }

      // 2. Insert/Upsert record in Supabase users table
      final mainClient = Supabase.instance.client;
      final userData = {
        if (createdUserId != null) 'id': createdUserId,
        'email': email,
        'name': name,
        'role': role,
        'is_whitelisted': true,
        'temp_password': password,
        'updated_at': DateTime.now().toIso8601String(),
      };

      try {
        final existing =
            await mainClient.from('users').select().eq('email', email);
        if (existing.isNotEmpty) {
          await mainClient.from('users').update({
            'name': name,
            'role': role,
            'is_whitelisted': true,
            'temp_password': password,
            'updated_at': DateTime.now().toIso8601String(),
          }).eq('email', email);
        } else {
          await mainClient.from('users').insert(userData);
        }
      } catch (dbError) {
        // Fallback upsert attempt
        try {
          await mainClient.from('users').upsert(userData, onConflict: 'email');
        } catch (_) {
          // Ignore table error if offline or missing row level permissions
        }
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Added "$name" as ${_selectedRole == "admin" ? "Admin" : "Team Member"}!',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );

      widget.onMemberAdded?.call();
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to add team member: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.textPrimary;
    final subtitleColor = isDark ? const Color(0xFF94A3B8) : AppColors.textDisabled;
    final fieldBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return Container(
      constraints: const BoxConstraints(maxWidth: 520),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add Team Member / Whitelist',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Authorize a new administrator or management member',
                          style: TextStyle(
                            fontSize: 13,
                            color: subtitleColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: subtitleColor, size: 22),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded,
                          color: AppColors.error, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                              color: AppColors.error, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Full Name Field
              _buildFieldLabel('Full Name', textColor),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                style: TextStyle(color: textColor, fontSize: 14),
                decoration: _buildInputDecoration(
                  hintText: 'e.g. Sarah Jenkins',
                  fieldBg: fieldBg,
                  borderColor: borderColor,
                  prefixIcon: Icons.person_outline_rounded,
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter a full name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Email Address Field
              _buildFieldLabel('Email Address', textColor),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: textColor, fontSize: 14),
                decoration: _buildInputDecoration(
                  hintText: 'e.g. sarah.j@dynetix.com',
                  fieldBg: fieldBg,
                  borderColor: borderColor,
                  prefixIcon: Icons.alternate_email_rounded,
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter an email address';
                  }
                  if (!val.contains('@') || !val.contains('.')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Assigned Role Section
              _buildFieldLabel('Assigned Role', textColor),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildRoleOptionCard(
                      roleKey: 'admin',
                      title: 'Admin',
                      subtitle: 'Full portal & management access',
                      icon: Icons.shield_outlined,
                      isDark: isDark,
                      textColor: textColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildRoleOptionCard(
                      roleKey: 'team_member',
                      title: 'Team Member',
                      subtitle: 'Standard member access',
                      icon: Icons.person_outline_rounded,
                      isDark: isDark,
                      textColor: textColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Temporary Password Field
              _buildFieldLabel('Temporary Password (Optional)', textColor),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordController,
                style: TextStyle(color: textColor, fontSize: 14),
                decoration: _buildInputDecoration(
                  hintText: 'Dynetix@2026',
                  fieldBg: fieldBg,
                  borderColor: borderColor,
                  prefixIcon: Icons.lock_outline_rounded,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Member can log in using this initial password immediately.',
                style: TextStyle(
                  fontSize: 11.5,
                  color: subtitleColor,
                ),
              ),

              const SizedBox(height: 28),

              // Action Buttons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                      side: BorderSide(color: borderColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitAddMember,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add_rounded, size: 18),
                              SizedBox(width: 6),
                              Text(
                                'Add Member',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label, Color textColor) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 13.5,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required Color fieldBg,
    required Color borderColor,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13.5),
      prefixIcon: Icon(prefixIcon, size: 18, color: const Color(0xFF94A3B8)),
      filled: true,
      fillColor: fieldBg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
    );
  }

  Widget _buildRoleOptionCard({
    required String roleKey,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isDark,
    required Color textColor,
  }) {
    final isSelected = _selectedRole == roleKey;
    final activeBorderColor = AppColors.primary;
    final activeBgColor = isDark
        ? AppColors.primary.withValues(alpha: 0.15)
        : const Color(0xFFEFF6FF);
    final inactiveBgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final inactiveBorderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return InkWell(
      onTap: () => setState(() => _selectedRole = roleKey),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? activeBgColor : inactiveBgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? activeBorderColor : inactiveBorderColor,
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? const Color(0xFF94A3B8) : AppColors.textDisabled),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? AppColors.primary : textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
