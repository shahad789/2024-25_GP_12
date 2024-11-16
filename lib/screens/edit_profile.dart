import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import 'package:daar/screens/pass.dart'; // Import your PassPage here
import 'package:daar/usprovider/UserProvider.dart'; // Import your UserProvider here

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController DOBController = TextEditingController();

  String? phoneError;
  String? emailError;
  String? selectedGender; // default value
  DateTime? selectedDate;

  final List<String> genders = ['ذكر', 'أنثى']; // List of genders in Arabic

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (userProvider.userDocId != null) {
      try {
        var userData = await FirebaseFirestore.instance
            .collection('user')
            .doc(userProvider.userDocId!)
            .get();

        if (userData.exists) {
          setState(() {
            var data = userData.data() as Map<String, dynamic>;
            nameController.text = data['Name'] ?? '';
            phoneController.text = data['Phone'] ?? '';
            emailController.text = data['Email'] ?? '';
            DOBController.text = data['DateOfBirth'] != null
                ? DateFormat('yyyy-MM-dd')
                    .format(DateTime.parse(data['DateOfBirth']))
                : '';
            selectedGender = data['Gender'] ?? '';
            selectedDate = data['DateOfBirth'] != null
                ? DateTime.parse(data['DateOfBirth'])
                : null;
            _isLoading = false;
          });
        }
      } catch (e) {
        print('Error fetching user data: $e');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  bool _validateEmail(String email) {
    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    return RegExp(pattern).hasMatch(email);
  }

  bool _validatePhone(String phone) {
    String pattern =
        r'^05\d{8}$'; // Ensures phone starts with 05 and is 10 digits
    return RegExp(pattern).hasMatch(phone);
  }

  void _onPhoneChanged(String phone) {
    setState(() {
      phoneError = _validatePhone(phone)
          ? null
          : 'يجب أن يبدأ رقم الهاتف بـ05 ويكون مكوناً من 10 أرقام';
    });
  }

  void _onEmailChanged(String email) {
    setState(() {
      emailError = _validateEmail(email)
          ? null
          : 'البريد الإلكتروني غير صحيح, مثال: name@example.com';
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    if (userProvider.userDocId == null) {
      return Scaffold(
        body: Center(child: Text('User not logged in. Please login again.')),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0.0,
          backgroundColor: const Color(0xFF180A44),
          toolbarHeight: 70.0,
          centerTitle: true,
          title: const Text(
            'إعدادات الحساب',
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF180A44),
                      Color(0xFF180A44),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10.0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height - 90.0,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 30.0),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            _buildInputField(context, 'Name', Icons.person,
                                controller: nameController),
                            const SizedBox(height: 10),
                            _buildInputField(context, 'Phone', Icons.phone,
                                controller: phoneController,
                                errorText: phoneError,
                                inputType: TextInputType.phone,
                                onChanged: _onPhoneChanged),
                            const SizedBox(height: 10),
                            _buildInputField(context, 'Email', Icons.email,
                                controller: emailController,
                                errorText: emailError,
                                inputType: TextInputType.emailAddress,
                                onChanged: _onEmailChanged),
                            const SizedBox(height: 10),
                            _buildDateOfBirthPicker(context),
                            const SizedBox(height: 20),
                            _buildGenderDropdown(),
                            const SizedBox(height: 40),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _saveChanges,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF180A44),
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('حفظ'),
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const PassPage()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('إعادة تعيين كلمة المرور'),
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(BuildContext context, String label, IconData icon,
      {TextEditingController? controller,
      String? errorText,
      TextInputType? inputType,
      Function(String)? onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.grey, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: TextField(
                  controller: controller,
                  textAlign: TextAlign.right,
                  keyboardType: inputType, // Set the appropriate keyboard type
                  decoration: InputDecoration(
                    hintText: label,
                    errorText: errorText,
                  ),
                  onChanged: onChanged, // Trigger validation on change
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderDropdown() {
    return Container(
      padding: const EdgeInsets.only(right: 10.0),
      child: Row(
        children: [
          const Icon(
            Icons.arrow_drop_down,
            color: Colors.grey,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.black, width: 1.0)),
              ),
              child: DropdownButtonFormField<String>(
                value: selectedGender,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                isExpanded: true,
                items: genders.map((gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        gender,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedGender = value;
                  });
                },
                icon: SizedBox.shrink(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateOfBirthPicker(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DateTime? date = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (date != null) {
          setState(() {
            selectedDate = date;
            DOBController.text = DateFormat('yyyy-MM-dd').format(selectedDate!);
          });
        }
      },
      child: AbsorbPointer(
        child: _buildInputField(context, 'Date of Birth', Icons.cake,
            controller: DOBController),
      ),
    );
  }

  void _saveChanges() async {
    if (phoneError != null || emailError != null) {
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(Provider.of<UserProvider>(context, listen: false).userDocId!)
          .update({
        'Name': nameController.text,
        'Phone': phoneController.text,
        'Email': emailController.text,
        'Gender': selectedGender,
        'DateOfBirth': selectedDate?.toIso8601String(),
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('تم حفظ التعديلات بنجاح')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('حدث خطأ أثناء حفظ التعديلات، يرجى المحاولة لاحقاً')));
    }
  }
}
