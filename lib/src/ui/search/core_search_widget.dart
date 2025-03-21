// 3. Enterprise Search Widget
// This widget provides a customizable search interface using the BLoC pattern.
// It integrates Flutter's material components, allowing for a robust search experience.

import 'dart:async';

import 'package:coore/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart' as fp;

/// A typedef for a custom suggestion builder function.
///
/// This function is used to build the suggestion list for the search view.
/// It takes the [BuildContext], [SearchController] controlling the input,
/// and the current [CoreSearchState], and returns an [Iterable] of [Widget]s,
/// either synchronously or asynchronously.
typedef CustomSuggestionBuilder =
    FutureOr<Iterable<Widget>> Function(
      BuildContext context,
      SearchController searchController,
      CoreSearchState state,
    );

/// A generic, customizable search widget for enterprise applications.
///
/// [CoreSearchWidget] integrates a search interface with suggestions,
/// error handling, and state management using the BLoC pattern.
/// The generic type [T] represents the type of each search result.
class CoreSearchWidget<T> extends StatefulWidget {
  /// Creates a [CoreSearchWidget].
  ///
  /// The [resultBuilder] and [searchFunction] are required parameters.
  /// Optionally, you can provide a [suggestionBuilder] to customize the suggestion list.
  /// Additional parameters allow you to customize the appearance and behavior of the search view.
  const CoreSearchWidget({
    super.key,
    this.hintText = '',
    required this.resultBuilder,
    required this.searchFunction,
    this.suggestionBuilder,
    this.isFullScreen,
    this.viewBuilder,
    this.viewLeading,
    this.viewTrailing,
    this.viewHintText,
    this.viewBackgroundColor,
    this.viewElevation,
    this.viewSurfaceTintColor,
    this.viewSide,
    this.viewShape,
    this.viewBarPadding,
    this.headerHeight,
    this.headerTextStyle,
    this.headerHintStyle,
    this.dividerColor,
    this.viewConstraints,
    this.viewPadding,
    this.shrinkWrap,
    this.textCapitalization,
    this.viewOnChanged,
    this.viewOnSubmitted,
    this.textInputAction,
    this.keyboardType,
    this.enabled = true,
  });

  /// Placeholder text shown in the search bar when no input is provided.
  final String hintText;

  /// A builder function that defines how to render each search result of type [T].
  final Widget Function(T itemDate, SearchController searchController)
  resultBuilder;

  /// The asynchronous function to perform the search.
  ///
  /// It takes [SearchParams] and returns a [Future] that resolves to either a [Failure]
  /// or a [List] of search results of type [T].
  final RepositoryFutureResponse<List<T>> Function(SearchParams) searchFunction;

  /// Optional custom suggestion builder to build the suggestion list.
  final CustomSuggestionBuilder? suggestionBuilder;

  /// Whether the search view expands to fill the entire screen when activated.
  /// On mobile, this is typically full-screen, while on other platforms, a smaller size is used.
  final bool? isFullScreen;

  /// Optional callback to obtain a custom widget layout for the suggestion list.
  final ViewBuilder? viewBuilder;

  /// An optional widget displayed before the search field in the search view.
  /// Typically used for a back button or an icon.
  final Widget? viewLeading;

  /// Optional widgets displayed after the search field in the search view.
  /// Typically includes actions like clearing the text.
  final Iterable<Widget>? viewTrailing;

  /// Placeholder text for the search field in the search view.
  final String? viewHintText;

  /// The background color for the search view.
  /// If null, the default color defined in the theme is used.
  final Color? viewBackgroundColor;

  /// The elevation of the search view's [Material] widget.
  /// If null, defaults to 6.0.
  final double? viewElevation;

  /// The surface tint color for the search view's [Material].
  /// This property is part of Material 3's tone-based surface system.
  final Color? viewSurfaceTintColor;

  /// The border styling (color and width) for the search view.
  /// If null, no border is drawn by default.
  final BorderSide? viewSide;

  /// The shape of the search view's underlying [Material].
  /// This is combined with [viewSide] to create a decorated outline.
  final OutlinedBorder? viewShape;

  /// Padding to apply to the search view's search bar.
  /// Defaults to 8.0 horizontally if not provided.
  final EdgeInsetsGeometry? viewBarPadding;

  /// The height of the search field on the search view.
  /// Defaults to 56.0 if not specified.
  final double? headerHeight;

  /// Text style for the search field's input text.
  /// Defaults to the theme's `bodyLarge` style if not provided.
  final TextStyle? headerTextStyle;

  /// Text style for the hint text in the search view.
  /// Falls back to [headerTextStyle] or the theme's `bodyLarge` style.
  final TextStyle? headerHintStyle;

  /// The color of the divider used in the search view.
  /// Defaults to the color defined in the theme if null.
  final Color? dividerColor;

  /// Optional constraints to control the size of the search view.
  /// If not provided, default constraints are used.
  final BoxConstraints? viewConstraints;

  /// Padding for the search view.
  /// Has no effect if the search view is full-screen.
  final EdgeInsetsGeometry? viewPadding;

