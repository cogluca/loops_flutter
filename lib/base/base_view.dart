import 'package:flutter/material.dart';
import 'package:loops/base/base_model.dart';
import 'package:loops/utils/locator.dart';
import 'package:provider/provider.dart';


class BaseView<T extends BaseModel> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget? child) builder;
  final Function(T) onModelReady;

  BaseView({required this.builder, required this.onModelReady});

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseModel> extends State<BaseView<T>> {
  T model = locator<T>();

  @override
  void initState() {
    if (widget.onModelReady != null) {
      widget.onModelReady(model);
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /*return ChangeNotifierProvider<T>(
      builder: (context) => model,
      child: Consumer<T>(builder: widget.builder),
    );*/
    return ChangeNotifierProvider<T>.value(

      //builder: (context) => model,
      child: Consumer<T>( builder: widget.builder), value: model,
    );
    //If value was to be kep as the locator it would be just a one way communication from event in view down to services, instead I need a ...
  }
}