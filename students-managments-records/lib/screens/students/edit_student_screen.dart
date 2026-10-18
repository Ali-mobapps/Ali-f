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

class EditStudentScreen extends StatefulWidget {
  final StudentModel student;

  const EditStudentScreen({super.key, required this.student});

  @override
  State<EditStudentScreen> createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _fullNameController;
  late TextEditingController _rollNumberController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _sectionController;
  late TextEditingController _addressController;
  late TextEditingController _cgpaController;

  late String _selectedDepartment;
  late String _selectedSemester;
  late String _selectedGender;
  String? _photoPath;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.student.fullName);
    _rollNumberController = TextEditingController(text: widget.student.rollNumber);
    _emailController = TextEditingController(text: widget.student.email);
    _phoneController = TextEditingController(text: widget.student.phone);
    _sectionController = TextEditingController(text: widget.student.section);
    _addressController = TextEditingController(text: widget.student.address);
    _cgpaController = TextEditingController(text: widget.student.cgpa);

    _selectedDepartment = AppConstants.departments.contains(widget.student.department)
        ? widget.student.department
        : AppConstants.departments.first;

    _selectedSemester = AppConstants.semesters.contains(widget.student.semester)
        ? widget.student.semester
        : AppConstants.semesters.first;

    _selectedGender = AppConstants.genders.contains(widget.student.gender)
        ? widget.student.gender
        : AppConstants.genders.first;

    _photoPath = widget.student.photoPath;
  }

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

    final updatedStudent = widget.student.copyWith(
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
      updatedAt: DateTime.now().toIso8601String(),
    );

    final success = await studentProvider.updateStudent(updatedStudent);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Student record updated successfully!'),
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
        title: const Text('Edit Student Record'),
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
                      backgroundImage: _photoPath != null && File(_photoPath!).existsSync()
                          ? FileImage(File(_photoPath!))
                          : null,
                      child: _photoPath == null || !File(_photoPath!).existsSync()
                          ? Text(
                              widget.student.initials,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryNavy,
                              ),
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

              CustomTextField(
                controller: _fullNameController,
                label: 'Full Name *',
                prefixIcon: Icons.person_outline,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Full Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _rollNumberController,
                label: 'Roll Number / ID *',
                prefixIcon: Icons.badge_outlined,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Roll Number is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _emailController,
                      label: 'Email Address *',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Email is required';
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

              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: AppConstants.sections.contains(_sectionController.text)
                          ? _sectionController.text
                          : AppConstants.sections.first,
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

              CustomTextField(
                controller: _addressController,
                label: 'Address',
                prefixIcon: Icons.home_outlined,
                maxLines: 2,
              ),
              const SizedBox(height: 28),

              CustomButton(
                text: 'Update Student Record',
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
