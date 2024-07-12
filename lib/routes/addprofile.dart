import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '/providers/user_provider.dart';
import '/src/theme.dart';
import '/src/datastorage.dart';
import '/src/widgets.dart';

Map? loggedinUser;
String? userFullName;
String? userID;
int? userAge;

class AddProfile extends StatefulWidget {
  const AddProfile({super.key});

  @override
  State<AddProfile> createState() => _AddProfileState();
}

class _AddProfileState extends State<AddProfile> {
  //Define a key for Add Profile form
  final addProfileFormKey = GlobalKey<FormBuilderState>();

  //Define list of 1 to 120
  List<DropdownMenuItem<int>> dropdownItems = List.generate(120, (index) {
    int number = index + 1;
    return DropdownMenuItem(
      value: number,
      child: Text(number.toString()),
    );
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: ListView(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 15),
                  const SizedBox(
                    width: 40,
                    child: Image(
                      image: AssetImage('assets/images/drawly.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(0),
                      width: double.infinity,
                      child: Text(
                        'Add Your Details',
                        style: AppTheme.text20Bold(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
              const SizedBox(height: 20),
              FormBuilder(
                key: addProfileFormKey,
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    //BUSINESS NAME
                    SizedBox(
                      width: double.infinity,
                      child: FormBuilderTextField(
                        name: 'fullname',
                        style: AppTheme.text14(),
                        decoration: AppTheme.greyfilled1OutlinedField(
                          'Your name name',
                        ),
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(
                                errorText: 'Please provide your name'),
                          ],
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(height: 20),

                    //STORE TYPE
                    SizedBox(
                      width: double.infinity,
                      child: FormBuilderDropdown<int>(
                        name: 'age',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
                        decoration:
                            AppTheme.greyfilled1OutlinedField('Your age'),
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(
                                errorText: 'Please select your age'),
                          ],
                        ),
                        items: dropdownItems,
                        valueTransformer: (val) => val?.toString(),
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(height: 20),

                    //CONTINUE BUTTON

                    InkWell(
                      child: AppTheme.blackButtonContainer('Continue'),
                      onTap: () async {
                        if (addProfileFormKey.currentState?.saveAndValidate() ??
                            false) {
                          debugPrint('Valid');

                          try {
                            String? fullName = addProfileFormKey
                                .currentState!.value['fullname']
                                .toString();

                            int? age = int.tryParse(addProfileFormKey
                                .currentState!.value['age']
                                .toString());

                            String userID = generateFormattedRandomString();

                            //Add data to profile data
                            Map<String, dynamic>? userData = {
                              'fullname': fullName,
                              'age': age,
                              'id': userID,
                            };

                            debugPrint('Profile data: $userData');

                            //ADD USER DATA TO PROVIDER
                            context.read<UserProvider>().setUser(userData);

                            //UPDATE USER DETAILS FILE
                            writeDetails(userData);

                            //Create empty drawings file
                            writeAllDrawings([]);

                            //GO TO CANVAS
                            if (mounted) {
                              context.go('/');
                            }
                          } catch (e) {
                            debugPrint(
                                'An error occurred while adding a user profile. Error: $e');
                          }
                        } else {
                          oneButtonReturnAlertDialog(context, 'Error?',
                              'Please provide all required information.');
                          debugPrint('Invalid');
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Function to generate 16 digit alpha-numeric code for user ID
String generateRandomString(int length) {
  const String chars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  Random random = Random();
  String randomString = String.fromCharCodes(Iterable.generate(
    length,
    (_) => chars.codeUnitAt(random.nextInt(chars.length)),
  ));
  return randomString;
}

//Function to format user id into 4 sets of number separated by dash (-)
String generateFormattedRandomString() {
  String randomString = generateRandomString(16);
  String formattedString = randomString
      .replaceAllMapped(RegExp(r".{4}"), (match) => '${match.group(0)}-')
      .substring(0, 19); // Ensuring to remove the trailing dash
  return formattedString;
}
