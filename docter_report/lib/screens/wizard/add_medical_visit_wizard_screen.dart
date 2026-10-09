import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../models/doctor_model.dart';
import '../../models/medical_visit_model.dart';
import '../../models/prescription_model.dart';
import '../../models/report_model.dart';
import '../../models/vital_signs_model.dart';
import '../../providers/medical_provider.dart';

class AddMedicalVisitWizardScreen extends StatefulWidget {
  const AddMedicalVisitWizardScreen({super.key});

  @override
  State<AddMedicalVisitWizardScreen> createState() =>
      _AddMedicalVisitWizardScreenState();
}

class _AddMedicalVisitWizardScreenState
    extends State<AddMedicalVisitWizardScreen> {
  int _currentStep = 1; // 1 to 4

  // Form Controllers & State
  // Step 1: Doctor
  DoctorModel? _selectedDoctor;
  final _doctorNameCtrl = TextEditingController();
  final _doctorSpecialtyCtrl = TextEditingController();
  final _doctorHospitalCtrl = TextEditingController();
  bool _isNewDoctor = false;

  // Step 2: Visit Info
  DateTime _visitDate = DateTime.now();
  TimeOfDay _visitTime = TimeOfDay.now();
  String _consultationType = 'In-Person';
  final _reasonCtrl = TextEditingController();

  // Step 3: Clinical Info
  final List<String> _symptoms = ['Persistent cough', 'Mild fever'];
  final _symptomInputCtrl = TextEditingController();
  final _diagnosisCtrl = TextEditingController();
  final _bpCtrl = TextEditingController(text: '120/80 mmHg');
  final _hrCtrl = TextEditingController(text: '72 bpm');
  final _tempCtrl = TextEditingController(text: '98.6 °F');
  final _weightCtrl = TextEditingController(text: '70 kg');

  // Step 4: Prescriptions & Reports
  final List<PrescriptionModel> _tempPrescriptions = [];
  final _medNameCtrl = TextEditingController();
  final _dosageCtrl = TextEditingController();
  final _freqCtrl = TextEditingController();

  final List<ReportModel> _tempReports = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MedicalProvider>(context, listen: false);
      if (provider.doctors.isNotEmpty) {
        setState(() {
          _selectedDoctor = provider.doctors.first;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MedicalProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Add Medical Visit',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            Text('Step by step record entry',
                style:
                    TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant)),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Stepper Indicator Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Step $_currentStep of 4: ${_getStepTitle()}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      '${(_currentStep / 4 * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.outline,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(4, (index) {
                    final stepNum = index + 1;
                    final isActive = stepNum <= _currentStep;
                    return Expanded(
                      child: Container(
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.primary
                              : AppColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.outlineVariant),

          // Step Content Area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              child: _buildStepContent(provider),
            ),
          ),

          // Navigation Buttons Footer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: AppColors.outlineVariant, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                if (_currentStep > 1) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() => _currentStep--);
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Back'),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentStep < 4) {
                        setState(() => _currentStep++);
                      } else {
                        _saveMedicalVisit();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(_currentStep == 4 ? 'Save Record' : 'Next'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 1:
        return 'Doctor Details';
      case 2:
        return 'Visit Overview';
      case 3:
        return 'Vitals & Diagnosis';
      case 4:
        return 'Prescriptions & Attachments';
      default:
        return '';
    }
  }

  Widget _buildStepContent(MedicalProvider provider) {
    switch (_currentStep) {
      case 1:
        return _buildStep1Doctor(provider);
      case 2:
        return _buildStep2VisitInfo();
      case 3:
        return _buildStep3VitalsAndDiagnosis();
      case 4:
        return _buildStep4RxAndDocs();
      default:
        return const SizedBox();
    }
  }

  // STEP 1
  Widget _buildStep1Doctor(MedicalProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Select Attending Practitioner',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            Row(
              children: [
                ChoiceChip(
                  label: const Text('Existing'),
                  selected: !_isNewDoctor,
                  onSelected: (val) => setState(() => _isNewDoctor = !val),
                  selectedColor: AppColors.primaryContainer,
                  labelStyle: TextStyle(
                    color: !_isNewDoctor ? Colors.white : AppColors.onSurface,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 6),
                ChoiceChip(
                  label: const Text('Add New'),
                  selected: _isNewDoctor,
                  onSelected: (val) => setState(() => _isNewDoctor = val),
                  selectedColor: AppColors.primaryContainer,
                  labelStyle: TextStyle(
                    color: _isNewDoctor ? Colors.white : AppColors.onSurface,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (!_isNewDoctor) ...[
          if (provider.doctors.isEmpty)
            const Text('No existing doctors found. Please select Add New.')
          else
            Column(
              children: provider.doctors.map((doc) {
                final isSelected = _selectedDoctor?.id == doc.id;
                return GestureDetector(
                  onTap: () => setState(() => _selectedDoctor = doc),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryContainer.withValues(alpha: 0.1)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.outlineVariant,
                        width: isSelected ? 1.5 : 0.8,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.surfaceContainer,
                          child: Text(
                            doc.name.substring(0, 2).toUpperCase(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(doc.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14)),
                              Text('${doc.specialty} • ${doc.hospital}',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.onSurfaceVariant)),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle,
                              color: AppColors.primary),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
        ] else ...[
          TextField(
            controller: _doctorNameCtrl,
            decoration: const InputDecoration(
              labelText: 'Doctor Full Name',
              hintText: 'e.g. Dr. Ahmed Khan',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _doctorSpecialtyCtrl,
            decoration: const InputDecoration(
              labelText: 'Specialty / Field',
              hintText: 'e.g. Cardiologist',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _doctorHospitalCtrl,
            decoration: const InputDecoration(
              labelText: 'Hospital / Clinic Name',
              hintText: 'e.g. City Medical Hospital',
            ),
          ),
        ],
      ],
    );
  }

  // STEP 2
  Widget _buildStep2VisitInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Consultation Overview',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface),
        ),
        const SizedBox(height: 16),

        // Date & Time Selectors
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _visitDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() => _visitDate = picked);
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_visitDate.day}/${_visitDate.month}/${_visitDate.year}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      const Icon(Icons.calendar_today,
                          size: 18, color: AppColors.outline),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _visitTime,
                  );
                  if (picked != null) {
                    setState(() => _visitTime = picked);
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _visitTime.format(context),
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      const Icon(Icons.access_time,
                          size: 18, color: AppColors.outline),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Consultation Type
        const Text('Consultation Type',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurfaceVariant)),
        const SizedBox(height: 8),
        Row(
          children: ['In-Person', 'Teleconsultation'].map((type) {
            final isSel = _consultationType == type;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _consultationType = type),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSel ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primary),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    type,
                    style: TextStyle(
                      color: isSel ? Colors.white : AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),

        // Reason for Visit
        TextField(
          controller: _reasonCtrl,
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: 'Primary Reason for Visit / Chief Complaint',
            hintText: 'e.g. Persistent cough, chest congestion, fever',
          ),
        ),
      ],
    );
  }

  // STEP 3
  Widget _buildStep3VitalsAndDiagnosis() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recorded Symptoms',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            ..._symptoms.map((sym) {
              return Chip(
                label: Text(sym),
                onDeleted: () {
                  setState(() => _symptoms.remove(sym));
                },
                backgroundColor: AppColors.surfaceContainerHigh,
                deleteIconColor: AppColors.error,
              );
            }),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _symptomInputCtrl,
                decoration: const InputDecoration(
                  hintText: 'Type symptom and tap add...',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                if (_symptomInputCtrl.text.trim().isNotEmpty) {
                  setState(() {
                    _symptoms.add(_symptomInputCtrl.text.trim());
                    _symptomInputCtrl.clear();
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Add'),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Clinical Diagnosis
        TextField(
          controller: _diagnosisCtrl,
          decoration: const InputDecoration(
            labelText: 'Clinical Diagnosis',
            hintText: 'e.g. Acute Bronchitis / Mild Hypertension',
          ),
        ),
        const SizedBox(height: 20),

        // Vital Signs Grid
        const Text(
          'Vital Signs (Optional)',
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _bpCtrl,
                decoration: const InputDecoration(labelText: 'Blood Pressure'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _hrCtrl,
                decoration: const InputDecoration(labelText: 'Heart Rate'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _tempCtrl,
                decoration: const InputDecoration(labelText: 'Temperature'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _weightCtrl,
                decoration: const InputDecoration(labelText: 'Weight'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // STEP 4
  Widget _buildStep4RxAndDocs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Prescribed Medications',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface),
        ),
        const SizedBox(height: 10),

        // List of added Prescriptions
        if (_tempPrescriptions.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _tempPrescriptions.length,
            itemBuilder: (context, index) {
              final rx = _tempPrescriptions[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.medication_rounded,
                        color: AppColors.tertiary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(rx.medicineName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 14)),
                          Text('${rx.dosage} • ${rx.frequency}',
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.onSurfaceVariant)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: AppColors.error),
                      onPressed: () {
                        setState(() => _tempPrescriptions.removeAt(index));
                      },
                    ),
                  ],
                ),
              );
            },
          ),

        // Add Medicine Form
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surfaceLow,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              TextField(
                controller: _medNameCtrl,
                decoration: const InputDecoration(
                    labelText: 'Medicine Name',
                    hintText: 'e.g. Amoxicillin 500mg'),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _dosageCtrl,
                      decoration: const InputDecoration(
                          labelText: 'Dosage', hintText: '1 Tab'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _freqCtrl,
                      decoration: const InputDecoration(
                          labelText: 'Frequency', hintText: 'Twice daily'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () {
                  if (_medNameCtrl.text.trim().isNotEmpty) {
                    setState(() {
                      _tempPrescriptions.add(
                        PrescriptionModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          visitId: '',
                          medicineName: _medNameCtrl.text.trim(),
                          dosage: _dosageCtrl.text.trim().isEmpty
                              ? '1 Tab'
                              : _dosageCtrl.text.trim(),
                          frequency: _freqCtrl.text.trim().isEmpty
                              ? 'Once daily'
                              : _freqCtrl.text.trim(),
                          duration: '7 Days',
                        ),
                      );
                      _medNameCtrl.clear();
                      _dosageCtrl.clear();
                      _freqCtrl.clear();
                    });
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Medication'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 42),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Attach Documents & Reports
        const Text(
          'Attach Lab Reports & Scans',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface),
        ),
        const SizedBox(height: 10),

        if (_tempReports.isNotEmpty)
          Wrap(
            spacing: 8,
            children: _tempReports.map((rep) {
              return Chip(
                avatar: const Icon(Icons.picture_as_pdf, color: Colors.red),
                label: Text(rep.title),
                onDeleted: () => setState(() => _tempReports.remove(rep)),
              );
            }).toList(),
          ),

        OutlinedButton.icon(
          onPressed: () async {
            final result = await FilePicker.platform.pickFiles();
            if (result != null && result.files.isNotEmpty) {
              final file = result.files.first;
              setState(() {
                _tempReports.add(
                  ReportModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: file.name,
                    category: 'Lab Report',
                    filePath: file.path ?? file.name,
                    fileType: file.extension ?? 'pdf',
                    fileSize: '${(file.size / (1024 * 1024)).toStringAsFixed(1)} MB',
                    dateAdded: DateTime.now(),
                  ),
                );
              });
            }
          },
          icon: const Icon(Icons.upload_file),
          label: const Text('Upload Document (PDF / Image)'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 46),
          ),
        ),
      ],
    );
  }

  void _saveMedicalVisit() async {
    final provider = Provider.of<MedicalProvider>(context, listen: false);

    String docId = _selectedDoctor?.id ?? 'doc_${DateTime.now().millisecondsSinceEpoch}';
    String docName = _isNewDoctor ? _doctorNameCtrl.text.trim() : (_selectedDoctor?.name ?? 'Dr. Unknown');
    String docSpec = _isNewDoctor ? _doctorSpecialtyCtrl.text.trim() : (_selectedDoctor?.specialty ?? 'General');
    String docHosp = _isNewDoctor ? _doctorHospitalCtrl.text.trim() : (_selectedDoctor?.hospital ?? 'Clinic');

    if (docName.isEmpty) docName = 'Dr. Attending Physician';

    final visitId = 'visit_${DateTime.now().millisecondsSinceEpoch}';

    final visit = MedicalVisitModel(
      id: visitId,
      doctorId: docId,
      doctorName: docName,
      doctorSpecialty: docSpec,
      doctorHospital: docHosp,
      visitDate: _visitDate,
      timeStr: _visitTime.format(context),
      consultationType: _consultationType,
      reason: _reasonCtrl.text.trim().isEmpty
          ? 'Routine Health Checkup'
          : _reasonCtrl.text.trim(),
      symptoms: _symptoms,
      diagnosis: _diagnosisCtrl.text.trim().isEmpty
          ? 'Clinical Examination Completed'
          : _diagnosisCtrl.text.trim(),
      vitals: VitalSignsModel(
        bloodPressure: _bpCtrl.text,
        heartRate: _hrCtrl.text,
        temperature: _tempCtrl.text,
        weight: _weightCtrl.text,
      ),
      prescriptions: _tempPrescriptions.map((p) => PrescriptionModel(
        id: p.id,
        visitId: visitId,
        medicineName: p.medicineName,
        dosage: p.dosage,
        frequency: p.frequency,
        duration: p.duration,
      )).toList(),
      reports: _tempReports,
      followUpDate: DateTime.now().add(const Duration(days: 14)),
    );

    await provider.addMedicalVisit(visit);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Medical Visit Record Saved Successfully!')),
      );
      Navigator.pop(context);
    }
  }
}
