import 'package:dynetix_app/features/inquiries/domain/entities/inquiry_entity.dart';
import 'package:dynetix_app/features/inquiries/presentation/bloc/inquiries_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServicesScreen extends StatelessWidget {
  final bool isAdmin;
  final String userEmail;

  const ServicesScreen({
    super.key,
    required this.isAdmin,
    this.userEmail = 'customer@dynetix.com',
  });

  // Aap ki di gayi mukammal 24+ Services aur Courses ki list
  final List<Map<String, String>> _items = const [
    {'title': '3D Modeling', 'category': 'Service', 'price': '\$250'},
    {
      'title': 'Legal Drafting and Global Compliance',
      'category': 'Service',
      'price': '\$300'
    },
    {
      'title': 'Full Stack Development with MERN',
      'category': 'Course',
      'price': '\$600'
    },
    {'title': 'Cloud Computing', 'category': 'Course', 'price': '\$450'},
    {
      'title': 'Shopify Development and Dropshipping',
      'category': 'Service',
      'price': '\$350'
    },
    {
      'title': 'Mobile Game and App Development',
      'category': 'Service',
      'price': '\$700'
    },
    {'title': 'UI/UX & Webflow', 'category': 'Service', 'price': '\$200'},
    {
      'title': 'Artificial Intelligence using Python',
      'category': 'Course',
      'price': '\$550'
    },
    {
      'title': 'Startup Strategies and Entrepreneurship',
      'category': 'Course',
      'price': '\$300'
    },
    {'title': 'Virtual Assistant', 'category': 'Service', 'price': '\$150'},
    {
      'title': 'Data Analytics and Business Intelligence',
      'category': 'Course',
      'price': '\$500'
    },
    {'title': 'QuickBooks', 'category': 'Service', 'price': '\$180'},
    {
      'title': 'SEO (Search Engine Optimization)',
      'category': 'Service',
      'price': '\$220'
    },
    {'title': 'Graphic Design', 'category': 'Service', 'price': '\$180'},
    {'title': 'Creative Writing', 'category': 'Service', 'price': '\$120'},
    {'title': 'AutoCAD', 'category': 'Course', 'price': '\$280'},
    {'title': 'Digital Literacy', 'category': 'Course', 'price': '\$100'},
    {'title': 'Digital Marketing', 'category': 'Service', 'price': '\$250'},
    {'title': 'E-Commerce Management', 'category': 'Service', 'price': '\$300'},
    {'title': 'Freelancing', 'category': 'Course', 'price': '\$150'},
    {
      'title': 'Communication and Soft Skills',
      'category': 'Course',
      'price': '\$130'
    },
    {
      'title': 'Video Editing, Animation and Vlogging',
      'category': 'Service',
      'price': '\$260'
    },
    {'title': 'Affiliate Marketing', 'category': 'Service', 'price': '\$200'},
    {'title': 'WordPress', 'category': 'Service', 'price': '\$220'},
  ];

  void _showInquiryDialog(BuildContext context, String serviceName) {
    final TextEditingController messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Inquire about $serviceName'),
        content: TextField(
          controller: messageController,
          decoration: const InputDecoration(
            hintText: 'Enter your message or what you want...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final text = messageController.text.trim();
              if (text.isNotEmpty) {
                final newInquiry = InquiryEntity(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  customerEmail: userEmail,
                  message: 'Service/Course: $serviceName\nDetails: $text',
                  timestamp: DateTime.now(),
                );

                context.read<InquiriesCubit>().sendInquiry(
                      newInquiry,
                      userEmail,
                      isAdmin,
                    );

                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Inquiry sent to Admin successfully!')),
                );
              }
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services & Academy Courses'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text(
                item['title']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle:
                  Text('Type: ${item['category']} | Price: ${item['price']}'),
              trailing: isAdmin
                  ? const Icon(Icons.admin_panel_settings, color: Colors.indigo)
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () =>
                          _showInquiryDialog(context, item['title']!),
                      child: const Text('Inquire'),
                    ),
            ),
          );
        },
      ),
    );
  }
}