  /// Whether the search view should shrink-wrap its contents.
  /// Defaults to false if not provided.
  final bool? shrinkWrap;

  /// Determines how the text in the search field is capitalized.
  final TextCapitalization? textCapitalization;

  /// Callback invoked whenever the search text field's value changes.
  final ValueChanged<String>? viewOnChanged;

  /// Callback invoked when the user submits the search field (e.g., presses enter).
  final ValueChanged<String>? viewOnSubmitted;

  /// The action button type for the keyboard.
  final TextInputAction? textInputAction;

  /// The type of keyboard to use for text input.
  final TextInputType? keyboardType;

  /// Whether the search widget is interactive.
  /// If false, the widget appears dimmed and ignores taps.
  final bool enabled;

  @override
  State<CoreSearchWidget<T>> createState() => _CoreSearchWidgetState<T>();
}

/// The state class for [CoreSearchWidget] which manages search logic and UI updates.
class _CoreSearchWidgetState<T> extends State<CoreSearchWidget<T>> {
  /// Controller for managing the search input.
  final _searchController = SearchController();

  /// BLoC instance to manage the search state.
  late final CoreSearchCubit<T> _CoreSearchCubit;

  @override
  void initState() {
    super.initState();
    // Initialize the CoreSearchCubit with the provided search function.
    _CoreSearchCubit = CoreSearchCubit<T>(widget.searchFunction);
    // Add a listener to handle text changes in the search field.
    _searchController.addListener(_onSearchChanged);
  }

  /// Listener function that triggers a search when the query changes.
  void _onSearchChanged() {
    _CoreSearchCubit.onQueryChanged(
      SearchParams(query: _searchController.text),
    );
  }

  @override
  void dispose() {
    // Dispose the controller and close the BLoC to free resources.
    _searchController.dispose();
    _CoreSearchCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Provide the CoreSearchCubit to the widget tree so that child widgets can access it.
    return BlocProvider(
      create: (context) => _CoreSearchCubit,
      child: Builder(
        builder: (context) {
          // Return the SearchAnchor which manages the search view overlay.
          return SearchAnchor(
            searchController: _searchController,
            isFullScreen: widget.isFullScreen,
            viewBuilder: widget.viewBuilder,
            viewLeading: widget.viewLeading,
            viewTrailing: widget.viewTrailing,
            viewHintText: widget.viewHintText,
            viewBackgroundColor: widget.viewBackgroundColor,
            viewElevation: widget.viewElevation,
            viewSurfaceTintColor: widget.viewSurfaceTintColor,
            viewSide: widget.viewSide,
            viewShape: widget.viewShape,
            viewBarPadding: widget.viewBarPadding,
            headerHeight: widget.headerHeight,
            headerTextStyle: widget.headerTextStyle,
            headerHintStyle: widget.headerHintStyle,
            dividerColor: widget.dividerColor,
            viewConstraints: widget.viewConstraints,
            viewPadding: widget.viewPadding,
            shrinkWrap: widget.shrinkWrap,
            textCapitalization: widget.textCapitalization,
            textInputAction: widget.textInputAction,
            keyboardType: widget.keyboardType,
            enabled: widget.enabled,
            // Build the main search bar that users interact with.
            builder: (context, controller) {
              return SearchBar(
                controller: controller,
                hintText: widget.hintText,
                leading: const Icon(Icons.search),
                trailing: [
                  // Use BlocBuilder to update the trailing icon based on the search state.
                  BlocBuilder<CoreSearchCubit<T>, CoreSearchState<T>>(
                    builder: (context, state) {
                      return state.apiState.isLoading
                          ? const Padding(
                            padding: EdgeInsets.all(8),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Icon(Icons.arrow_drop_down);
                    },
                  ),
                ],
              );
            },
            // Build the suggestions or search results list based on the current state.
            suggestionsBuilder: (context, controller) {
              final cubit = context.watch<CoreSearchCubit<T>>();
              final apiState = cubit.getApiState(cubit.state);
              // Use a custom suggestion builder if provided.
              if (widget.suggestionBuilder != null) {
                return widget.suggestionBuilder!(
                  context,
                  controller,
                  cubit.state,
                );
              }
              // Display appropriate messages or results based on the API state.
              if (apiState.isInitial) {
                return [const Center(child: Text('Start typing to search'))];
              }
              if (apiState.isLoading) {
                return [const Center(child: CircularProgressIndicator())];
              }
              if (apiState.isFailed) {
                return [
                  Center(
                    child: Text(
                      'Error: ${apiState.failureObject.getOrElse(() => const UnknownFailure()).message}',
                    ),
                  ),
                ];
              }
              if (apiState.isSuccess) {
                return apiState.data.fold(
                  () => [const Center(child: Text('No results found'))],
                  (t) =>
                      t.isEmpty
                          ? [const Center(child: Text('No results found'))]
                          : t
                              .map(
                                (item) => widget.resultBuilder(
                                  item,
                                  _searchController,
                                ),
                              )
                              .toList(),
                );
              }
              // Fallback in case no conditions are met.
              return [const SizedBox.shrink()];
            },
          );
        },
      ),
    );
  }
}
