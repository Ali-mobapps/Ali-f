import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  // Aap ki di gayi 24+ Services aur Courses ki list
  final List<Map<String, dynamic>> _servicesAndCourses = [
    {'title': '3D Modeling', 'price': '\$250', 'category': 'Service'},
    {
      'title': 'Legal Drafting and Global Compliance',
      'price': '\$300',
      'category': 'Service'
    },
    {
      'title': 'Full Stack Development with MERN',
      'price': '\$600',
      'category': 'Course'
    },
    {'title': 'Cloud Computing', 'price': '\$450', 'category': 'Course'},
    {
      'title': 'Shopify Development and Dropshipping',
      'price': '\$350',
      'category': 'Service'
    },
    {
      'title': 'Mobile Game and App Development',
      'price': '\$700',
      'category': 'Service'
    },
    {'title': 'UI/UX & Webflow', 'price': '\$200', 'category': 'Service'},
    {
      'title': 'Artificial Intelligence using Python',
      'price': '\$550',
      'category': 'Course'
    },
    {
      'title': 'Startup Strategies and Entrepreneurship',
      'price': '\$300',
      'category': 'Course'
    },
    {'title': 'Virtual Assistant', 'price': '\$150', 'category': 'Service'},
    {
      'title': 'Data Analytics and Business Intelligence',
      'price': '\$500',
      'category': 'Course'
    },
    {'title': 'QuickBooks', 'price': '\$180', 'category': 'Service'},
    {
      'title': 'SEO (Search Engine Optimization)',
      'price': '\$220',
      'category': 'Service'
    },
    {'title': 'Graphic Design', 'price': '\$180', 'category': 'Service'},
    {'title': 'Creative Writing', 'price': '\$120', 'category': 'Service'},
    {'title': 'AutoCAD', 'price': '\$280', 'category': 'Course'},
    {'title': 'Digital Literacy', 'price': '\$100', 'category': 'Course'},
    {'title': 'Digital Marketing', 'price': '\$250', 'category': 'Service'},
    {'title': 'E-Commerce Management', 'price': '\$300', 'category': 'Service'},
    {'title': 'Freelancing', 'price': '\$150', 'category': 'Course'},
    {
      'title': 'Communication and Soft Skills',
      'price': '\$130',
      'category': 'Course'
    },
    {
      'title': 'Video Editing, Animation and Vlogging',
      'price': '\$260',
      'category': 'Service'
    },
    {'title': 'Affiliate Marketing', 'price': '\$200', 'category': 'Service'},
    {'title': 'WordPress', 'price': '\$220', 'category': 'Service'},
  ];

  // Add / Edit Dialog
  void _showAddEditDialog({Map<String, dynamic>? item, int? index}) {
    final titleController = TextEditingController(text: item?['title'] ?? '');
    final priceController = TextEditingController(text: item?['price'] ?? '');
    String category = item?['category'] ?? 'Service';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item == null ? 'Add New Service/Course' : 'Edit Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: priceController,
              decoration:
                  const InputDecoration(labelText: 'Price (e.g. \$200)'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: category,
              items: ['Service', 'Course'].map((String cat) {
                return DropdownMenuItem(value: cat, child: Text(cat));
              }).toList(),
              onChanged: (val) {
                if (val != null) category = val;
              },
              decoration: const InputDecoration(labelText: 'Category'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty &&
                  priceController.text.isNotEmpty) {
                setState(() {
                  if (item == null) {
                    _servicesAndCourses.add({
                      'title': titleController.text,
                      'price': priceController.text,
                      'category': category,
                    });
                  } else {
                    _servicesAndCourses[index!] = {
                      'title': titleController.text,
                      'price': priceController.text,
                      'category': category,
                    };
                  }
                });
                Navigator.pop(context);
              }
            },
            child: Text(item == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  // Delete item
  void _deleteItem(int index) {
    setState(() {
      _servicesAndCourses.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Company Logo / Icon next to Admin name
            const CircleAvatar(
              backgroundColor: Colors.indigo,
              child: Icon(Icons.admin_panel_settings, color: Colors.white),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Admin Panel',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('Dynetix Management',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _servicesAndCourses.length,
        itemBuilder: (context, index) {
          final item = _servicesAndCourses[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text(
                item['title'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                  'Category: ${item['category']} | Price: ${item['price']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () =>
                        _showAddEditDialog(item: item, index: index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteItem(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditDialog(),
        label: const Text('Add Service/Course'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
