import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../res/colors.dart';

class CustomTextField extends StatelessWidget {
  final String? hint;
  final String? holder;
  final bool notVisible;
  final Function(String) callback;
  final TextEditingController mHolderController;

  CustomTextField({
    this.hint,
    required this.notVisible,
    required this.callback,
    required this.mHolderController,
    this.holder,
  });

  @override
  Widget build(BuildContext context) {
    if (holder != null) {
      mHolderController.text = holder!;
    }
    return TextField(
      controller: mHolderController,
      autofocus: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: MColors.outlineBorderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: MColors.outlineBorderLight),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: MColors.rejected_color),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: MColors.rejected_color),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: MColors.primary_light_color),
        ),
        counterText: "",
        hintStyle: TextStyle(color: MColors.coolGrey),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        contentPadding: EdgeInsets.all(10),
      ),
      textInputAction: TextInputAction.next,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
      obscureText: notVisible,
      onChanged: (text) {
        callback(text);
      },
    );
  }
}

class MyTextFormField extends FormField<String> {
  MyTextFormField({
    Key? key,
    this.controller,
    String? initialValue,
    FocusNode? focusNode,
    InputDecoration? decoration,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction? textInputAction,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextDirection? textDirection,
    TextAlign textAlign = TextAlign.start,
    TextAlignVertical? textAlignVertical,
    bool autofocus = false,
    bool readOnly = false,
    ToolbarOptions? toolbarOptions,
    bool? showCursor,
    bool obscureText = false,
    bool autocorrect = true,
    bool enableSuggestions = true,
    bool autovalidate = false,
    bool maxLengthEnforced = true,
    int? maxLines = 1,
    int? minLines,
    Color? dividerColor,
    bool expands = false,
    int? maxLength,
    ValueChanged<String>? onChanged,
    GestureTapCallback? onTap,
    VoidCallback? onEditingComplete,
    ValueChanged<String>? onFieldSubmitted,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
    List<TextInputFormatter>? inputFormatters,
    bool enabled = true,
    double cursorWidth = 2.0,
    Radius? cursorRadius,
    Color? cursorColor,
    Brightness? keyboardAppearance,
    EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
    bool enableInteractiveSelection = true,
    InputCounterWidgetBuilder? buildCounter,
  }) : super(
    key: key,
    initialValue: controller != null ? controller!.text : (initialValue ?? ''),
    onSaved: onSaved,
    validator: validator,
    autovalidateMode: autovalidate ? AutovalidateMode.always : AutovalidateMode.disabled,
    enabled: enabled,
    builder: (FormFieldState<String> field) {
      final _MyTextFormFieldState state = field as _MyTextFormFieldState;
      final InputDecoration effectiveDecoration = (decoration ?? const InputDecoration())
          .applyDefaults(Theme.of(field.context).inputDecorationTheme);
      void onChangedHandler(String? value) {
        if (onChanged != null) {
          onChanged(value ?? '');
        }
        if (field.hasError) {
          field.validate();
        }
        field.didChange(value);
      }

      return TextField(
        controller: state._effectiveController,
        focusNode: focusNode,
        decoration: effectiveDecoration.copyWith(errorText: field.errorText),
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        style: style,
        strutStyle: strutStyle,
        textAlign: textAlign,
        textAlignVertical: textAlignVertical,
        textDirection: textDirection,
        textCapitalization: textCapitalization,
        autofocus: autofocus,
        toolbarOptions: toolbarOptions,
        readOnly: readOnly,
        showCursor: showCursor,
        obscureText: obscureText,
        autocorrect: autocorrect,
        enableSuggestions: enableSuggestions,
        maxLength: maxLength,
        maxLines: maxLines,
        minLines: minLines,
        expands: expands,
        onChanged: onChangedHandler,
        onTap: onTap,
        onEditingComplete: onEditingComplete,
        onSubmitted: onFieldSubmitted,
        inputFormatters: inputFormatters,
        enabled: enabled,
        cursorWidth: cursorWidth,
        cursorRadius: cursorRadius,
        cursorColor: cursorColor,
        scrollPadding: scrollPadding,
        keyboardAppearance: keyboardAppearance,
        enableInteractiveSelection: enableInteractiveSelection,
        buildCounter: buildCounter,
      );
    },
  );

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController] and
  /// initialize its [TextEditingController.text] with [initialValue].
  final TextEditingController? controller;

  @override
  _MyTextFormFieldState createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends FormFieldState<String> {
  TextEditingController? _controller;

  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;

  @override
  MyTextFormField get widget => super.widget as MyTextFormField;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
    } else {
      widget.controller!.addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(MyTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null)
        _controller = TextEditingController.fromValue(oldWidget.controller!.value);
      if (widget.controller != null) {
        setValue(widget.controller!.text);
        if (oldWidget.controller == null) _controller = null;
      }
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      _effectiveController!.text = widget.initialValue ?? '';
    });
  }

  void _handleControllerChanged() {
    // Suppress changes that originated from within this class.
    //
    // In the case where a controller has been passed in to this widget, we
    // register this change listener. In these cases, we'll also receive change
    // notifications for changes originating from within this class -- for
    // example, the reset() method. In such cases, the FormField value will
    // already have been set.
    if (_effectiveController!.text != value)
      didChange(_effectiveController!.text);
  }
}
