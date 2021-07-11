import 'package:flutter/material.dart';
import 'package:project_data_keuangan/db_helper/helper.dart';
import 'package:project_data_keuangan/models/dataModel.dart';
import 'dragView.dart';

class DailyOutcome extends StatefulWidget {
  @override
  _DailyOutcomeState createState() => _DailyOutcomeState();
}

class _DailyOutcomeState extends State<DailyOutcome> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  Future<List<Data>> data;
  String _studentName;
  bool isUpdate = false;
  int studentIdForUpdate;
  Helper helper;
  // final _studentNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    helper = Helper();
    // helper.drop();
    refreshStudentList();
  }

  refreshStudentList() {
    setState(() {
      data = helper.getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Outcome Total",
            style: TextStyle(fontSize: 20),
          ),
          Center(
              child: Text(
            "Rp 0",
            style: TextStyle(fontSize: 50),
          )),
          SizedBox(
            height: 30,
          ),
          Text(
            "Outcome Details",
            style: TextStyle(fontSize: 20),
          ),
          Expanded(
              child: FutureBuilder<List>(
            future: data,
            initialData: List(),
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? new ListView.builder(
                      padding: const EdgeInsets.all(10.0),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, i) {
                        return _buildRow(snapshot.data[i]);
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    );
            },
          )),
        ],
      ),
    );
  }

  Widget _buildRow(Data datas) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20)
                )
            ),
            context: context,
            builder: (context) => DragView(false, datas));
      },
      child: new Container(
        margin: EdgeInsets.only(bottom: 0,top: 10),
        padding: EdgeInsets.all(10),
        height: 60,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            Icon(
              Icons.assignment,
              // color: Colors.green,
              size: 30.0,
            ),
            SizedBox(
              width: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(datas.name),Spacer(), Text(datas.date),],
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                helper.delete(datas.id);
                refreshStudentList();
              },
            )
          ],
        ),
      ),

    );


  }

  Widget _popUp(){
    return new AlertDialog(
      title: const Text('AlertDialog Title'),
      content: SingleChildScrollView(
        child: ListBody(
          children: const <Widget>[
            Text('This is a demo alert dialog.'),
            Text('Would you like to approve of this message?'),
          ],
        ),
      ),

    );
  }



}
