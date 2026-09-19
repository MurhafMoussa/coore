import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class const LocalizationConfigEntity({
  required final List<Locale> supportedLocales,
  required final List<LocalizationsDelegate<dynamic>> localizationsDelegates,
  required final Locale defaultLocale,
}) extends Equatable {

  @override
  List<Object> get props => [
        supportedLocales,
        localizationsDelegates,
        defaultLocale,
      ];
}
