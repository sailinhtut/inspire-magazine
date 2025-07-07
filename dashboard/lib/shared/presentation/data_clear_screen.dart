// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';


// class DataClearScreen extends StatefulWidget {
//   const DataClearScreen({super.key});

//   @override
//   State<DataClearScreen> createState() => _DataClearScreenState();
// }

// class _DataClearScreenState extends State<DataClearScreen> {
//   int totalBoard = 0;
//   int totalTimeline = 0;
//   int totalInventory = 0;

//   DateTime timelineDeleteStartDate = DateTime.now();
//   DateTime timelineDeleteEndDate = DateTime.now();

//   DateTime boardDeleteStartDate = DateTime.now();
//   DateTime boardDeleteEndDate = DateTime.now();

//   bool deleting = false;
//   int percentage = 0;
//   String prompt = "";

//   @override
//   void initState() {
//     super.initState();
//     getTotals();
//   }

//   @override
//   void setState(VoidCallback fn) {
//     if (mounted) super.setState(fn);
//   }

//   Future<void> getTotals() async {
//     // total board
//     final boardCollectionMeta = await FirebaseFirestore.instance.collection("BreedBoard").count().get();
//     totalBoard = boardCollectionMeta.count;

//     // total timeline
//     final timelineCollectionMeta = await FirebaseFirestore.instance.collection("Timeline").count().get();
//     totalTimeline = timelineCollectionMeta.count;

//     // total inventory
//     final inventoryCollectionMeta = await FirebaseFirestore.instance.collection("Inventory").count().get();
//     totalInventory = inventoryCollectionMeta.count;

//     setState(() {});
//   }

//   Future<void> _delete(String email, String password) async {
//     setState(() {
//       deleting = true;
//     });

//     int timelineDeleted = 0;
//     int boardDeleted = 0;

//     try {
//       await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then(
//         (credential) async {
//           // get user data
//           setMessage("User Identified");

//           // timeline delete
//           List<DateTime> allDates = timelineDeleteStartDate.day == timelineDeleteEndDate.day
//               ? [DateTime.now()]
//               : timelineController.dateRangeBetween(timelineDeleteStartDate, timelineDeleteEndDate);

//           setMessage("Deleting Timelines");
//           await Future.forEach(allDates, (date) async {
//             final parsedTime = timelineController.recordDateParser(date);
//             await FirebaseFirestore.instance.collection("Timeline").where("recordDate", isEqualTo: parsedTime).get().then((query) async {
//               await Future.forEach(query.docs, (doc) async {
//                 final timeline = Timeline.fromJson(doc.data());
//                 await FirebaseFirestore.instance.collection("Timeline").doc(doc.id).delete();
//                 setMessage("${timeline.name} is deleted");
//                 timelineDeleted++;
//               });
//             });
//           });

//           // board delete
//           // timeline delete
//           List<DateTime> allBoardDates = boardDeleteStartDate.day == boardDeleteEndDate.day
//               ? [DateTime.now()]
//               : timelineController.dateRangeBetween(boardDeleteStartDate, boardDeleteEndDate);

//           setMessage("Deleting Breed Boards");
//           await Future.forEach(allBoardDates, (date) async {
//             final parsedTime = breedController.recordMonthParser(date);
//             await FirebaseFirestore.instance.collection("BreedBoard").where("recordMonth", isEqualTo: parsedTime).get().then((query) async {
//               await Future.forEach(query.docs, (doc) async {
//                 final board = BreedBoard.fromJson(doc.data());
//                 await FirebaseFirestore.instance.collection("BreedBoard").doc(doc.id).delete();
//                 setMessage("${board.name} is deleted");
//                 boardDeleted++;
//               });
//             });
//           });

//           setMessage("Refreshing ...");
//           await timelineController.getTimelines();
//           await breedController.getBoards();
//           await inventoryController.getInventories();
//           await getTotals();

//           setMessage("Finished");
//           toast("$timelineDeleted timelines and $boardDeleted boards are deleted");
//         },
//       );
//     } on FirebaseAuthException catch (e) {
//       dd("[AuthController] Error while signing up : ${e.message}");
//       Get.snackbar("Error", e.message.toString());
//     } catch (e) {
//       dd("[AuthController] Error while logging in : $e");
//       toast("Something Went Wrong");
//     }
//     setState(() {
//       deleting = false;
//     });
//   }

//   void setMessage(String message) => setState(() => prompt = message);

//   Future<void> showPasswordConfirm() async {
//     final controller = TextEditingController();
//     final validatorKey = GlobalKey<FormFieldState>();

//     await showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//               title: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: const [Text("Enter Your Password")],
//               ),
//               titleTextStyle: TextStyle(
//                 fontSize: 18,
//                 color: Theme.of(context).primaryColor,
//                 fontWeight: FontWeight.w500,
//               ),
//               content: Column(
//                 children: [
//                   const Text(
//                     "To be sure you are owner. We need to confirm your identity.",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   const SizedBox(height: 10),
//                   TextInputWidget(
//                     key: validatorKey,
//                     controller: controller,
//                     useObsecure: true,
//                     maxLines: 1,
//                     hint: "Password",
//                   )
//                 ],
//               ),
//               backgroundColor: const Color(0xff333333),
//               scrollable: true,
//               titlePadding: const EdgeInsets.all(20).copyWith(bottom: 10, top: 15),
//               contentPadding: const EdgeInsets.all(20).copyWith(bottom: 10, top: 0),
//               actionsPadding: const EdgeInsets.only(bottom: 10, right: 10),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//               actions: [
//                 TextButton(
//                     style: TextButton.styleFrom(foregroundColor: Theme.of(context).primaryColor),
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: const Text("Cancel")),
//                 TextButton(
//                     style: TextButton.styleFrom(foregroundColor: Theme.of(context).primaryColor),
//                     onPressed: () async {
//                       if (validatorKey.currentState!.validate()) {
//                         final email = authController.currentUser.email!;
//                         final password = controller.text;
//                         Navigator.pop(context);

