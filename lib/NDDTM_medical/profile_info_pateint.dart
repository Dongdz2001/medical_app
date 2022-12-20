import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical_app/sizeDevide.dart';
import 'package:medical_app/manage_patient/manager.dart';
import 'package:medical_app/manage_patient/patient.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ProfileInfo extends StatefulWidget {
  final Object? patienTemp;
  final int? index;
  final List<double?> listValueGluco;
  final List<String?> listTimeGluco;
  final bool? checkGroupOrPersonal; // false = person. true = group
  final String? keycode;
  const ProfileInfo({
    Key? key,
    required this.checkGroupOrPersonal,
    required this.patienTemp,
    required this.index,
    required this.listTimeGluco,
    required this.listValueGluco,
    required this.keycode,
  }) : super(key: key);
  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  late String keycode;
  late Patien patienTemp;
  late int index;
  late List<double?> listValueGluco;
  late List<String?> listTimeGluco;
  late bool _checkGroupOrPersonal;
  List<SalesData> listDataChart = [];
  TooltipBehavior? _tooltipBehavior;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  TextEditingController diseaseControler = TextEditingController();
  TextEditingController nameControler = TextEditingController();
  TextEditingController identityCardControler = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    keycode = this.widget.keycode!;
    _checkGroupOrPersonal = this.widget.checkGroupOrPersonal!;
    patienTemp = widget.patienTemp! as Patien;
    index = widget.index!;
    listValueGluco = widget.listValueGluco;
    listTimeGluco = widget.listTimeGluco;
    _tooltipBehavior = TooltipBehavior(enable: true);
    _initDataChart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff091a31),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: TextButton(
              child: const Text(
                'Lưu',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                // print(
                //     "information: ${diseaseControler.text} - ${nameControler.text} - ${identityCardControler.text} - ${genderController.text} - ${dateController.text} - ${phoneController.text}");
                patienTemp.name = nameControler.text;
                patienTemp.gender = genderController.text == ''
                    ? 'unknow'
                    : genderController.text;
                patienTemp.birthday = dateController.text;
                try {
                  patienTemp.veryfileID = identityCardControler.text.toString();
                } catch (e) {
                  print('casting error');
                }
                patienTemp.phoneNum = phoneController.text;
                patienTemp.nameDisease = diseaseControler.text;
                patienTemp.old = _caculateOld(dateController.text);
                patienTemp.weight = double.parse(weightController.text);
                _checkGroupOrPersonal
                    ? patienTemp.saveDataPatient(
                        _checkGroupOrPersonal, patienTemp.keyLogin!, false,
                        keyCodeGroup: keycode)
                    : patienTemp.saveDataPatient(
                        _checkGroupOrPersonal, patienTemp.keyLogin!, false);
                _checkGroupOrPersonal
                    ? Manager(key: patienTemp.keyLogin!)
                        .upDateNameIndexListInfoFireStore(
                            index, patienTemp.name!)
                    : Manager(key: patienTemp.keyLogin!)
                        .upDateNameIndexListInfo(index, patienTemp.name!);

                Navigator.pop(context, true);
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // image profile
              Container(
                alignment: Alignment.topCenter,
                color: Color.fromARGB(255, 217, 220, 225),
                height: heightDevideMethod(0.4),
                width: widthDevide,
                child: SfCartesianChart(
                    enableAxisAnimation: true,
                    primaryXAxis: CategoryAxis(
                      interval: 1,
                      autoScrollingDelta: 4,
                      majorGridLines: MajorGridLines(width: 0),
                      majorTickLines: MajorTickLines(width: 0),
                      // labelPosition: ChartDataLabelPosition.inside,
                      // tickPosition: TickPosition.inside,
                      // edgeLabelPlacement: EdgeLabelPlacement.shift,
                    ),
                    primaryYAxis: NumericAxis(
                        minimum: 0,
                        maximum: 20,
                        plotBands: [
                          PlotBand(
                              isVisible: true,
                              // provided the same y-value to start and end property in order to render the plotline for that y-value.
                              start: 3.9,
                              end: 8.3,
                              borderWidth: 1,
                              color: Color.fromARGB(255, 190, 254, 118),
                              borderColor: Color.fromARGB(255, 29, 226, 35),
                              // Label text for the reference plot line
                              textStyle: TextStyle(color: Colors.green),
                              // provided dash array to render the line in dashed format.
                              dashArray: <double>[10, 10])
                        ],
                        majorGridLines: MajorGridLines(
                          width: 0,
                        )),
                    zoomPanBehavior: ZoomPanBehavior(
                      enablePanning: true,
                    ),
                    // Chart title
                    title: ChartTitle(
                      text: 'Đường máu mao mạch',
                      alignment: ChartAlignment.center,
                    ),
                    // Enable legend
                    legend: Legend(
                      isVisible: true,
                      // Border color and border width of legend
                      offset: Offset(10, -100),
                    ),
                    // Enable tooltip
                    tooltipBehavior: _tooltipBehavior!,
                    series: <LineSeries<SalesData, String>>[
                      LineSeries<SalesData, String>(
                          dataSource: listDataChart,
                          name: 'Gluco(mol/kg)',
                          xValueMapper: (SalesData sales, _) => sales.year,
                          yValueMapper: (SalesData sales, _) => sales.sales,
                          // Enable data label
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          animationDelay: 250)
                    ]),
              ),
              SizedBox(height: heightDevideMethod(0.02)),
              buildUserInfoDisplay(diseaseControler, 'Chuẩn đoán bệnh',
                  patienTemp.nameDisease.toString(), 'Tiểu Đường'),
              buildUserInfoDisplay(nameControler, 'Tên bệnh nhân',
                  patienTemp.getName, 'Nguyễn Kièu Anh'),
              buildUserInfoDisplay(
                  identityCardControler,
                  'Mã bệnh nhân',
                  '${patienTemp.getID}',
                  '001201007111',
                  TextInputType.number,
                  false),
              buildUserInfoDisplay(phoneController, 'Số điện thoại',
                  patienTemp.getPhoneNum, '0348807912', TextInputType.number),
              buildUserInfoDisplay(
                  genderController,
                  'Giới Tính',
                  '${patienTemp.gender == 'unknow' ? '' : patienTemp.gender.toString()}',
                  'Nữ'),
              buildUserInfoDisplay(weightController, 'Cân nặng (Kg)',
                  patienTemp.weight.toString(), '60', TextInputType.number),
              buildUserInfoDisplay(dateController, 'Ngày Sinh',
                  patienTemp.getBirthday, '04/01/2001', TextInputType.datetime),
            ],
          ),
        ),
      ),
    );
  }

  // Widget builds the display item with the proper formatting to display the user's info
  Widget buildUserInfoDisplay(TextEditingController editControler, String title,
      String value, String hint,
      [TextInputType textInput = TextInputType.text, bool enable = true]) {
    editControler.text = value;
    editControler.selection = TextSelection.fromPosition(
        TextPosition(offset: editControler.text.length));
    return Padding(
        padding: EdgeInsets.only(bottom: 10, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            TextField(
              enabled: enable,
              keyboardType: textInput,
              controller: editControler,
              cursorColor: Colors.black,
              decoration: new InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.only(bottom: 11),
                  hintText: "$hint"),
            ),
            Container(
              color: Colors.grey[400],
              height: 1,
              width: widthDevideMethod(0.85),
            ),
          ],
        ));
  }

  Future<void> _pickImageCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image != null) {
        return;
      }
      // final imageTemporary = File(image!.path);
      setState(() {
        this._image = File(image!.path);
      });
    } catch (e) {
      print("Failed to pick image: $e");
    }
  }

  Future<void> getLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      this._image = File(response.file!.path);
    } else {
      // _handleError(response.exception);
    }
  }

  int _caculateOld(String dateStr) {
    // DateTime dateTime = DateTime.now().year;
    try {
      return DateTime.now().year -
          int.parse(dateStr.substring(dateStr.length - 4));
    } catch (e) {
      print("Casting date error");
    }
    return -1;
  }

  void _initDataChart() {
    for (var i = 0; i < listValueGluco.length; i++) {
      SalesData temp = SalesData(listTimeGluco[i]!, listValueGluco[i]!);
      this.listDataChart.add(temp);
    }
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
