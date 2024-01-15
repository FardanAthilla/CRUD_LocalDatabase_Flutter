import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notebook/DB/db_helper.dart';

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
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                id == null ? "Tambah Data" : "Perbarui Data",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _titleController,
                maxLength: 25,
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_titleController.text.isEmpty ||
                      _descController.text.isEmpty) {
                    Get.snackbar(
                      "Peringatan",
                      "Isi judul dan deskripsi terlebih dahulu",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  } else {
                    if (id == null) {
                      await _addData();
                    }
                    if (id != null) {
                      await _updateData(id);
                    }

                    _titleController.clear();
                    _descController.clear();

                    Get.back();
                    print("Operasi selesai");
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    id == null ? "Tambah Data" : "Perbarui Data",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
