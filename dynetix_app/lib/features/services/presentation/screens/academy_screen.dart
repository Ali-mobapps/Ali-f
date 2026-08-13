import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/vip_theme.dart';
import '../../domain/entities/service_entity.dart';
import '../bloc/services_cubit.dart';
import '../bloc/services_state.dart';
import 'service_details_screen.dart';

class AcademyScreen extends StatefulWidget {
  const AcademyScreen({super.key});

  @override
  State<AcademyScreen> createState() => _AcademyScreenState();
}

class _AcademyScreenState extends State<AcademyScreen> {
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    context.read<ServicesCubit>().fetchServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VIPTheme.darkBackground,
      body: BlocBuilder<ServicesCubit, ServicesState>(
        builder: (context, state) {
          if (state is ServicesLoading) {
            return const Center(child: CircularProgressIndicator(color: VIPTheme.primaryGold));
          } else if (state is ServicesLoaded) {
            var courses = state.services.where((s) => s.type == 'course').toList();
            
            if (_selectedCategory != 'All') {
              courses = courses.where((s) => s.category.contains(_selectedCategory)).toList();
            }

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 120,
                  floating: false,
                  pinned: true,
                  backgroundColor: VIPTheme.darkBackground,
                  flexibleSpace: FlexibleSpaceBar(
                    title: const Text('Academy', style: TextStyle(color: VIPTheme.primaryGold, fontWeight: FontWeight.bold)),
                    background: Container(color: VIPTheme.darkBackground),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome to Academy',
                          style: TextStyle(color: VIPTheme.primaryGold, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Master Elite Skills with Our Premium Courses',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
                        ),
                        const SizedBox(height: 24),
                        // Search bar
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: VIPTheme.cardBackground,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.search, color: Colors.white54, size: 20),
                              SizedBox(width: 12),
                              Text('Search courses...', style: TextStyle(color: Colors.white54)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildCourseListItem(courses[index]),
                      childCount: courses.length,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            );
          } else if (state is ServicesError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.white)));
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildCourseListItem(ServiceEntity course) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: VIPTheme.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: VIPTheme.primaryGold.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceDetailsScreen(service: course))),
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.school_rounded, color: Colors.orange),
        ),
        title: Text(course.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
        subtitle: Text('\$${course.price}', style: const TextStyle(color: VIPTheme.primaryGold, fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.white54),
      ),
    );
  }
}
