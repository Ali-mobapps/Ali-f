import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/dynetix_widgets.dart';
import '../../domain/entities/profile_entity.dart';
import '../bloc/profile_cubit.dart';

class EditProfileScreen extends StatefulWidget {
  final ProfileEntity profile;

  const EditProfileScreen({super.key, required this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  String? _selectedGender;
  String? _profileImageUrl;
  String? _localImagePath;
  bool _isUpdating = false;
  final List<String> _genders = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say'
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _phoneController = TextEditingController(text: widget.profile.phone);
    _selectedGender = widget.profile.gender;
    _profileImageUrl = widget.profile.profileImageUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      setState(() {
        _localImagePath = image.path;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture selected')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('EDIT PROFILE', style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold, fontSize: 14)),
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 2),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.charcoalDepth,
                      backgroundImage: _localImagePath != null
                          ? (kIsWeb ? NetworkImage(_localImagePath!) : NetworkImage(_localImagePath!)) as ImageProvider // Placeholder for web
                          : (_profileImageUrl != null && _profileImageUrl!.isNotEmpty
                              ? NetworkImage(_profileImageUrl!)
                              : const NetworkImage('https://i.pravatar.cc/150?u=user')),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: AppColors.primary,
                      radius: 20,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt_rounded, size: 20, color: Colors.black),
                        onPressed: _pickImage,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            _buildLabel('Display Name'),
            DynetixTextField(
              label: '',
              controller: _nameController,
              hint: 'Master Admin',
              prefixIcon: Icons.person_outline_rounded,
            ),
            const SizedBox(height: 32),
            _buildLabel('Contact Number'),
            DynetixTextField(
              label: '',
              controller: _phoneController,
              hint: '+92 000 0000000',
              prefixIcon: Icons.phone_android_rounded,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 32),
            _buildLabel('Gender Profile'),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedGender,
                  hint: const Text('Identity Specification', style: TextStyle(color: Colors.white30, fontSize: 14)),
                  dropdownColor: AppColors.surface,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary),
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  items: _genders.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedGender = newValue;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 64),
            DynetixButton(
              text: _isUpdating ? 'SYNCHRONIZING...' : 'UPDATE MASTER PROFILE',
              isLoading: _isUpdating,
              onPressed: _isUpdating
                  ? () {}
                  : () async {
                      setState(() => _isUpdating = true);
                      try {
                        final updatedProfile = widget.profile.copyWith(
                          name: _nameController.text.trim(),
                          phone: _phoneController.text.trim(),
                          gender: _selectedGender,
                        );

                        await context.read<ProfileCubit>().updateProfile(
                            updatedProfile,
                            localImagePath: _localImagePath);

                        if (mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Profile configuration synchronized'),
                                backgroundColor: AppColors.success),
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          setState(() => _isUpdating = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Update failed: $e'),
                                backgroundColor: Colors.redAccent),
                          );
                        }
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(text.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2, color: AppColors.textDisabled)),
    );
  }
}
