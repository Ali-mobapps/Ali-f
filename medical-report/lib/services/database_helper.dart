import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';
import '../models/doctor_model.dart';
import '../models/visit_model.dart';
import '../models/medicine_model.dart';
import '../models/lab_test_model.dart';
import '../models/report_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static bool _isWebOrFallback = false;

  // In-Memory Fallback Store (for Web / Desktop without FFI)
  final List<DoctorModel> _inMemoryDoctors = [
    DoctorModel(
      id: 'd1',
      name: 'Dr. Ahmed Khan',
      specialty: 'Consultant Cardiologist',
      phone: '+92 300 8472910',
      whatsapp: '923008472910',
      qualifications: 'FCPS • MRCP',
      hospitalName: 'City Medical Hospital',
      hospitalAddress: 'Jail Road, Lahore, Pakistan',
      photoUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDyjodeL5OdVcyt4MGyz1IFvEW7pZ64nd3caLa9v8FwM6QdY0bwALfC7DNctQ4pZ-TkkY1C_D7Y6ZIVZsVoJOhCNa_CLxJ5cRBI-eewDRTGz1gucYuAWCr7T5aWziVGJypf-lxtUkkfJS6vMsCvx8bNkESVLdhQPDuopYGl85hGK1qIq3ur4O78S34DWGvCAF5m8mq9TAmqchNW9Dvw98_PJM2wh0m_0-QIRjjI_O3F',
      pmdcNo: '12894-P',
    ),
    DoctorModel(
      id: 'd2',
      name: 'Dr. Sara Malik',
      specialty: 'Pulmonology',
      phone: '+92 321 4452109',
      whatsapp: '923214452109',
      qualifications: 'MBBS, FCPS (Pulmonology)',
      hospitalName: 'National Diagnostic Clinic',
      hospitalAddress: 'Gulberg III, Lahore, Pakistan',
      photoUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDLjpCvyxz6VRp8fp6k8wRB3kyWsGqTH30i9fP8EQaDThCFNOZ8qUvUszGHWPh-zuFHMo_RGO-69AH_8wvTI8H-PQqAq4BmjHKJNJFNfm6GXi6igLvnSRqiu1WCVT3WFtiVIGdfPW2n7NMajnDUZbtLJQfMPaAC03MdNzQkPsuyAiM-lpB6Ig1pFtcJBB8LL0Q-0kU28v2kmhH0sibSQEwbWNe77CS27U1zcWWg9gka',
      pmdcNo: '84920-P',
    ),
    DoctorModel(
      id: 'd3',
      name: 'Dr. Usman Tariq',
      specialty: 'General Medicine',
      phone: '+92 333 9812304',
      whatsapp: '923339812304',
      qualifications: 'MBBS, MCPS',
      hospitalName: 'Doctor Hospital',
      hospitalAddress: 'Johar Town, Lahore, Pakistan',
      photoUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCF43xSpE4t8_ejYNyVGbQTVuQc3kqK_GIrvN7sN9296T-8b8Aks9Filg_kDcB5qvV5M4-8ABexOWPhTwssJg7PZPuzY6ZmTFzRxX3EzFSdVFT3cpNosjY-Tg4qq2o8AApkgvjwWinbPz9MlGoLV0bdFlmM7wssWqGPKms5mP5sqlOjZuEr7XTkdfZ2c3fbGIVCjFZB_u-iwUHQLE8mDSCnUQJvPwxnnQLAoVa2RWA9',
      pmdcNo: '55102-P',
    ),
  ];

  final List<MedicalVisitModel> _inMemoryVisits = [
    MedicalVisitModel(
      id: 'v1',
      doctorId: 'd1',
      doctorName: 'Dr. Ahmed Khan',
      specialty: 'Consultant Cardiologist',
      hospitalName: 'City Medical Hospital',
      visitDate: '06 Oct 2026',
      symptoms: 'High Fever, Cough & Body Pain',
      diagnosis: 'Viral Infection',
      doctorNotes: 'Rest for 3 days, drink warm fluids. Take prescribed medications.',
      followUpDate: '24 Oct 2026',
      prescriptionPdfPath: 'Rx_AhmedKhan_Oct2026.pdf',
      syncStatus: 'Completed',
      medicines: [
        MedicineModel(
          id: 'm1',
          visitId: 'v1',
          name: 'Panadol',
          genericName: 'Paracetamol',
          dosage: '500 mg',
          frequency: '2x / day',
          duration: '5 Days',
          mealInstruction: 'After Meal',
          timingNotes: 'Morning • Night',
          warningNotes: 'Take with full glass of water after food.',
        ),
        MedicineModel(
          id: 'm2',
          visitId: 'v1',
          name: 'Hydryllin Syrup',
          genericName: 'Cough Relief',
          dosage: '2 tsp (10ml)',
          frequency: '3x / day',
          duration: '7 Days',
          mealInstruction: 'Before Bed / After Meal',
          timingNotes: 'Morning • Afternoon • Night',
          warningNotes: 'Causes Drowsiness. Avoid driving.',
        ),
      ],
      labTests: [
        LabTestModel(
          id: 'lt1',
          visitId: 'v1',
          testName: 'CBC (Complete Blood Count)',
          labName: 'National Diagnostics',
          testDate: '06 Oct 2026',
          resultStatus: 'Normal',
          summary: 'Hemoglobin 14.2 g/dL, WBC Count 6.8',
        ),
        LabTestModel(
          id: 'lt2',
          visitId: 'v1',
          testName: 'CRP (C-Reactive Protein)',
          labName: 'National Diagnostics',
          testDate: '06 Oct 2026',
          resultStatus: 'Pending',
          summary: 'Specimen Received #CR-9482',
        ),
      ],
    ),
    MedicalVisitModel(
      id: 'v2',
      doctorId: 'd2',
      doctorName: 'Dr. Sara Malik',
      specialty: 'Pulmonology',
      hospitalName: 'National Diagnostic Clinic',
      visitDate: '15 Sep 2026',
      symptoms: 'Seasonal Allergy & Sneezing',
      diagnosis: 'Seasonal Allergy',
      doctorNotes: 'Avoid dust exposure. Take antihistamines in the evening.',
      followUpDate: null,
      prescriptionPdfPath: 'Rx_SaraMalik_Sep2026.pdf',
      syncStatus: 'Archived',
    ),
  ];

  final List<MedicalReportModel> _inMemoryReports = [
    MedicalReportModel(
      id: 'r1',
      title: 'Complete Blood Count (CBC) with Differential',
      category: 'blood',
      doctorName: 'Dr. Ahmed Khan',
      hospitalName: 'City Medical Hospital',
      reportDate: '06 Oct 2026',
      statusBadge: 'Normal',
      summaryMetrics: 'Hemoglobin 14.2 g/dL • WBC 6.8 10³/µL',
      fileType: 'PDF',
      drivePath: '/Visits/2026-10-06/CBC_AhmedKhan.pdf',
      fileSizeMb: 1.4,
    ),
    MedicalReportModel(
      id: 'r2',
      title: 'Chest X-Ray PA View (Digital Radiography)',
      category: 'xray',
      doctorName: 'Dr. Sara Malik',
      hospitalName: 'National Diagnostic Clinic',
      reportDate: '15 Sep 2026',
      statusBadge: 'Clear',
      summaryMetrics: 'Bilateral lung zones clear. Cardio-thoracic ratio normal.',
      fileType: 'DICOM',
      drivePath: '/Visits/2026-09-15/Radiology_PA_Chest.dcm',
      fileSizeMb: 4.8,
    ),
    MedicalReportModel(
      id: 'r3',
      title: 'Quantitative C-Reactive Protein (CRP)',
      category: 'blood',
      doctorName: 'Dr. Ahmed Khan',
      hospitalName: 'National Diagnostics',
      reportDate: '06 Oct 2026',
      statusBadge: 'Pending',
      summaryMetrics: 'Specimen received in automated centrifuge analyzer',
      fileType: 'PDF',
      drivePath: '/Visits/2026-10-06/CRP_Analysis.pdf',
      fileSizeMb: 0.85,
    ),
    MedicalReportModel(
      id: 'r4',
      title: 'Abdominal Ultrasound (Full Pelvic Scan)',
      category: 'ultrasound',
      doctorName: 'Dr. Tariq Mahmood',
      hospitalName: 'Shaukat Khanum Diagnostic',
      reportDate: '12 Jul 2026',
      statusBadge: 'Normal',
      summaryMetrics: 'Liver size normal (13.4 cm). Gallbladder normal without calculi.',
      fileType: 'PDF',
      drivePath: '/Visits/2026-07-12/USG_Pelvic_TariqM.pdf',
      fileSizeMb: 6.2,
    ),
  ];

  UserModel _inMemoryUser = UserModel(
    id: 'u1',
    email: 'ali.reza.health@gmail.com',
    displayName: 'Ali Reza',
    photoUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCoRvpmf7yEz1ANIHrdQnAikBEa_4tZ2B_wtZAYSSehkLN4ZKuGVh-yT5c57kaCHL9Ql3hQuWev72YqdWFIndRCtTFlh2im6jl36JKOEqg9NUT_gL3WZVLAeUwjY5t49O17wgHG5mUx3evzgTF-d-znYsDFZzKCy3DhTjPgJEv9MPYoKhyoJ9ccMADFENzGqrqqHKBfYdcVdcNGZ0GbLha4rFWH2_FE3iUH7RykkejP',
    lastSyncTime: 'Today at 10:32 AM',
    isDriveConnected: true,
  );

  DatabaseHelper._init();

  Future<Database?> get database async {
    if (_isWebOrFallback) return null;
    if (_database != null) return _database!;

    if (kIsWeb) {
      _isWebOrFallback = true;
      return null;
    }

    try {
      _database = await _initDB('medical_history_v2.db');
      return _database!;
    } catch (e) {
      _isWebOrFallback = true;
      return null;
    }
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        email TEXT NOT NULL,
        displayName TEXT NOT NULL,
        photoUrl TEXT,
        lastSyncTime TEXT,
        isDriveConnected INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE doctors (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        specialty TEXT NOT NULL,
        phone TEXT NOT NULL,
        whatsapp TEXT,
        qualifications TEXT NOT NULL,
        hospitalName TEXT NOT NULL,
        hospitalAddress TEXT NOT NULL,
        photoUrl TEXT,
        pmdcNo TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE visits (
        id TEXT PRIMARY KEY,
        doctorId TEXT NOT NULL,
        doctorName TEXT NOT NULL,
        specialty TEXT NOT NULL,
        hospitalName TEXT NOT NULL,
        visitDate TEXT NOT NULL,
        symptoms TEXT NOT NULL,
        diagnosis TEXT NOT NULL,
        doctorNotes TEXT,
        followUpDate TEXT,
        prescriptionPdfPath TEXT,
        syncStatus TEXT NOT NULL DEFAULT 'Synced'
      )
    ''');

    await db.execute('''
      CREATE TABLE medicines (
        id TEXT PRIMARY KEY,
        visitId TEXT NOT NULL,
        name TEXT NOT NULL,
        genericName TEXT,
        dosage TEXT NOT NULL,
        frequency TEXT NOT NULL,
        duration TEXT NOT NULL,
        mealInstruction TEXT NOT NULL,
        timingNotes TEXT,
        warningNotes TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE lab_tests (
        id TEXT PRIMARY KEY,
        visitId TEXT NOT NULL,
        testName TEXT NOT NULL,
        labName TEXT NOT NULL,
        testDate TEXT NOT NULL,
        resultStatus TEXT NOT NULL,
        summary TEXT,
        fileUrl TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE reports (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        category TEXT NOT NULL,
        doctorName TEXT NOT NULL,
        hospitalName TEXT NOT NULL,
        reportDate TEXT NOT NULL,
        statusBadge TEXT NOT NULL,
        summaryMetrics TEXT NOT NULL,
        filePath TEXT,
        fileType TEXT NOT NULL,
        drivePath TEXT NOT NULL,
        fileSizeMb REAL NOT NULL
      )
    ''');

    await _seedInitialData(db);
  }

  Future<void> _seedInitialData(Database db) async {
    await db.insert('users', _inMemoryUser.toMap());
    for (var d in _inMemoryDoctors) {
      await db.insert('doctors', d.toMap());
    }
    for (var v in _inMemoryVisits) {
      await db.insert('visits', v.toMap());
      for (var m in v.medicines) {
        await db.insert('medicines', m.toMap());
      }
      for (var t in v.labTests) {
        await db.insert('lab_tests', t.toMap());
      }
    }
    for (var r in _inMemoryReports) {
      await db.insert('reports', r.toMap());
    }
  }

  // --- Doctor Queries ---
  Future<List<DoctorModel>> getDoctors() async {
    final db = await database;
    if (db == null) return List.from(_inMemoryDoctors);

    try {
      final result = await db.query('doctors');
      if (result.isEmpty) return List.from(_inMemoryDoctors);
      return result.map((json) => DoctorModel.fromMap(json)).toList();
    } catch (_) {
      return List.from(_inMemoryDoctors);
    }
  }

  Future<DoctorModel?> getDoctorById(String id) async {
    final doctors = await getDoctors();
    try {
      return doctors.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> insertDoctor(DoctorModel doctor) async {
    _inMemoryDoctors.removeWhere((d) => d.id == doctor.id);
    _inMemoryDoctors.add(doctor);

    final db = await database;
    if (db != null) {
      try {
        await db.insert('doctors', doctor.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      } catch (_) {}
    }
  }

  // --- Visit Queries ---
  Future<List<MedicalVisitModel>> getVisits() async {
    final db = await database;
    if (db == null) return List.from(_inMemoryVisits);

    try {
      final visitMaps = await db.query('visits', orderBy: 'id DESC');
      if (visitMaps.isEmpty) return List.from(_inMemoryVisits);

      List<MedicalVisitModel> visits = [];
      for (var visitMap in visitMaps) {
        final visitId = visitMap['id'] as String;
        final medMaps = await db.query('medicines', where: 'visitId = ?', whereArgs: [visitId]);
        final medicines = medMaps.map((m) => MedicineModel.fromMap(m)).toList();
        final testMaps = await db.query('lab_tests', where: 'visitId = ?', whereArgs: [visitId]);
        final tests = testMaps.map((t) => LabTestModel.fromMap(t)).toList();

        visits.add(MedicalVisitModel.fromMap(visitMap, medicines: medicines, labTests: tests));
      }
      return visits;
    } catch (_) {
      return List.from(_inMemoryVisits);
    }
  }

  Future<List<MedicalVisitModel>> getVisitsForDoctor(String doctorId) async {
    final allVisits = await getVisits();
    return allVisits.where((v) => v.doctorId == doctorId).toList();
  }

  Future<void> insertVisit(MedicalVisitModel visit) async {
    _inMemoryVisits.removeWhere((v) => v.id == visit.id);
    _inMemoryVisits.insert(0, visit);

    final db = await database;
    if (db != null) {
      try {
        await db.insert('visits', visit.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
        for (var med in visit.medicines) {
          await db.insert('medicines', med.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
        }
        for (var test in visit.labTests) {
          await db.insert('lab_tests', test.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
        }
      } catch (_) {}
    }
  }

  // --- Report Queries ---
  Future<List<MedicalReportModel>> getReports() async {
    final db = await database;
    if (db == null) return List.from(_inMemoryReports);

    try {
      final result = await db.query('reports', orderBy: 'id DESC');
      if (result.isEmpty) return List.from(_inMemoryReports);
      return result.map((json) => MedicalReportModel.fromMap(json)).toList();
    } catch (_) {
      return List.from(_inMemoryReports);
    }
  }

  Future<void> insertReport(MedicalReportModel report) async {
    _inMemoryReports.removeWhere((r) => r.id == report.id);
    _inMemoryReports.insert(0, report);

    final db = await database;
    if (db != null) {
      try {
        await db.insert('reports', report.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      } catch (_) {}
    }
  }

  // --- User / Auth Queries ---
  Future<UserModel?> getUser() async {
    final db = await database;
    if (db == null) return _inMemoryUser;

    try {
      final result = await db.query('users');
      if (result.isNotEmpty) {
        return UserModel.fromMap(result.first);
      }
      return _inMemoryUser;
    } catch (_) {
      return _inMemoryUser;
    }
  }

  Future<void> saveUser(UserModel user) async {
    _inMemoryUser = user;
    final db = await database;
    if (db != null) {
      try {
        await db.insert('users', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      } catch (_) {}
    }
  }
}
