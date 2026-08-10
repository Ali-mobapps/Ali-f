import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:upzet/controller/my_controller.dart';
import 'package:upzet/helper/utils/ui_mixins.dart';

import '../../models/chart_model.dart';

enum TimeRange { all, oneMonth, sixMonths, oneYear }

class DashboardController extends MyController with UIMixin {
  TimeRange selectedRange = TimeRange.oneMonth;
  late List<ChartSampleData> socialSource;
  String selectedXLabel = 'Total';
  String selectedYLabel = '341';
  late MapShapeSource selectionMapSource;
  late List<StateElectionDetails> stateWiseElectionResult;
  late List<MapColorMapper> colorMappers;
  int selectedIndex = -1;

  TooltipBehavior? tooltipBehavior;

  void onSelectTime(TimeRange value) {
    selectedRange = value;
    update();
  }

  String labelFor(TimeRange range) {
    switch (range) {
      case TimeRange.all:
        return 'ALL';
      case TimeRange.oneMonth:
        return '1M';
      case TimeRange.sixMonths:
        return '6M';
      case TimeRange.oneYear:
        return '1Y';
    }
  }

  String selectedMonth = 'MAY';

  final Map<String, String> months = {'MAY': 'May', 'AP': 'April', 'MA': 'March', 'FE': 'February', 'JA': 'January', 'DE': 'December'};

