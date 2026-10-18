import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utilities/date_formatter.dart';
import '../../models/student_model.dart';
import '../../providers/student_provider.dart';
import '../../widgets/confirm_dialog.dart';
import 'edit_student_screen.dart';

class StudentDetailsScreen extends StatelessWidget {
  final int studentId;

  const StudentDetailsScreen({super.key, required this.studentId});

  Widget _buildDetailRow(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: AppColors.primaryLightBlue),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value.isNotEmpty ? value : 'N/A',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);

    // Find student in provider list
    final student = studentProvider.students.firstWhere(
      (s) => s.id == studentId,
      orElse: () => StudentModel(
        id: studentId,
        fullName: 'Unknown',
        rollNumber: 'N/A',
        email: '',
        phone: '',
        department: '',
        semester: '',
        section: '',
        gender: '',
        address: '',
        cgpa: 'N/A',
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      ),
    );

    final createdDate = DateFormatter.parseDate(student.createdAt);
    final formattedCreated = createdDate != null ? DateFormatter.formatDate(createdDate) : 'N/A';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Record',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => EditStudentScreen(student: student),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: AppColors.error),
            tooltip: 'Delete Student',
            onPressed: () async {
              final confirm = await ConfirmDialog.show(
                context: context,
                title: 'Delete Student Record',
                message: 'Are you sure you want to permanently delete ${student.fullName}?',
              );
              if (confirm && context.mounted) {
                await studentProvider.deleteStudent(student.id!);
                if (context.mounted) Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Student Header Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.primaryLightBlue,
                      backgroundImage: student.photoPath != null &&
                              File(student.photoPath!).existsSync()
                          ? FileImage(File(student.photoPath!))
                          : null,
                      child: student.photoPath == null ||
                              !File(student.photoPath!).existsSync()
                          ? Text(
                              student.initials,
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      student.fullName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.lightBlueBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Roll No: ${student.rollNumber}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryNavy,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Academic Info Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Academic Profile',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryNavy,
                      ),
                    ),
                    const Divider(height: 20),
                    _buildDetailRow(context, Icons.domain, 'Department', student.department),
                    _buildDetailRow(context, Icons.timeline, 'Semester', student.semester),
                    _buildDetailRow(context, Icons.class_, 'Class / Section', student.section),
                    _buildDetailRow(context, Icons.star, 'CGPA', student.cgpa),
                    _buildDetailRow(context, Icons.calendar_month, 'Enrollment Date', formattedCreated),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Contact Info Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Contact & Personal Info',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryNavy,
                      ),
                    ),
                    const Divider(height: 20),
                    _buildDetailRow(context, Icons.email, 'Email Address', student.email),
                    _buildDetailRow(context, Icons.phone, 'Contact Number', student.phone),
                    _buildDetailRow(context, Icons.people, 'Gender', student.gender),
                    _buildDetailRow(context, Icons.home, 'Address', student.address),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
