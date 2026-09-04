import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../../Provider/seller_info_provider.dart';
import '../../Provider/subacription_plan_provider.dart';
import '../../model/seller_info_model.dart';
import '../Widgets/Constant Data/constant.dart';
import '../Widgets/Constant Data/export_button.dart';
import '../Widgets/Pop Up/Reports/view_reports.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  static const String route = '/reports';

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  String? _calculateEndDate(String? startDateString, int durationDays) {
    if (startDateString != null) {
      DateTime startDate = DateTime.parse(startDateString);
      DateTime endDate = startDate.add(Duration(days: durationDays));
      return endDate.toString().substring(0, 10); // Only date part
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    checkCurrentUserAndRestartApp();
  }

  final _horizontalScroll = ScrollController();
  final _verticalScroll = ScrollController();

  int currentPage = 1;
  int itemsPerPage = 10;
  String searchItem = '';

  // Helper function to filter reports based on search term
  List<SellerInfoModel> _filterReports(List<SellerInfoModel> reports, String searchTerm) {
    if (searchTerm.isEmpty) return reports;

    return reports.where((report) {
      return report.companyName?.toLowerCase().contains(searchTerm.toLowerCase()) == true ||
          report.businessCategory?.toLowerCase().contains(searchTerm.toLowerCase()) == true ||
          report.subscriptionName?.toLowerCase().contains(searchTerm.toLowerCase()) == true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: kDarkWhite,
      body: Consumer(
        builder: (_, ref, watch) {
          final reports = ref.watch(sellerInfoProvider);
          final subs = ref.watch(subscriptionPlanProvider);

          return reports.when(
            data: (allReports) {
              return subs.when(
                data: (snapShot) {
                  // Apply search filter first
                  final filteredReports = _filterReports(allReports, searchItem);

                  // Calculate pagination based on filtered reports
                  final totalItems = itemsPerPage == -1 ? filteredReports.length : itemsPerPage;
                  final totalPages = (filteredReports.length / totalItems).ceil();

                  final startIndex = (currentPage - 1) * totalItems;
                  var endIndex = startIndex + totalItems;
                  if (endIndex > filteredReports.length) {
                    endIndex = filteredReports.length;
                  }
                  if (itemsPerPage == -1) {
                    endIndex = filteredReports.length;
                  }

                  // Get paginated reports
                  final paginatedReports = itemsPerPage == -1
                      ? filteredReports
                      : filteredReports.sublist(startIndex,
                          endIndex > filteredReports.length ? filteredReports.length : endIndex);

                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: kWhiteTextColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reports',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 16),
                          Divider(height: 1, color: kNutral300, thickness: 1),

                          ///---------------------search---------------------------
                          const SizedBox(height: 8),
                          ResponsiveGridRow(rowSegments: 100, children: [
                            ResponsiveGridCol(
                              xs: screenWidth < 360
                                  ? 50
                                  : screenWidth > 430
                                      ? 33
                                      : 40,
                              md: screenWidth < 768
                                  ? 24
                                  : screenWidth < 950
                                      ? 20
                                      : 15,
                              lg: screenWidth < 1700 ? 15 : 10,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 48,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(color: kNutral300),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                          child: Text('Show-', style: theme.textTheme.bodyLarge)),
                                      DropdownButton<int>(
                                        isDense: true,
                                        padding: EdgeInsets.zero,
                                        underline: const SizedBox(),
                                        value: itemsPerPage,
                                        icon: const Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Colors.black,
                                        ),
                                        items: [10, 20, 50, 100, -1]
                                            .map<DropdownMenuItem<int>>((int value) {
                                          return DropdownMenuItem<int>(
                                            value: value,
                                            child: Text(
                                              value == -1 ? "All" : value.toString(),
                                              style: theme.textTheme.bodyLarge,
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (int? newValue) {
                                          setState(() {
                                            itemsPerPage = newValue ?? 10;
                                            currentPage =
                                                1; // Reset to first page when changing items per page
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            ResponsiveGridCol(
                              xs: 100,
                              md: 60,
                              lg: 35,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: AppTextField(
                                  showCursor: true,
                                  cursorColor: kTitleColor,
                                  onChanged: (value) {
                                    setState(() {
                                      searchItem = value;
                                      currentPage = 1; // Reset to first page when searching
                                    });
                                  },
                                  textFieldType: TextFieldType.NAME,
                                  decoration: kInputDecoration.copyWith(
                                    hintText: 'Search By Name',
                                    suffixIcon: const Icon(
                                      FeatherIcons.search,
                                      color: kNutral700,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ]),
                          const SizedBox(height: 8.0),
                          Row(
                            children: [
                              SizedBox(
                                height: 40,
                                width: MediaQuery.of(context).size.width * .25,
                                child: TextField(
                                  showCursor: true,
                                  cursorColor: kTitleColor,
                                  decoration: kInputDecoration.copyWith(
                                    hintText: 'Search Anything...',
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8.0),
                                          color: kBlueTextColor,
                                        ),
                                        child: const Icon(
                                          FeatherIcons.search,
                                          color: kWhiteTextColor,
                                        ),
                                      ),
                                    ),
                                    hintStyle: kTextStyle.copyWith(color: kLitGreyColor),
                                    contentPadding: const EdgeInsets.all(4.0),
                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                      borderSide: BorderSide(
                                        color: kBorderColorTextField,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              const ExportButton(),
                            ],
                          ).visible(false),
                          const SizedBox(height: 10.0),
                          Expanded(
                            child: RawScrollbar(
                              controller: _horizontalScroll,
                              thickness: 8.0,
                              thumbVisibility: true,
                              child: LayoutBuilder(
                                builder: (BuildContext context, BoxConstraints constraints) {
                                  final kWidth = constraints.maxWidth;
                                  return SingleChildScrollView(
                                    controller: _horizontalScroll,
                                    scrollDirection: Axis.horizontal,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(minWidth: kWidth),
                                        child: DataTable(
                                          border: TableBorder.all(
                                            color: kBorderColorTextField,
                                            borderRadius: BorderRadius.circular(5.0),
                                          ),
                                          dividerThickness: 1.0,
                                          headingRowColor: WidgetStateProperty.all(kMainColor50),
                                          showBottomBorder: true,
                                          headingTextStyle: theme.textTheme.titleSmall?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                          dataTextStyle: theme.textTheme.bodyMedium
                                              ?.copyWith(color: kNutral800),
                                          columnSpacing: 40.0,
                                          columns: [
                                            DataColumn(
                                              label: SizedBox(
                                                width: 100, // Match your expected column width
                                                child: Center(
                                                  child: Text('Date'),
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: SizedBox(
                                                width: 120,
                                                child: Center(
                                                  child: Text('Shop Name'),
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: SizedBox(
                                                width: 120,
                                                child: Center(
                                                  child: Text('Category'),
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: SizedBox(
                                                width: 120,
                                                child: Center(
                                                  child: Text('Package'),
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: SizedBox(
                                                width: 100,
                                                child: Center(
                                                  child: Text('Start'),
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: SizedBox(
                                                width: 100,
                                                child: Center(
                                                  child: Text('End'),
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: SizedBox(
                                                width: 100,
                                                child: Center(
                                                  child: Text('Method'),
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: SizedBox(
                                                width: 100,
                                                child: Center(
                                                  child: Text('Action'),
                                                ),
                                              ),
                                            ),
                                          ],
                                          rows: List.generate(
                                            paginatedReports.length,
                                            (index) {
                                              int? currentDuration;
                                              for (var element in snapShot) {
                                                if (element.subscriptionName ==
                                                    paginatedReports[index].subscriptionName) {
                                                  currentDuration = element.duration;
                                                  break;
                                                }
                                              }
                                              final endDate = _calculateEndDate(
                                                paginatedReports[index].subscriptionDate,
                                                currentDuration ?? 0,
                                              );

                                              return DataRow(
                                                cells: [
                                                  DataCell(
                                                    Text(
                                                      paginatedReports[index]
                                                              .subscriptionDate
                                                              ?.substring(0, 10) ??
                                                          '',
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Text(
                                                        paginatedReports[index].companyName ?? ''),
                                                  ),
                                                  DataCell(
                                                    Text(
                                                        paginatedReports[index].businessCategory ??
                                                            ''),
                                                  ),
                                                  DataCell(
                                                    Text(
                                                        paginatedReports[index].subscriptionName ??
                                                            ''),
                                                  ),
                                                  DataCell(
                                                    Text(paginatedReports[index]
                                                            .subscriptionDate
                                                            ?.substring(0, 10) ??
                                                        ''),
                                                  ),
                                                  DataCell(Text(endDate ?? '')),
                                                  DataCell(
                                                    Text(paginatedReports[index]
                                                            .subscriptionMethod ??
                                                        ''),
                                                  ),
                                                  DataCell(
                                                    SizedBox(
                                                      width: 100,
                                                      child: Center(
                                                        child: PopupMenuButton(
                                                          color: Colors.white,
                                                          icon: const Icon(
                                                            FeatherIcons.moreVertical,
                                                            size: 18.0,
                                                          ),
                                                          padding: EdgeInsets.zero,
                                                          itemBuilder: (BuildContext bc) => [
                                                            PopupMenuItem(
                                                              child: GestureDetector(
                                                                onTap: () => showDialog(
                                                                  barrierDismissible: false,
                                                                  context: context,
                                                                  builder: (BuildContext context) {
                                                                    return Dialog(
                                                                      backgroundColor:
                                                                          Colors.white,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                10.0),
                                                                      ),
                                                                      child: ViewReport(
                                                                        sellerInfoModel:
                                                                            paginatedReports[
                                                                                index],
                                                                        endDate: endDate,
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    const Icon(
                                                                      FeatherIcons.eye,
                                                                      size: 18.0,
                                                                      color: kTitleColor,
                                                                    ),
                                                                    const SizedBox(width: 4.0),
                                                                    Text(
                                                                      'View',
                                                                      style: kTextStyle.copyWith(
                                                                          color: kTitleColor),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                          onSelected: (value) {
                                                            Navigator.pushNamed(context, '$value');
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    'Showing ${paginatedReports.isEmpty ? 0 : startIndex + 1} to ${endIndex > filteredReports.length ? filteredReports.length : endIndex} of ${filteredReports.length} entries',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: kNutral700,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: kNutral300),
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: GestureDetector(
                                          onTap: () {
                                            if (currentPage > 1) {
                                              setState(() {
                                                currentPage--;
                                              });
                                            }
                                          },
                                          child: Text(
                                            'Previous',
                                            style: theme.textTheme.bodyLarge?.copyWith(
                                              color: kNutral700,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                          color: kMainColor,
                                          border: Border.symmetric(
                                            vertical: BorderSide(color: kNutral300),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Text(
                                            '$currentPage',
                                            style: theme.textTheme.bodyLarge?.copyWith(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                          border: Border.symmetric(
                                            vertical: BorderSide(color: kNutral300),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Text(
                                            '$totalPages',
                                            style: theme.textTheme.bodyLarge?.copyWith(
                                              color: kNutral700,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: GestureDetector(
                                          onTap: () {
                                            if (currentPage < totalPages) {
                                              setState(() {
                                                currentPage++;
                                              });
                                            }
                                          },
                                          child: Text(
                                            'Next',
                                            style: theme.textTheme.bodyLarge?.copyWith(
                                              color: kNutral700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                error: (e, stack) {
                  return Center(child: Text(e.toString()));
                },
                loading: () {
                  return const Center(child: CircularProgressIndicator());
                },
              );
            },
            error: (e, stack) {
              return Center(child: Text(e.toString()));
            },
            loading: () {
              return const Center(child: CircularProgressIndicator());
            },
          );
        },
      ),
    );
  }
}

// class Reports extends StatefulWidget {
//   const Reports({Key? key}) : super(key: key);
//
//   static const String route = '/reports';
//
//   @override
//   State<Reports> createState() => _ReportsState();
// }
//
// class _ReportsState extends State<Reports> {
//   String? _calculateEndDate(String? startDateString, int durationDays) {
//     if (startDateString != null) {
//       DateTime startDate = DateTime.parse(startDateString);
//       DateTime endDate = startDate.add(Duration(days: durationDays));
//       return endDate
//           .toString()
//           .substring(0, 10); // Assuming you want only date part
//     }
//     return null;
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     checkCurrentUserAndRestartApp();
//   }
//
//   final _horizontalScroll = ScrollController();
//   final _verticalScroll = ScrollController();
//
//   int currentPage = 1;
//   late int itemsPerPage = 10;
//   String searchItem = '';
//
//   @override
//   Widget build(BuildContext context) {
//     final theme=Theme.of(context);
//     return Scaffold(
//       // appBar: const GlobalAppbar(),
//       // drawer:  Drawer(
//       //   // backgroundColor: kNutral900,
//       //   // shape: RoundedRectangleBorder(
//       //   //   borderRadius: BorderRadius.circular(0)
//       //   // ),
//       //   child: SideBarWidget(
//       //     index: 3,
//       //     isTab: false,
//       //   ),
//       // ),
//       backgroundColor: kDarkWhite,
//
//       body: Consumer(
//         builder: (_, ref, watch) {
//           final reports = ref.watch(sellerInfoProvider);
//           final subs = ref.watch(subscriptionPlanProvider);
//           return reports.when(data: (reports) {
//             return subs.when(data: (snapShot) {
//               List<SellerInfoModel> showAbleSaleTransactions = [];
//               // Calculate pagination
//               final totalPages = itemsPerPage == -1 ? 1 : (showAbleSaleTransactions.length / itemsPerPage).ceil();
//               final startIndex = itemsPerPage == -1 ? 0 : (currentPage - 1) * itemsPerPage;
//               final endIndex = itemsPerPage == -1 ? showAbleSaleTransactions.length : (startIndex + itemsPerPage).clamp(0, showAbleSaleTransactions.length);
//
//               // Get paginated transactions
//               final paginatedTransactions = showAbleSaleTransactions.sublist(startIndex, endIndex);
//
//               return Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Container(
//                   padding: const EdgeInsets.all(10.0),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10.0),
//                       color: kWhiteTextColor),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Reports',
//                         style: Theme.of(context)
//                             .textTheme
//                             .titleLarge
//                             ?.copyWith(fontWeight: FontWeight.w600),
//                       ),
//                       const SizedBox(height: 10.0),
//                       Row(
//                         children: [
//                           SizedBox(
//                             height: 40,
//                             width: MediaQuery.of(context).size.width * .25,
//                             child: TextField(
//                               showCursor: true,
//                               cursorColor: kTitleColor,
//                               decoration: kInputDecoration.copyWith(
//                                 hintText: 'Search Anything...',
//                                 suffixIcon: Padding(
//                                   padding: const EdgeInsets.all(4.0),
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(8.0),
//                                       color: kBlueTextColor,
//                                     ),
//                                     child: const Icon(FeatherIcons.search,
//                                         color: kWhiteTextColor),
//                                   ),
//                                 ),
//                                 hintStyle:
//                                     kTextStyle.copyWith(color: kLitGreyColor),
//                                 contentPadding: const EdgeInsets.all(4.0),
//                                 enabledBorder: const OutlineInputBorder(
//                                   borderRadius: BorderRadius.all(
//                                     Radius.circular(8.0),
//                                   ),
//                                   borderSide: BorderSide(
//                                       color: kBorderColorTextField, width: 1),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const Spacer(),
//                           const ExportButton()
//                         ],
//                       ).visible(false),
//                       const SizedBox(height: 10.0),
//                       Expanded(
//                         child: RawScrollbar(
//                           controller: _horizontalScroll,
//                           thickness: 8.0,
//                           thumbVisibility: true,
//                           child: LayoutBuilder(
//                             builder: (BuildContext context,
//                                 BoxConstraints constraints) {
//                               final kWidth = constraints.maxWidth;
//                               return SingleChildScrollView(
//                                 controller: _horizontalScroll,
//                                 scrollDirection: Axis.horizontal,
//                                 child: SingleChildScrollView(
//                                   scrollDirection: Axis.vertical,
//                                   child: ConstrainedBox(
//                                     constraints:
//                                         BoxConstraints(minWidth: kWidth),
//                                     child: DataTable(
//                                       border: TableBorder.all(
//                                         color: kBorderColorTextField,
//                                         borderRadius:
//                                             BorderRadius.circular(5.0),
//                                       ),
//                                       dividerThickness: 1.0,
//                                       headingRowColor:
//                                           WidgetStateProperty.all(kMainColor50),
//                                       showBottomBorder: true,
//                                       headingTextStyle: Theme.of(context)
//                                           .textTheme
//                                           .titleSmall
//                                           ?.copyWith(
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                       dataTextStyle: Theme.of(context)
//                                           .textTheme
//                                           .bodyMedium
//                                           ?.copyWith(color: kNutral800),
//                                       // horizontalMargin: 20.0,
//                                       columnSpacing: 10.0,
//                                       columns: const [
//                                         DataColumn(
//                                           label: Text('Date'),
//                                         ),
//                                         DataColumn(
//                                           label: Text('Shop Name'),
//                                         ),
//                                         DataColumn(
//                                           label: Text('Category'),
//                                         ),
//                                         DataColumn(
//                                           label: Text('Package'),
//                                         ),
//                                         DataColumn(
//                                           label: Text('Start'),
//                                         ),
//                                         DataColumn(
//                                           label: Text('End'),
//                                         ),
//                                         DataColumn(
//                                           label: Text('Method'),
//                                         ),
//                                         DataColumn(
//                                           label: Text('Action'),
//                                         ),
//                                       ],
//                                       rows: List.generate(20,
//                                           (index) {
//                                         print('-----reports length-------${reports.length}-------------------');
//                                         int? currentDuration;
//                                         for (var element in snapShot) {
//                                           if (element.subscriptionName ==
//                                               reports[index].subscriptionName) {
//                                             currentDuration = element.duration;
//                                             break; // Stop loop once duration is found
//                                           }
//                                         }
//                                         // Calculate end date
//                                         final endDate = _calculateEndDate(
//                                             reports[index].subscriptionDate,
//                                             currentDuration ?? 0);
//
//                                         return DataRow(
//                                           cells: [
//                                             DataCell(
//                                               Text(reports[index]
//                                                       .subscriptionDate
//                                                       ?.substring(0, 10) ??
//                                                   ''),
//                                             ),
//                                             DataCell(
//                                               Text(reports[index].companyName ??
//                                                   ''),
//                                             ),
//                                             DataCell(
//                                               Text(reports[index]
//                                                       .businessCategory ??
//                                                   ''),
//                                             ),
//                                             DataCell(
//                                               Text(reports[index]
//                                                       .subscriptionName ??
//                                                   ''),
//                                             ),
//                                             DataCell(
//                                               Text(reports[index]
//                                                       .subscriptionDate
//                                                       ?.substring(0, 10) ??
//                                                   ''),
//                                             ),
//                                             DataCell(
//                                               Text(endDate ?? ''),
//                                             ),
//                                             DataCell(
//                                               Text(reports[index]
//                                                       .subscriptionMethod ??
//                                                   ''),
//                                             ),
//                                             DataCell(
//                                               PopupMenuButton(
//                                                 color: Colors.white,
//                                                 icon: const Icon(
//                                                     FeatherIcons.moreVertical,
//                                                     size: 18.0),
//                                                 padding: EdgeInsets.zero,
//                                                 itemBuilder:
//                                                     (BuildContext bc) => [
//                                                   PopupMenuItem(
//                                                     child: GestureDetector(
//                                                       onTap: (() => showDialog(
//                                                             barrierDismissible:
//                                                                 false,
//                                                             context: context,
//                                                             builder:
//                                                                 (BuildContext
//                                                                     context) {
//                                                               return Dialog(
//                                                                 backgroundColor:
//                                                                     Colors
//                                                                         .white,
//                                                                 shape:
//                                                                     RoundedRectangleBorder(
//                                                                   borderRadius:
//                                                                       BorderRadius
//                                                                           .circular(
//                                                                               10.0),
//                                                                 ),
//                                                                 child:
//                                                                     ViewReport(
//                                                                   sellerInfoModel:
//                                                                       reports[
//                                                                           index],
//                                                                   endDate:
//                                                                       endDate,
//                                                                 ),
//                                                               );
//                                                             },
//                                                           )),
//                                                       child: Row(
//                                                         children: [
//                                                           const Icon(
//                                                               FeatherIcons.eye,
//                                                               size: 18.0,
//                                                               color:
//                                                                   kTitleColor),
//                                                           const SizedBox(
//                                                               width: 4.0),
//                                                           Text(
//                                                             'View',
//                                                             style: kTextStyle
//                                                                 .copyWith(
//                                                                     color:
//                                                                         kTitleColor),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                                 onSelected: (value) {
//                                                   Navigator.pushNamed(
//                                                       context, '$value');
//                                                 },
//                                               ),
//                                             ),
//                                           ],
//                                         );
//                                       }),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Flexible(
//                               child: Text(
//                                 'Showing ${startIndex + 1} to ${endIndex > showAbleSaleTransactions.length ? showAbleSaleTransactions.length : endIndex} of ${showAbleSaleTransactions.length} entries',
//                                 style: theme.textTheme.bodyLarge?.copyWith(
//                                   color: kNutral700,
//                                 ),
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                             Container(
//                               alignment: Alignment.center,
//                               height: 32,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(4),
//                                 border: Border.all(color: kNutral300),
//                               ),
//                               child: Row(
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(horizontal: 10),
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         if (currentPage > 1) {
//                                           setState(() {
//                                             currentPage--;
//                                           });
//                                         }
//                                       },
//                                       child: Text(
//                                         'Previous',
//                                         style: theme.textTheme.bodyLarge?.copyWith(
//                                           color: kNutral700,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   Container(
//                                     alignment: Alignment.center,
//                                     decoration: const BoxDecoration(
//                                         color: kMainColor,
//                                         border: Border.symmetric(
//                                             vertical: BorderSide(
//                                               color: kNutral300,
//                                             ))),
//                                     child: Padding(
//                                       padding: const EdgeInsets.symmetric(horizontal: 10),
//                                       child: Text(
//                                         '$currentPage',
//                                         style: theme.textTheme.bodyLarge?.copyWith(
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   Container(
//                                     alignment: Alignment.center,
//                                     decoration: const BoxDecoration(
//                                         border: Border.symmetric(
//                                             vertical: BorderSide(
//                                               color: kNutral300,
//                                             ))),
//                                     child: Padding(
//                                       padding: const EdgeInsets.symmetric(horizontal: 10),
//                                       child: Text(
//                                         '$totalPages',
//                                         style: theme.textTheme.bodyLarge?.copyWith(
//                                           color: kNutral700,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(horizontal: 10),
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         if (currentPage < totalPages) {
//                                           setState(() {
//                                             currentPage++;
//                                           });
//                                         }
//                                       },
//                                       child: Text(
//                                         'Next',
//                                         style: theme.textTheme.bodyLarge?.copyWith(
//                                           color: kNutral700,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               );
//             }, error: (e, stack) {
//               return Center(
//                 child: Text(e.toString()),
//               );
//             }, loading: () {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             });
//           }, error: (e, stack) {
//             return Center(
//               child: Text(e.toString()),
//             );
//           }, loading: () {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           });
//         },
//       ),
//     );
//   }
// }
