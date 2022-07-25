import 'package:flutter/material.dart';
import 'package:medical_app/medical_class.dart';
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
                itemCount: widget.medical.getCountInject(),
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: heightDevideMethod(0.04),
                    child: ListTile(
                      title: Text(
                        'Lần tiêm ${index + 1} : ${widget.medical.getItemListResultInjection(index)} - ${widget.medical.getCheckGlucozoIndex(index) ? "Đạt mục tiêu" : "  Không đạt"} ',
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      trailing: IconButton(
                        icon: Icon(index == widget.medical.getCountInject() - 1
                            ? Icons.restore
                            : Icons.info_outline_rounded),
                        tooltip: widget.medical.getTimeInjectItemList(index),
                        onPressed: () {
                          setState(() {
                            index == widget.medical.getCountInject() - 1
                                ? widget.medical.RemoveLastItemInjection()
                                : null;
                          });
                        },
                      ),
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
