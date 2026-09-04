import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;

import '../Provider/general_setting_provider.dart';
import '../Screen/Widgets/static_string/static_string.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textStyle = _theme.textTheme.bodyMedium?.copyWith(
      fontSize: rf.ResponsiveValue<double?>(
        context,
        conditionalValues: const [
          rf.Condition.between(start: 0, end: 290, value: 11),
          rf.Condition.between(start: 291, end: 340, value: 12),
        ],
      ).value,
    );

    return Consumer(
      builder: (_, ref, watch) {
        final settingProvider = ref.watch(generalSettingProvider);
        return settingProvider.when(data: (setting) {
          final companyName = setting.companyName.isNotEmpty == true ? setting.companyName : 'Acnoo';
          return LayoutBuilder(
            builder: (context, constraints) => Container(
              padding: rf.ResponsiveValue<EdgeInsetsGeometry?>(
                context,
                conditionalValues: [
                  rf.Condition.smallerThan(
                    name: BreakpointName.LG.name,
                    value: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ],
                defaultValue: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 18,
                ),
              ).value,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'COPYRIGHT © 2024 $companyName${constraints.maxWidth <= BreakpointName.SM.start ? '' : ', All rights Reserved'}',
                      style: _textStyle,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      text: 'Made With ',
                      children: [
                        WidgetSpan(
                            child: Icon(
                          MdiIcons.heart,
                          color: Colors.red,
                          size: 18,
                        )),
                        TextSpan(text: ' by '),
                        TextSpan(
                          text: companyName,
                          style: _textStyle?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: _theme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    style: _textStyle,
                  )
                ],
              ),
            ),
          );
        }, error: (e, stack) {
          return Text(e.toString());
        }, loading: () {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
      },
      child: LayoutBuilder(
        builder: (context, constraints) => Container(
          padding: rf.ResponsiveValue<EdgeInsetsGeometry?>(
            context,
            conditionalValues: [
              rf.Condition.smallerThan(
                name: BreakpointName.LG.name,
                value: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ],
            defaultValue: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 18,
            ),
          ).value,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'COPYRIGHT © 2024 Acnoo${constraints.maxWidth <= BreakpointName.SM.start ? '' : ', All rights Reserved'}',
                  style: _textStyle,
                ),
              ),
              Text.rich(
                TextSpan(
                  text: 'Made With ',
                  children: [
                    WidgetSpan(
                        child: Icon(
                      MdiIcons.heart,
                      color: Colors.red,
                      size: 18,
                    )),
                    TextSpan(text: ' by '),
                    TextSpan(
                      text: 'Acnoo',
                      style: _textStyle?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: _theme.primaryColor,
                      ),
                    ),
                  ],
                ),
                style: _textStyle,
              )
            ],
          ),
        ),
      ),
    );
  }
}