//                         _delete(email, password);
//                       }
//                     },
//                     child: const Text("Delete")),
//               ],
//             ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<InventoryController>(builder: (_, __, ___) {
//       return Scaffold(
//           body: SizedBox(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(14),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back)),
//                   const SizedBox(width: 10),
//                   Text("Clear Data", style: context.textTheme.headlineSmall),
//                 ],
//               ),
//               const SizedBox(height: 20),

//               // total widget
//               Container(
//                 width: 500,
//                 alignment: Alignment.topLeft,
//                 child: Column(
//                   children: [
//                     ListTile(
//                       title: const Text("Total Timelines"),
//                       trailing: Text("$totalTimeline records"),
//                     ),
//                     ListTile(
//                       title: const Text("Total Board"),
//                       trailing: Text("$totalBoard boards"),
//                     ),
//                     ListTile(
//                       title: const Text("Total Inventory"),
//                       trailing: Text("$totalInventory inventories"),
//                     )
//                   ],
//                 ),
//               ),
//               Divider(color: context.borderColor),
//               const SizedBox(height: 20),
//               Text("Choose Date Range to delete record", style: context.textTheme.titleMedium!.copyWith(color: Colors.red)),
//               const SizedBox(height: 20),
//               // delete range
//               Container(
//                 width: 500,
//                 alignment: Alignment.topLeft,
//                 child: Column(
//                   children: [
//                     const ListTile(
//                       title: Text("Timeline Start Date & End Date to delete"),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         const SizedBox(width: 20),
//                         OutlinedButton(
//                           style: OutlinedButton.styleFrom(
//                             side: const BorderSide(color: Colors.grey),
//                           ),
//                           onPressed: () async {
//                             final selectedDate = await showDatePicker(
//                                 context: context, initialDate: timelineDeleteStartDate, firstDate: DateTime(2023), lastDate: DateTime(2050));
//                             if (selectedDate != null) {
//                               setState(() {
//                                 timelineDeleteStartDate = selectedDate;
//                               });
//                             }
//                           },
//                           child: Text(DateFormat("MMM dd yyy").format(timelineDeleteStartDate), style: const TextStyle(color: Colors.red)),
//                         ),
//                         Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 10),
//                           child: const Icon(Icons.swap_horiz_rounded),
//                         ),
//                         OutlinedButton(
//                           style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.grey)),
//                           onPressed: () async {
//                             final selectedDate = await showDatePicker(
//                                 context: context, initialDate: timelineDeleteEndDate, firstDate: DateTime(2023), lastDate: DateTime(2050));
//                             if (selectedDate != null) {
//                               setState(() {
//                                 timelineDeleteEndDate = selectedDate;
//                               });
//                             }
//                           },
//                           child: Text(DateFormat("MMM dd yyy").format(timelineDeleteEndDate), style: const TextStyle(color: Colors.red)),
//                         )
//                       ],
//                     ),
//                     const ListTile(
//                       title: Text("Board Delete Date"),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         const SizedBox(width: 20),
//                         OutlinedButton(
//                           style: OutlinedButton.styleFrom(
//                             side: const BorderSide(color: Colors.grey),
//                           ),
//                           onPressed: () async {
//                             final selectedDate = await showDatePicker(
//                                 context: context, initialDate: boardDeleteStartDate, firstDate: DateTime(2023), lastDate: DateTime(2050));
//                             if (selectedDate != null) {
//                               setState(() {
//                                 boardDeleteStartDate = selectedDate;
//                               });
//                               // timelineController.getTimelinesMultiple(context, boardDeleteStartDate, timelineDeleteEndDate);
//                             }
//                           },
//                           child: Text(DateFormat("MMM dd yyy").format(boardDeleteStartDate), style: const TextStyle(color: Colors.red)),
//                         ),
//                         Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 10),
//                           child: const Icon(Icons.swap_horiz_rounded),
//                         ),
//                         OutlinedButton(
//                           style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.grey)),
//                           onPressed: () async {
//                             final selectedDate = await showDatePicker(
//                                 context: context, initialDate: boardDeleteEndDate, firstDate: DateTime(2023), lastDate: DateTime(2050));
//                             if (selectedDate != null) {
//                               setState(() {
//                                 boardDeleteEndDate = selectedDate;
//                               });
//                               // timelineController.getTimelinesMultiple(context, selectedFromDay, selectedToDay);
//                             }
//                           },
//                           child: Text(DateFormat("MMM dd yyy").format(boardDeleteEndDate), style: const TextStyle(color: Colors.red)),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 20),

//               Container(
//                 width: 500,
//                 alignment: Alignment.centerRight,
//                 child: deleting
//                     ? SizedBox(
//                         width: 200,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Text("$prompt  ${percentage > 0 && percentage <= 100 ? '$percentage %' : ''}"),
//                             const SizedBox(height: 10),
//                             const LinearProgressIndicator(color: Colors.red),
//                           ],
//                         ))
//                     : ElevatedButton(
//                         style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                         onPressed: () async {
//                           showConfirmDialog(context, title: "Confirm Delete", content: "Are you sure to delete ?", buttonText: "Continue",
//                               onConfirm: () async {
//                             Navigator.pop(context);
//                             showPasswordConfirm();
//                           });
//                         },
//                         child: const Text("Delete Records", style: TextStyle(color: Colors.white))),
//               ),
//             ],
//           ),
//         ),
//       ));
//     });
//   }
// }