  final List<ChartSampleData> chartData = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'].map((month) {
    final random = Random();
    final y = random.nextInt(70) + 1;
    return ChartSampleData(x: month, y: y, yValue: y * 100);
  }).toList();

  final TooltipBehavior chart = TooltipBehavior(enable: true, format: 'point.x : point.yValue1 : point.yValue2');
  @override
  void onInit() {
    tooltipBehavior = TooltipBehavior(enable: true, format: 'point.x : point.y');

    socialSource = [
      ChartSampleData(x: 'Facebook', y: 10, text: '67%', pointColor: const Color.fromRGBO(248, 177, 149, 1.0)),
      ChartSampleData(x: 'Tweeter', y: 11, text: '55%', pointColor: contentTheme.info),
      ChartSampleData(x: 'Instagram', y: 12, text: '44%', pointColor: contentTheme.success),
    ];
    stateWiseElectionResult = <StateElectionDetails>[
      const StateElectionDetails(
        state: 'Washington',
        stateCode: 'DC',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 3317019,
        votes: 1742718,
        percentage: 52.54,
      ),
      const StateElectionDetails(
        state: 'Oregon',
        stateCode: 'OR',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 2001336,
        votes: 1002106,
        percentage: 50.07,
      ),
      const StateElectionDetails(
        state: 'Alabama',
        stateCode: 'AL',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 2123372,
        votes: 1318255,
        percentage: 62.08,
      ),
      const StateElectionDetails(
        state: 'Alaska',
        stateCode: 'AK',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 318608,
        votes: 163387,
        percentage: 51.28,
      ),
      const StateElectionDetails(
        state: 'Arizona',
        stateCode: 'AZ',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 2604657,
        votes: 1252401,
        percentage: 48.08,
      ),
      const StateElectionDetails(
        state: 'Arkansas',
        stateCode: 'AR',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 1130676,
        votes: 684872,
        percentage: 60.57,
      ),
      const StateElectionDetails(
        state: 'California',
        stateCode: 'CA',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 14181595,
        votes: 8753788,
        percentage: 61.73,
      ),
      const StateElectionDetails(
        state: 'Colorado',
        stateCode: 'CO',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 2780247,
        votes: 1338870,
        percentage: 48.16,
      ),
      const StateElectionDetails(
        state: 'Connecticut',
        stateCode: 'CT',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 1644920,
        votes: 897572,
        percentage: 54.57,
      ),
      const StateElectionDetails(
        state: 'Delaware',
        stateCode: 'DE',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 443814,
        votes: 235603,
        percentage: 53.09,
      ),
      const StateElectionDetails(
        state: 'Florida',
        stateCode: 'FL',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 9420039,
        votes: 4617886,
        percentage: 49.02,
      ),
      const StateElectionDetails(
        state: 'Georgia',
        stateCode: 'GA',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 4114732,
        votes: 2089104,
        percentage: 50.77,
      ),
      const StateElectionDetails(
        state: 'Hawaii',
        stateCode: 'HI',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 428937,
        votes: 266891,
        percentage: 62.22,
      ),
      const StateElectionDetails(
        state: 'Idaho',
        stateCode: 'ID',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 690255,
        votes: 409055,
        percentage: 59.26,
      ),
      const StateElectionDetails(
        state: 'Illinois',
        stateCode: 'IL',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 5536424,
        votes: 3090729,
        percentage: 55.83,
      ),
      const StateElectionDetails(
        state: 'Indiana',
        stateCode: 'IN',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 2734958,
        votes: 1557286,
        percentage: 56.82,
      ),
      const StateElectionDetails(
        state: 'Lowa',
        stateCode: 'IA',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 1566031,
        votes: 800983,
        percentage: 51.15,
      ),
      const StateElectionDetails(
        state: 'Kansas',
        stateCode: 'KS',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 1184402,
        votes: 671018,
        percentage: 56.65,
      ),
      const StateElectionDetails(
        state: 'Kentucky',
        stateCode: 'KY',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 1924149,
        votes: 1202971,
        percentage: 62.52,
      ),
      const StateElectionDetails(
        state: 'Louisiana',
        stateCode: 'LA',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 2029032,
        votes: 1178638,
        percentage: 58.09,
      ),
      const StateElectionDetails(
        state: 'Maine',
        stateCode: 'ME',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 747927,
        votes: 357735,
        percentage: 47.83,
      ),
      const StateElectionDetails(
        state: 'Maryland',
        stateCode: 'MD',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 2781446,
        votes: 1677928,
        percentage: 60.33,
      ),
      const StateElectionDetails(
        state: 'Massachusetts',
        stateCode: 'MA',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 3325046,
        votes: 1995196,
        percentage: 60.01,
      ),
      const StateElectionDetails(
        state: 'Michigan',
        stateCode: 'MI',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 4799284,
        votes: 2279543,
        percentage: 47.50,
      ),
      const StateElectionDetails(
        state: 'Minnesota',
        stateCode: 'MN',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 2944813,
        votes: 1367716,
        percentage: 46.44,
      ),
      const StateElectionDetails(
        state: 'Mississippi',
        stateCode: 'MS',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 1209357,
        votes: 700714,
        percentage: 57.86,
      ),
      const StateElectionDetails(
        state: 'Missouri',
        stateCode: 'MO',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 2808605,
        votes: 1594511,
        percentage: 56.77,
      ),
      const StateElectionDetails(
        state: 'Montana',
        stateCode: 'MT',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 497147,
        votes: 279240,
        percentage: 56.17,
      ),
      const StateElectionDetails(
        state: 'Nebraska',
        stateCode: 'NE',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 844227,
        votes: 495961,
        percentage: 58.75,
      ),
      const StateElectionDetails(
        state: 'Nevada',
        stateCode: 'NV',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 1125385,
        votes: 539260,
        percentage: 47.92,
      ),
      const StateElectionDetails(
        state: 'New Hampshire',
        stateCode: 'NH',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 744296,
        votes: 348526,
        percentage: 46.98,
      ),
      const StateElectionDetails(
        state: 'New Jersey',
        stateCode: 'NJ',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 3874046,
        votes: 2148278,
        percentage: 55.45,
      ),
      const StateElectionDetails(
        state: 'New Mexico',
        stateCode: 'NM',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 798319,
        votes: 385234,
        percentage: 48.26,
      ),
      const StateElectionDetails(
        state: 'New York',
        stateCode: 'NY',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 7721453,
        votes: 4556124,
        percentage: 59.01,
      ),
      const StateElectionDetails(
        state: 'North Carolina',
        stateCode: 'NC',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 4741564,
        votes: 2362631,
        percentage: 49.83,
      ),
      const StateElectionDetails(
        state: 'North Dakota',
        stateCode: 'ND',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 344360,
        votes: 216794,
        percentage: 62.96,
      ),
      const StateElectionDetails(
        state: 'Ohio',
        stateCode: 'OH',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 5496487,
        votes: 2841005,
        percentage: 51.69,
      ),
      const StateElectionDetails(
        state: 'Oklahoma',
        stateCode: 'OK',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 1452992,
        votes: 949136,
        percentage: 65.32,
      ),
      const StateElectionDetails(
        state: 'Pennsylvania',
        stateCode: 'PA',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 6165478,
        votes: 2970733,
        percentage: 48.18,
      ),
      const StateElectionDetails(
        state: 'Rhode Island',
        stateCode: 'RI',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 464144,
        votes: 252525,
        percentage: 54.41,
      ),
      const StateElectionDetails(
        state: 'South Carolina',
        stateCode: 'SC',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 2103027,
        votes: 1155389,
        percentage: 54.94,
      ),
      const StateElectionDetails(
        state: 'South Dakota',
        stateCode: 'SD',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 370093,
        votes: 227721,
        percentage: 61.53,
      ),
      const StateElectionDetails(
        state: 'Tennessee',
        stateCode: 'TN',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 2508027,
        votes: 1522925,
        percentage: 60.72,
      ),
      const StateElectionDetails(
        state: 'Texas',
        stateCode: 'TX',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 8969226,
        votes: 4685047,
        percentage: 52.23,
      ),
      const StateElectionDetails(
        state: 'Utah',
        stateCode: 'UT',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 1131430,
        votes: 515231,
        percentage: 45.54,
      ),
      const StateElectionDetails(
        state: 'Vermont',
        stateCode: 'VT',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 315067,
        votes: 178573,
        percentage: 56.68,
      ),
      const StateElectionDetails(
        state: 'Virginia',
        stateCode: 'VA',
        candidate: 'Hillary Clinton',
        party: 'Democratic',
        totalVoters: 3984631,
        votes: 1981473,
        percentage: 49.73,
      ),
      const StateElectionDetails(
        state: 'West Virginia',
        stateCode: 'WV',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 714423,
        votes: 489371,
        percentage: 68.50,
      ),
      const StateElectionDetails(
        state: 'Wisconsin',
        stateCode: 'WI',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 2976150,
        votes: 1405284,
        percentage: 47.22,
      ),
      const StateElectionDetails(
        state: 'Wyoming',
        stateCode: 'WY',
        candidate: 'Donald Trump',
        party: 'Republican',
        totalVoters: 255849,
        votes: 174419,
        percentage: 68.17,
      ),
    ];

    colorMappers = <MapColorMapper>[
      const MapColorMapper(from: 80, to: 100, color: Color.fromRGBO(0, 0, 81, 1.0), text: '{Democratic},{}'),
      const MapColorMapper(from: 75, to: 80, color: Color.fromRGBO(0, 43, 132, 1.0), text: ''),
      const MapColorMapper(from: 70, to: 75, color: Color.fromRGBO(6, 69, 180, 1.0), text: ''),
      const MapColorMapper(from: 65, to: 70, color: Color.fromRGBO(22, 102, 203, 1.0), text: ''),
      const MapColorMapper(from: 60, to: 65, color: Color.fromRGBO(67, 137, 227, 1.0), text: ''),
      const MapColorMapper(from: 55, to: 60, color: Color.fromRGBO(80, 154, 242, 1.0), text: ''),
      const MapColorMapper(from: 45, to: 55, color: Color.fromRGBO(134, 182, 242, 1.0), text: ''),
      const MapColorMapper(from: -55, to: -45, color: Color.fromRGBO(255, 178, 178, 1.0), text: ''),
      const MapColorMapper(from: -60, to: -55, color: Color.fromRGBO(255, 127, 127, 1.0), text: ''),
      const MapColorMapper(from: -65, to: -60, color: Color.fromRGBO(255, 76, 76, 1.0), text: ''),
      const MapColorMapper(from: -70, to: -65, color: Color.fromRGBO(255, 50, 50, 1.0), text: ''),
      const MapColorMapper(from: -75, to: -70, color: Color.fromRGBO(178, 0, 0, 1.0), text: ''),
      const MapColorMapper(from: -80, to: -75, color: Color.fromRGBO(127, 0, 0, 1.0), text: ''),
      const MapColorMapper(from: -100, to: -80, color: Color.fromRGBO(102, 0, 0, 1.0), text: 'Republican'),
    ];
    selectionMapSource = MapShapeSource.asset(
      'assets/data/usa.json',
      shapeDataField: 'name',
      dataCount: stateWiseElectionResult.length,
      primaryValueMapper: (int index) => stateWiseElectionResult[index].state!,
      shapeColorValueMapper: (int index) {
        if (stateWiseElectionResult[index].candidate == 'Hillary Clinton') {
          return stateWiseElectionResult[index].percentage;
        } else {
          return -stateWiseElectionResult[index].percentage!;
        }
      },
      shapeColorMappers: colorMappers,
      dataLabelMapper: (int index) => stateWiseElectionResult[index].stateCode!,
    );
    super.onInit();
  }
}

class StateElectionDetails {
  const StateElectionDetails({required this.totalVoters, this.state, this.stateCode, this.party, this.candidate, this.votes, this.percentage});

  final String? state;
  final String? stateCode;
  final double totalVoters;
  final String? party;
  final String? candidate;
  final double? votes;
  final double? percentage;
}
