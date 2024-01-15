import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notebook/Controller/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECEAF4),
      appBar: AppBar(
        title: const Text("CRUD Operations"),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : controller.allData.isEmpty
                ? const Center(
                    child: Text(
                      "Tidak ada data",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: controller.allData.length,
                    itemBuilder: (context, index) => Card(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            controller.allData[index]['title'],
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        subtitle: Text(controller.allData[index]['desc']),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => controller.deleteDataAndShowSnackbar(
                              controller.allData[index]['id']),
                        ),
                      ),
                    ),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.showBottomSheet(null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
