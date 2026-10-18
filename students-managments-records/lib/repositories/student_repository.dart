import '../database/database_helper.dart';
import '../models/student_model.dart';

class StudentRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> addStudent(StudentModel student) async {
    final isTaken = await _dbHelper.isRollNumberTaken(student.rollNumber);
    if (isTaken) {
      throw Exception('Roll Number "${student.rollNumber}" is already assigned to another student.');
    }
    return await _dbHelper.insertStudent(student);
  }

  Future<int> updateStudent(StudentModel student) async {
    if (student.id == null) throw Exception('Student ID is missing.');
    
    final isTaken = await _dbHelper.isRollNumberTaken(
      student.rollNumber,
      excludeId: student.id,
    );
    if (isTaken) {
      throw Exception('Roll Number "${student.rollNumber}" is already in use.');
    }

    return await _dbHelper.updateStudent(student);
  }

  Future<int> deleteStudent(int id) async {
    return await _dbHelper.deleteStudent(id);
  }

  Future<List<StudentModel>> getStudents({
    String? searchQuery,
    String? department,
    String? semester,
    String sortBy = 'name',
    bool ascending = true,
  }) async {
    return await _dbHelper.getAllStudents(
      searchQuery: searchQuery,
      department: department,
      semester: semester,
      sortBy: sortBy,
      ascending: ascending,
    );
  }

  Future<StudentModel?> getStudentById(int id) async {
    return await _dbHelper.getStudentById(id);
  }

  /// Parallelized queries for instant dashboard loads
  Future<Map<String, dynamic>> getDashboardStats() async {
    final results = await Future.wait([
      _dbHelper.getStudentsCount(),
      _dbHelper.getDepartmentCounts(),
      _dbHelper.getSemesterCounts(),
      _dbHelper.getRecentStudents(limit: 5),
    ]);

    return {
      'total': results[0] as int,
      'departments': results[1] as Map<String, int>,
      'semesters': results[2] as Map<String, int>,
      'recent': results[3] as List<StudentModel>,
    };
  }
}
