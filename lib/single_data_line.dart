import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class SingleDataLine<T> {
  StreamController<T> _streamController;

  T currentData;

  SingleDataLine([T initData]) {
    currentData = initData;
    _streamController = initData == null
        ? BehaviorSubject<T>()
        : BehaviorSubject<T>.seeded(initData);
  }

  get outer => _streamController.stream;

  get inner => _streamController.sink;

  void setData(T t){

    if (t == currentData) return;
    if (_streamController.isClosed) return;
    currentData = t;
    inner.add(t);
  }

  Widget addObserver(Widget Function(BuildContext context,T data) observer){
    return DataObserverWidget<T>(this,observer);
  }

  void dispose(){
    _streamController.close();
  }
  
}


class DataObserverWidget<T> extends StatefulWidget {

  SingleDataLine _dataLine;
  Function(BuildContext context,T data) _builder;

  DataObserverWidget(this._dataLine,this._builder);

  @override
  _DataObserverWidgetState createState() => _DataObserverWidgetState();
}

class _DataObserverWidgetState<T> extends State<DataObserverWidget<T>> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder(
      stream: widget._dataLine.outer,
      builder: (context, AsyncSnapshot<T> snapshot) {
        if (snapshot != null && snapshot.data != null) {
          return widget._builder(context, snapshot.data);
        } else {
          return Row();
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget._dataLine.dispose();
  }
}


