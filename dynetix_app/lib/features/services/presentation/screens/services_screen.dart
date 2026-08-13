import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/vip_theme.dart';
import '../../domain/entities/service_entity.dart';
import '../bloc/services_cubit.dart';
import '../bloc/services_state.dart';
import 'service_details_screen.dart';

class ServicesScreen extends StatefulWidget {
  final bool isAdmin;

  const ServicesScreen({
    super.key,
    required this.isAdmin,
  });

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
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
            var services = state.services.where((s) => s.type == 'service').toList();
            
            if (_selectedCategory != 'All') {
              services = services.where((s) => s.category.contains(_selectedCategory)).toList();
            }

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 120,
                  floating: false,
                  pinned: true,
                  backgroundColor: VIPTheme.darkBackground,
                  flexibleSpace: FlexibleSpaceBar(
                    title: const Text('Our Services', style: TextStyle(color: VIPTheme.primaryGold, fontWeight: FontWeight.bold)),
                    background: Container(color: VIPTheme.darkBackground),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome to Dynetix',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Elite Solutions for Your Growth',
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
                              Text('Search services...', style: TextStyle(color: Colors.white54)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Categories
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: ['All', 'Development', 'Design', 'Marketing']
                                .map((cat) => Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: FilterChip(
                                        label: Text(cat),
                                        selected: _selectedCategory == cat,
                                        onSelected: (val) => setState(() => _selectedCategory = cat),
                                        backgroundColor: VIPTheme.cardBackground,
                                        selectedColor: VIPTheme.primaryGold,
                                        labelStyle: TextStyle(
                                          color: _selectedCategory == cat ? Colors.black : Colors.white70,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                        showCheckmark: false,
                                        side: BorderSide.none,
                                      ),
                                    ))
                                .toList(),
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
                      (context, index) => _buildServiceListItem(context, services[index]),
                      childCount: services.length,
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

  Widget _buildServiceListItem(BuildContext context, ServiceEntity service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: VIPTheme.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: VIPTheme.primaryGold.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceDetailsScreen(service: service))),
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: VIPTheme.primaryGold.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.miscellaneous_services_rounded, color: VIPTheme.primaryGold),
        ),
        title: Text(
          service.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
        ),
        subtitle: Text(
          '\$${service.price.toStringAsFixed(2)}',
          style: const TextStyle(color: VIPTheme.primaryGold, fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.white54),
      ),
    );
  }
}
