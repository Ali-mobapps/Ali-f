import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../payments/data/models/payment_method_model.dart';
import '../../data/models/service_item_model.dart';

part 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  AdminCubit() : super(AdminInitial()) {
    loadInitialAdminData();
  }

  List<ServiceItemModel> _services = [];
  List<ServiceItemModel> _academyCourses = [];
  List<PaymentMethodModel> _paymentMethods = [];

  void loadInitialAdminData() {
    emit(AdminLoading());

    // Initial Services Pre-filled Data
    final initialServicesList = [
      '3D Modeling',
      'Legal Drafting and Global Compliance',
      'Full Stack Development with MERN',
      'Cloud Computing',
      'Shopify Development and Dropshipping',
      'Mobile Game and App Development',
      'UI/UX & Webflow',
      'Artificial Intelligence using Python',
      'Startup Strategies and Entrepreneurship',
      'Virtual Assistant',
      'Data Analytics and Business Intelligence',
      'QuickBooks',
      'SEO (Search Engine Optimization)',
      'Graphic Design',
      'Creative Writing',
      'AutoCAD',
      'Digital Literacy',
      'Digital Marketing',
      'E-Commerce Management',
      'Freelancing',
      'Communication and Soft Skills',
      'Video Editing, Animation and Vlogging',
      'Affiliate Marketing',
      'WordPress'
    ];

    _services = List.generate(
      initialServicesList.length,
      (index) => ServiceItemModel(
        id: 'serv_$index',
        title: initialServicesList[index],
        price: 150.0 + (index * 10),
        isAcademyCourse: false,
      ),
    );

    _academyCourses = List.generate(
      initialServicesList.length,
      (index) => ServiceItemModel(
        id: 'acad_$index',
        title: initialServicesList[index],
        price: 99.0 + (index * 15),
        isAcademyCourse: true,
      ),
    );

    _paymentMethods = [
      PaymentMethodModel(
        id: '1',
        name: 'Easypaisa',
        accountNumber: '03451495330',
        logoUrl: 'assets/icons/easypaisa.png',
      ),
      PaymentMethodModel(
        id: '2',
        name: 'JazzCash',
        accountNumber: '03087249533',
        logoUrl: 'assets/icons/jazzcash.png',
      ),
      PaymentMethodModel(
        id: '3',
        name: 'HBL Bank',
        accountNumber: '16277900607203',
        logoUrl: 'assets/icons/hbl.png',
      ),
      PaymentMethodModel(
        id: '4',
        name: 'Nayapay',
        accountNumber: '03156717093',
        logoUrl: 'assets/icons/nayapay.png',
      ),
      PaymentMethodModel(
        id: '5',
        name: 'Sadapay',
        accountNumber: '03156717093',
        logoUrl: 'assets/icons/sadapay.png',
      ),
    ];

    emit(AdminLoaded(
      services: List.from(_services),
      academyCourses: List.from(_academyCourses),
      paymentMethods: List.from(_paymentMethods),
    ));
  }

  // --- CRUD Operations for Services / Courses ---
  void addService(ServiceItemModel item, {bool isAcademy = false}) {
    if (isAcademy) {
      _academyCourses.add(item);
    } else {
      _services.add(item);
    }
    _refreshState();
  }

  void updateService(ServiceItemModel item, {bool isAcademy = false}) {
    if (isAcademy) {
      final idx = _academyCourses.indexWhere((e) => e.id == item.id);
      if (idx != -1) _academyCourses[idx] = item;
    } else {
      final idx = _services.indexWhere((e) => e.id == item.id);
      if (idx != -1) _services[idx] = item;
    }
    _refreshState();
  }

  void deleteService(String id, {bool isAcademy = false}) {
    if (isAcademy) {
      _academyCourses.removeWhere((e) => e.id == id);
    } else {
      _services.removeWhere((e) => e.id == id);
    }
    _refreshState();
  }

  // --- Payment Operations ---
  void addPaymentMethod(PaymentMethodModel method) {
    _paymentMethods.add(method);
    _refreshState();
  }

  void updatePaymentMethod(PaymentMethodModel method) {
    final idx = _paymentMethods.indexWhere((e) => e.id == method.id);
    if (idx != -1) _paymentMethods[idx] = method;
    _refreshState();
  }

  void deletePaymentMethod(String id) {
    _paymentMethods.removeWhere((e) => e.id == id);
    _refreshState();
  }

  void _refreshState() {
    emit(AdminLoaded(
      services: List.from(_services),
      academyCourses: List.from(_academyCourses),
      paymentMethods: List.from(_paymentMethods),
    ));
  }
}
