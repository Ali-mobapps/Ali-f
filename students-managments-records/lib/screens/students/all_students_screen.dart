import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/student_provider.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/student_card.dart';
import 'add_student_screen.dart';
import 'edit_student_screen.dart';
import 'search_filter_screen.dart';
import 'student_details_screen.dart';

class AllStudentsScreen extends StatefulWidget {
  const AllStudentsScreen({super.key});

  @override
  State<AllStudentsScreen> createState() => _AllStudentsScreenState();
}

class _AllStudentsScreenState extends State<AllStudentsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<StudentProvider>(context, listen: false);
      _searchController.text = provider.searchQuery;
      provider.loadStudents();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);
    final students = studentProvider.students;

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Student Records'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter & Sort',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SearchFilterScreen()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddStudentScreen()),
          );
        },
        icon: const Icon(Icons.person_add),
        label: const Text('Add Student'),
      ),
      body: Column(
        children: [
          // Search & Active Filter bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).cardTheme.color,
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by name, roll no, email...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              studentProvider.setSearchQuery('');
                            },
                          )
                        : null,
                  ),
                  onChanged: (val) {
                    studentProvider.setSearchQuery(val);
                  },
                ),
                if (studentProvider.selectedDepartment != 'All' ||
                    studentProvider.selectedSemester != 'All') ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text(
                        'Active Filters: ',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      if (studentProvider.selectedDepartment != 'All')
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Chip(
                            label: Text(
                              studentProvider.selectedDepartment,
                              style: const TextStyle(fontSize: 11),
                            ),
                            onDeleted: () => studentProvider.setDepartmentFilter('All'),
                          ),
                        ),
                      if (studentProvider.selectedSemester != 'All')
                        Chip(
                          label: Text(
                            studentProvider.selectedSemester,
                            style: const TextStyle(fontSize: 11),
                          ),
                          onDeleted: () => studentProvider.setSemesterFilter('All'),
                        ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => studentProvider.resetFilters(),
                        child: const Text('Reset All', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          Expanded(
            child: studentProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : students.isEmpty
                    ? EmptyStateWidget(
                        icon: Icons.search_off_rounded,
                        title: 'No Students Found',
                        description: studentProvider.searchQuery.isNotEmpty ||
                                studentProvider.selectedDepartment != 'All'
                            ? 'No records match your search or filter criteria.'
                            : 'Start by adding a student record to the database.',
                        actionText: 'Add New Student',
                        onAction: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const AddStudentScreen()),
                          );
                        },
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          await studentProvider.loadStudents();
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: students.length,
                          itemBuilder: (context, index) {
                            final student = students[index];
                            return StudentCard(
                              student: student,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => StudentDetailsScreen(studentId: student.id!),
                                  ),
                                );
                              },
                              onEdit: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => EditStudentScreen(student: student),
                                  ),
                                );
                              },
                              onDelete: () async {
                                final confirm = await ConfirmDialog.show(
                                  context: context,
                                  title: 'Delete Student',
                                  message: 'Are you sure you want to delete ${student.fullName}?',
                                );
                                if (confirm && mounted) {
                                  await studentProvider.deleteStudent(student.id!);
                                }
                              },
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
