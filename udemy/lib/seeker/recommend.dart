import 'package:flutter/material.dart';

class JobSearchPage extends StatefulWidget {
  @override
  _JobSearchPageState createState() => _JobSearchPageState();
}

class _JobSearchPageState extends State<JobSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _allJobs = [
    {'title': 'Software Engineer', 'description': 'Develop software solutions.'},
    {'title': 'Data Scientist', 'description': 'Analyze data to gain insights.'},
    {'title': 'Product Manager', 'description': 'Manage product development.'},
    {'title': 'Designer', 'description': 'Create design assets for projects.'},
  ];
  List<Map<String, String>> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchResults = _allJobs;
  }

  void _searchJobs(String query) {
    final results = _allJobs.where((job) {
      final title = job['title']!.toLowerCase();
      final description = job['description']!.toLowerCase();
      final searchQuery = query.toLowerCase();
      return title.contains(searchQuery) || description.contains(searchQuery);
    }).toList();

    setState(() {
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search for jobs...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white54),
          ),
          style: TextStyle(color: Colors.white, fontSize: 18.0),
          onChanged: _searchJobs,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              _searchJobs('');
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final job = _searchResults[index];
          return ListTile(
            title: Text(job['title']!),
            subtitle: Text(job['description']!),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}