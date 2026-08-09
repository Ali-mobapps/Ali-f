import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/booking_provider.dart';
import '../models/user_model.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _idController = TextEditingController();
  String? _selectedDepartment;
  UserRole _selectedRole = UserRole.student;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF001945)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Kinetic Grid', style: TextStyle(color: Color(0xFF001945), fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 40, offset: const Offset(0, 10))],
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Registration', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF071E27))),
                  const SizedBox(height: 8),
                  const Text(
                    'Complete your profile to request access to the facility. All fields are required.',
                    style: TextStyle(color: Color(0xFF454652), fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 32),
                  
                  // Progress Indicator
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: const LinearProgressIndicator(
                            value: 0.33,
                            backgroundColor: Color(0xFFCFE6F2),
                            color: Color(0xFF0F6DF3),
                            minHeight: 6,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text('Step 1 of 3', style: TextStyle(color: Color(0xFF0F6DF3), fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Role Toggle
                  Row(
                    children: [
                      Expanded(child: _roleButton('Student', UserRole.student)),
                      const SizedBox(width: 12),
                      Expanded(child: _roleButton('Teacher', UserRole.admin)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  _buildTextField('Full Name', _nameController, 'Enter your name'),
                  const SizedBox(height: 16),
                  _buildTextField(_selectedRole == UserRole.student ? 'University ID' : 'Staff ID', _idController, 'e.g. S1234567'),
                  const SizedBox(height: 16),
                  
                  DropdownButtonFormField<String>(
                    decoration: _inputDecoration('Department'),
                    hint: const Text('Select Department...', style: TextStyle(color: Colors.grey, fontSize: 14)),
                    items: ['Computer Science', 'Engineering', 'Physical Sciences', 'Arts & Humanities']
                        .map((label) => DropdownMenuItem(value: label, child: Text(label, style: const TextStyle(fontSize: 14))))
                        .toList(),
                    onChanged: (newValue) => setState(() => _selectedDepartment = newValue),
                    validator: (val) => val == null ? 'Field required' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField('Email Address', _emailController, 'you@example.com', keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 16),
                  _buildTextField('Password', _passwordController, 'Create a password', obscureText: true),
                  
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _handleRegistration,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A237E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded, size: 20),
                        ],
                      ),
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

  Widget _roleButton(String label, UserRole role) {
    bool isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A237E) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFCFE6F2)),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  void _handleRegistration() async {
    if (_formKey.currentState!.validate() && (_selectedRole == UserRole.admin || _selectedDepartment != null)) {
      final newUser = UserModel(
        id: '', // Will be set by Supabase
        fullName: _nameController.text,
        email: _emailController.text,
        universityId: _idController.text,
        department: _selectedDepartment ?? 'Administration',
        role: _selectedRole,
        isApproved: _selectedRole == UserRole.admin,
      );
      
      try {
        await Provider.of<BookingProvider>(context, listen: false)
            .registerUser(newUser, _passwordController.text);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_selectedRole == UserRole.admin ? 'Teacher account created!' : 'Registration submitted for approval.')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration failed: $e')),
          );
        }
      }
    }
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint, {bool obscureText = false, TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 14),
      decoration: _inputDecoration(label).copyWith(hintText: hint, hintStyle: const TextStyle(color: Colors.grey, fontSize: 13)),
      validator: (value) => value == null || value.isEmpty ? 'Field required' : null,
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 12, color: Color(0xFF1A237E), fontWeight: FontWeight.bold),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCFE6F2))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCFE6F2))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF0F6DF3))),
      filled: true,
      fillColor: const Color(0xFFF3FAFF),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
