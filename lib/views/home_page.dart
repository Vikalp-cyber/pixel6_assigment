import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel6_assigment/bloc/user_bloc.dart';
import 'package:pixel6_assigment/services/user_repository.dart';
import 'package:pixel6_assigment/utils/size.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPage = 1; // Current page number for pagination
  String? selectedCountry; // Selected country for filtering (currently not used)
  String? selectedGender; // Selected gender for filtering

  // Fetch the next page of users
  void _nextPage() {
    setState(() {
      currentPage++;
    });
    context.read<UserBloc>().add(FetchUsers(currentPage));
  }

  // Fetch the previous page of users
  void _previousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
      });
      context.read<UserBloc>().add(FetchUsers(currentPage));
    }
  }

  // Apply selected filters and update the BLoC state
  void _applyFilters() {
    context.read<UserBloc>().add(FilterUsers(
          // country: selectedCountry, // Commented out as country filter is not used
          gender: selectedGender,
        ));
  }

  @override
  void initState() {
    super.initState();
    // Fetch initial users on page load
    context.read<UserBloc>().add(FetchUsers(1));
  }

  @override
  Widget build(BuildContext context) {
    // Initialize screen size utility
    ScreenUtil.init(context);

    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: ScreenUtil.height(10),
          child: Image.network(
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcThMxm6lR5cfEOP2QwywfGpsNaDL4Fh8-uJ7Tfg4ahIB2-h8ctWWsV5XTrV1g6VFONwDow&usqp=CAU",
            fit: BoxFit.fill,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
              vertical: ScreenUtil.height(5), horizontal: ScreenUtil.width(2)),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Employees",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                  ),
                  Row(
                    children: [
                      // Dropdown for selecting country (not currently used)
                      DropdownButton<String>(
                        value: selectedCountry,
                        hint: const Text('Select Country'),
                        onChanged: (value) {
                          setState(() {
                            selectedCountry = value;
                            _applyFilters(); // Apply filters when country is selected
                          });
                        },
                        items: ['Dallas', 'Columbus', 'Phoenix']
                            .map((country) => DropdownMenuItem(
                                  value: country,
                                  child: Text(country),
                                ))
                            .toList(),
                      ),
                      SizedBox(
                        width: ScreenUtil.width(3),
                      ),
                      // Dropdown for selecting gender
                      DropdownButton<String>(
                        value: selectedGender,
                        hint: const Text('Select Gender'),
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value;
                            _applyFilters(); // Apply filters when gender is selected
                          });
                        },
                        items: ['male', 'female']
                            .map((gender) => DropdownMenuItem(
                                  value: gender,
                                  child: Text(gender),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: ScreenUtil.height(3)),
              BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  // Show a loading indicator if data is being fetched
                  if (state is UserLoading && currentPage == 1) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    );
                  } 
                  // Display user data if loaded successfully
                  else if (state is UserLoaded) {
                    return _buildtables(state);
                  } 
                  // Display error message if there was an issue
                  else if (state is UserError) {
                    return Center(
                      child: Text(state.message),
                    );
                  } 
                  // Show loading indicator if no other state is matched
                  else {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Column _buildtables(UserLoaded state) {
    return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(20)),
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('ID')),
                            DataColumn(label: Text('Image')),
                            DataColumn(label: Text('Full Name')),
                            DataColumn(label: Text('Gender')),
                            DataColumn(label: Text('Designation')),
                            DataColumn(label: Text('Location')),
                          ],
                          rows: state.filteredUsers.map((user) {
                            return DataRow(cells: [
                              DataCell(Text(user.id.toString())),
                              DataCell(Image.network(user.image,
                                  width: 50, height: 50)),
                              DataCell(
                                  Text('${user.firstName} ${user.lastName}')),
                              DataCell(Text(user.gender)),
                              DataCell(Text(user.designation)),
                              DataCell(Text(user.location)),
                            ]);
                          }).toList(),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: currentPage > 1 ? _previousPage : null,
                            child: const Text('Previous'),
                          ),
                          Text('Page $currentPage'),
                          ElevatedButton(
                            onPressed:
                                state.users.length == 10 ? _nextPage : null,
                            child: const Text('Next'),
                          ),
                        ],
                      ),
                    ],
                  );
  }
}
