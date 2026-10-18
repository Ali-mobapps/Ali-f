import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../models/student_model.dart';
import '../../providers/student_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _rollNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _sectionController = TextEditingController(text: 'Section A');
  final _addressController = TextEditingController();
  final _cgpaController = TextEditingController(text: '3.50');

  String _selectedDepartment = AppConstants.departments.first;
  String _selectedSemester = AppConstants.semesters.first;
  String _selectedGender = AppConstants.genders.first;
  String? _photoPath;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _fullNameController.dispose();
    _rollNumberController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _sectionController.dispose();
    _addressController.dispose();
    _cgpaController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() {
        _photoPath = image.path;
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    final studentProvider = Provider.of<StudentProvider>(context, listen: false);

    final nowIso = DateTime.now().toIso8601String();
    final student = StudentModel(
      fullName: _fullNameController.text.trim(),
      rollNumber: _rollNumberController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      department: _selectedDepartment,
      semester: _selectedSemester,
      section: _sectionController.text.trim(),
      gender: _selectedGender,
      address: _addressController.text.trim(),
      cgpa: _cgpaController.text.trim(),
      photoPath: _photoPath,
      createdAt: nowIso,
      updatedAt: nowIso,
    );

    final success = await studentProvider.addStudent(student);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Student record created successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Student'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo Picker
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 46,
                      backgroundColor: AppColors.lightBlueBg,
                      backgroundImage: _photoPath != null
                          ? FileImage(File(_photoPath!))
                          : null,
                      child: _photoPath == null
                          ? const Icon(
                              Icons.person_add_alt_1,
                              size: 40,
                              color: AppColors.primaryLightBlue,
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.primaryNavy,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                          onPressed: _pickImage,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Tap icon to upload student photo',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 24),

              if (studentProvider.errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.error.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.error),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          studentProvider.errorMessage!,
                          style: const TextStyle(color: AppColors.error, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Full Name
              CustomTextField(
                controller: _fullNameController,
                label: 'Full Name *',
                hint: 'e.g., Alex Johnson',
                prefixIcon: Icons.person_outline,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Full Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Roll Number
              CustomTextField(
                controller: _rollNumberController,
                label: 'Roll Number / ID *',
                hint: 'e.g., CS-2025-010',
                prefixIcon: Icons.badge_outlined,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Roll Number is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email & Phone
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _emailController,
                      label: 'Email Address *',
                      hint: 'student@univ.edu',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Email is required';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val.trim())) {
                          return 'Invalid email';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      controller: _phoneController,
                      label: 'Contact Number *',
                      hint: '+1234567890',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Phone number is required';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Department Dropdown
              DropdownButtonFormField<String>(
                value: _selectedDepartment,
                decoration: const InputDecoration(
                  labelText: 'Department *',
                  prefixIcon: Icon(Icons.domain_outlined),
                ),
                items: AppConstants.departments
                    .map((dept) => DropdownMenuItem(
                          value: dept,
                          child: Text(dept),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedDepartment = val);
                },
              ),
              const SizedBox(height: 16),

              // Semester Dropdown
              DropdownButtonFormField<String>(
                value: _selectedSemester,
                decoration: const InputDecoration(
                  labelText: 'Semester *',
                  prefixIcon: Icon(Icons.timeline_outlined),
                ),
                items: AppConstants.semesters
                    .map((sem) => DropdownMenuItem(
                          value: sem,
                          child: Text(sem),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedSemester = val);
                },
              ),
              const SizedBox(height: 16),

              // Section & Gender
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _sectionController.text,
                      decoration: const InputDecoration(
                        labelText: 'Section',
                        prefixIcon: Icon(Icons.class_outlined),
                      ),
                      items: AppConstants.sections
                          .map((sec) => DropdownMenuItem(
                                value: sec,
                                child: Text(sec),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) _sectionController.text = val;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedGender,
                      decoration: const InputDecoration(
                        labelText: 'Gender',
                        prefixIcon: Icon(Icons.people_outline),
                      ),
                      items: AppConstants.genders
                          .map((g) => DropdownMenuItem(
                                value: g,
                                child: Text(g),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedGender = val);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // CGPA
              CustomTextField(
                controller: _cgpaController,
                label: 'CGPA *',
                hint: 'e.g., 3.75',
                prefixIcon: Icons.star_outline,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'CGPA is required';
                  }
                  final parsed = double.tryParse(val.trim());
                  if (parsed == null || parsed < 0.0 || parsed > 4.0) {
                    return 'Enter valid CGPA (0.0 - 4.0)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Address
              CustomTextField(
                controller: _addressController,
                label: 'Address',
                hint: '123 Campus Residence, City',
                prefixIcon: Icons.home_outlined,
                maxLines: 2,
              ),
              const SizedBox(height: 28),

              CustomButton(
                text: 'Save Student Record',
                isLoading: studentProvider.isLoading,
                onPressed: _handleSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
