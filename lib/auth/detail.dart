import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoleSeperationPage extends StatefulWidget {
  const RoleSeperationPage({super.key});

  @override
  State<RoleSeperationPage> createState() => _RoleSeperationPageState();
}

class _RoleSeperationPageState extends State<RoleSeperationPage> {
  String _selectedRole = 'student'; // Default role is student
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _collegeController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _organizationController = TextEditingController();
  TextEditingController _coordinatorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedRole = prefs.getString('selectedRole') ??
          'student'; 
    });
  }

  Future<void> _savePreferences(String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedRole', role);
    setState(() {
      _selectedRole = role;
    });

    // Navigate to respective page based on role
    switch (role) {
      case 'student':
        Navigator.pushReplacementNamed(context, '/student');
        break;
      case 'cattle_owner':
        Navigator.pushReplacementNamed(context, '/cattle_owner');
        break;
      case 'canteen_owner':
        Navigator.pushReplacementNamed(context, '/canteen_owner');
        break;
      case 'ngo':
        // Handle navigation or additional logic for NGO role
        break;
      default:
        // Navigate to default page or handle accordingly
        break;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _collegeController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _organizationController.dispose();
    _coordinatorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange, // fallback background color

      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/img/bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/img/logo.png'), // logo
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width *
                        0.8, // Adjusted width for responsiveness
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 20),
                            hintText: 'Choose a role',
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          dropdownColor:
                              Colors.orange[100], // Color when dropdown is open
                          value: _selectedRole,
                          onChanged: (value) {
                            _savePreferences(
                                value!); // Save selected role to preferences
                          },
                          items: [
                            DropdownMenuItem(
                              value: 'student',
                              child: Text('Student'),
                            ),
                            DropdownMenuItem(
                              value: 'cattle_owner',
                              child: Text('Cattle Owner'),
                            ),
                            DropdownMenuItem(
                              value: 'canteen_owner',
                              child: Text('Canteen Owner'),
                            ),
                            DropdownMenuItem(
                              value: 'ngo',
                              child: Text('NGO'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (_selectedRole == 'student') ...[
                          TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email ID',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _collegeController,
                            decoration: const InputDecoration(
                              labelText: 'College Name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _phoneController,
                            decoration: const InputDecoration(
                              labelText: 'Phone Number',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                        if (_selectedRole == 'cattle_owner') ...[
                          TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _phoneController,
                            decoration: const InputDecoration(
                              labelText: 'Phone Number',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _addressController,
                            decoration: const InputDecoration(
                              labelText: 'Address',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _cityController,
                            decoration: const InputDecoration(
                              labelText: 'City',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _stateController,
                            decoration: const InputDecoration(
                              labelText: 'State',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                        if (_selectedRole == 'canteen_owner') ...[
                          TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _phoneController,
                            decoration: const InputDecoration(
                              labelText: 'Phone Number',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _collegeController,
                            decoration: const InputDecoration(
                              labelText: 'College Name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _addressController,
                            decoration: const InputDecoration(
                              labelText: 'Address',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _cityController,
                            decoration: const InputDecoration(
                              labelText: 'City',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _stateController,
                            decoration: const InputDecoration(
                              labelText: 'State',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                        if (_selectedRole == 'ngo') ...[
                          TextField(
                            controller: _organizationController,
                            decoration: const InputDecoration(
                              labelText: 'Name of Organization',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email ID',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _phoneController,
                            decoration: const InputDecoration(
                              labelText: 'Phone Number',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _coordinatorController,
                            decoration: const InputDecoration(
                              labelText: 'Coordinator Number',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                        const SizedBox(height: 20), // Added space at the bottom
                        ElevatedButton(
                          onPressed: () {
                            // Handle save logic here
                            _saveData();
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.orange),
                          ),
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveData() {
    // Implement your save data logic here based on the role
    // Example:
    if (_selectedRole == 'student') {
      // Save student data
      // Navigate to student page
      Navigator.pushReplacementNamed(context, '/student');
    } else if (_selectedRole == 'cattle_owner') {
      // Save cattle owner data
      // Navigate to cattle owner page
      Navigator.pushReplacementNamed(context, '/cattle_owner');
    } else if (_selectedRole == 'canteen_owner') {
      // Save canteen owner data
      // Navigate to canteen owner page
      Navigator.pushReplacementNamed(context, '/canteen_owner');
    } else if (_selectedRole == 'ngo') {
      // Save NGO data
      // Navigate to NGO page or handle accordingly
    }
  }
}
