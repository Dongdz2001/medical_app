import 'package:flutter/material.dart';
import 'package:medical_app/NDDTM_medical/medical_class.dart';
import 'package:medical_app/sizeDevide.dart';

class HistoryScreen extends StatefulWidget {
  final Medical medical;
  const HistoryScreen({Key? key, required this.medical}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử theo dõi'),
        backgroundColor: Color(0xff091a31),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              style: Theme.of(context).textTheme.headline1,
              '${widget.medical.getNamePD}',
              textAlign: TextAlign.center,
            ),
            Text('Thời gian bắt đầu : ${widget.medical.getTimeStart}'),
            Text('Thông tin chi tiết:'),
            Expanded(
              child: ListView.builder(
                itemCount: widget.medical.lengthListHistoryInjection(),
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      ((widget.medical.listHistoryInjection[index] != -1) &&
                              (widget.medical.listHistoryInjection[index] !=
                                  -2) &&
                              (widget.medical.listHistoryInjection[index] !=
                                  -3))
                          ? "${widget.medical.listHistoryTimeInjection[index]} : glucose ${widget.medical.listHistoryInjection[index]} (mol/l) \n ${widget.medical.listOldSolveHistory[index]}  --------------------------------------------------------- " //${widget.medical.getCheckGlucozoIndex(index) ? " mục tiêu " : " Không đạt "}
                          : "${widget.medical.listHistoryTimeInjection[index]} : \n ",
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
