import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_data_keuangan/db_helper/helper.dart';
import 'package:project_data_keuangan/models/dataModel.dart';
import 'package:project_data_keuangan/main.dart';

class DragView extends StatefulWidget {
  DragView(this._isnew, this._dataPengeluaran);

  final bool _isnew;
  final Data _dataPengeluaran;

  @override
  _DragViewState createState() => _DragViewState();
}

class _DragViewState extends State<DragView> {
  DateTime _datePicked;
  String _chooseValue, name, nominal, date;
  Helper helper;
  final _outcomeName = TextEditingController();
  final _nominal = TextEditingController();
  int idUpdate;

  Data _data;
  var _date = new DateFormat('dd-MM-yyyy').format(DateTime.now());

  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now())
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _datePicked = value;
      });
    });
  }

  void initState() {
    super.initState();
    helper = Helper();
    if (widget._dataPengeluaran != null) {
      _data = widget._dataPengeluaran;
      _outcomeName.text = _data.name;
      _nominal.text = _data.nominal;
      _chooseValue = _data.category;
      date = _data.date;
    }
  }

  @override
  Widget build(BuildContext context) {


    FocusNode myFocusNode = new FocusNode();
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Padding(
        padding: EdgeInsets.only(top: 10, left: 20, right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 10,
              width: 50,
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'Input Outcome',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 15.0),
              child: TextField(
                controller: _outcomeName,
                decoration: InputDecoration(
                  labelText: "Outcome's name",
                  labelStyle: TextStyle(color: Colors.grey),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                onChanged: (value) {
                  name = _outcomeName.text;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 15.0),
              child: TextField(
                controller: _nominal,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Nominal",
                  labelStyle: TextStyle(color: Colors.grey),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                onChanged: (value) {
                  nominal = _nominal.text;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Center(
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(25)),
                  child: Center(
                    child: DropdownButton<String>(
                      value: _chooseValue,
                      //elevation: 5,
                      underline: SizedBox(),
                      isExpanded: true,
                      style: TextStyle(color: Colors.black),

                      items: <String>[
                        'Makanan & Minuman',
                        'Parkiran',
                        'Jalan-Jalan',
                        'Perlengkapan Sehari-hari',
                        'Sedekah',
                        'Lainnya',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      hint: Text(
                        "Category",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      onChanged: (String value) {
                        setState(() {
                          _chooseValue = value;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 30.0),
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(25)),
                child: Center(
                  child: Row(
                    children: <Widget>[
                      Text(
                        _datePicked == null
                            ? _date
                            : '${DateFormat('dd-MM-yyyy').format(_datePicked)}',
                        style: TextStyle(
                            color: _datePicked == null
                                ? Colors.grey
                                : Colors.black,
                            fontSize: 20),
                      ),
                      Spacer(),
                      FlatButton(
                        child: Text(
                          'Choose Date',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        textColor: Theme.of(context).accentColor,
                        onPressed: () => _showDatePicker(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 15.0),
              child: (widget._isnew)
                  ? RaisedButton(
                      padding: EdgeInsets.only(
                          bottom: 10, top: 10, right: 30, left: 30),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                      ),
                      onPressed: () => {
                        if (name != null &&
                            nominal != null &&
                            _chooseValue != null)
                          {
                            if (_datePicked != null)
                              {
                                date =
                                    DateFormat('dd-MM-yyyy').format(_datePicked)
                              }
                            else
                              {date = _date},
                            helper.add(Data(null, this.name, this.nominal,
                                this._chooseValue, this.date)),
                            Navigator.pop(context),
                            Navigator.pop(context),
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyApp()),
                            ),
                          }
                      },
                      textColor: Colors.white,
                      color: Colors.black,
                      child: Text(
                        'SAVE',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                          padding: EdgeInsets.only(
                              bottom: 10, top: 10, right: 30, left: 30),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                          ),
                          onPressed: () => {
                            if (name != _data.name ||
                                nominal != _data.nominal ||
                                _chooseValue != _data.category ||
                                date != _data.date)
                              {
                                if (_datePicked != null)
                                  {
                                    date = DateFormat('dd-MM-yyyy')
                                        .format(_datePicked)
                                  }
                                else
                                  {date = _date},

                                idUpdate = _data.id,
                                helper
                                    .update(Data(this.idUpdate, this.name, this.nominal,
                                    this._chooseValue, this.date))
                                    .then((data) {
                                  setState(() {
                                  });
                                }),


                                Navigator.pop(context),
                                Navigator.pop(context),
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyApp()),
                                ),
                              }
                          },
                          textColor: Colors.white,
                          color: Colors.green,
                          child: Text(
                            'SAVE',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        RaisedButton(
                          padding: EdgeInsets.only(
                              bottom: 10, top: 10, right: 30, left: 30),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                          ),
                          onPressed: () => {
                            helper.delete(_data.id),
                            Navigator.pop(context),
                            Navigator.pop(context),
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyApp()),
                            ),
                          },
                          textColor: Colors.white,
                          color: Colors.red,
                          child: Text(
                            'DELETE',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }
}
