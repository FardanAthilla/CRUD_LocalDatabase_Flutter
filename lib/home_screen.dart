import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notebook/db_helper.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFECEAF4),
      appBar: AppBar(
        title: Text("CRUD Operations"),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: controller.allData.length,
                itemBuilder: (context, index) => Card(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    title: Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        controller.allData[index]['title'],
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    subtitle: Text(controller.allData[index]['desc']),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => controller.deleteDataAndShowSnackbar(
                          controller.allData[index]['id']),
                    ),
                  ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.showBottomSheet(null),
        child: Icon(Icons.add),
      ),
    );
  }
}

class HomeController extends GetxController {
  RxBool isLoading = true.obs;
  RxList<Map<String, dynamic>> allData = <Map<String, dynamic>>[].obs;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    refreshData();
  }

  void refreshData() async {
    final data = await SQLHelper.getA11Data();
    allData.assignAll(data);
    isLoading.value = false;
  }

  void deleteDataAndShowSnackbar(int id) async {
    await SQLHelper.deleteData(id);
    Get.snackbar(
      "Data Deleted",
      "Data has been deleted successfully",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
    );
    refreshData();
  }

  Future<void> _addData() async {
    final title = _titleController.text;
    final desc = _descController.text;

    await SQLHelper.createData(title, desc);
    refreshData();
  }

  Future<void> _updateData(int id) async {
    final title = _titleController.text;
    final desc = _descController.text;

    await SQLHelper.updateData(id, title, desc);
    refreshData();
  }

  void showBottomSheet(int? id) async {
    if (id != null) {
      final existingData = allData.firstWhere(
        (element) => element['id'] == id,
        orElse: () => {},
      );
      _titleController.text = existingData['title'];
      _descController.text = existingData['desc'];
    }

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(
          top: 30,
          right: 15,
          left: 15,
          bottom: MediaQuery.of(Get.context!).viewInsets.bottom + 30,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              id == null ? "Add Data" : "Update Data",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _descController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (id == null) {
                  await _addData();
                }
                if (id != null) {
                  await _updateData(id);
                }

                _titleController.clear();
                _descController.clear();

                Get.back();
                print("Operation completed");
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  id == null ? "Add Data" : "Update Data",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
