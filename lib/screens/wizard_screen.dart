import 'package:flutter/material.dart';
import 'package:prompt_vault/services/ai_service.dart';
import 'package:prompt_vault/services/firestore_service.dart';

class WizardScreen extends StatefulWidget {
  final VoidCallback? onSaveSuccess;

  const WizardScreen({super.key, this.onSaveSuccess});

  @override
  State<WizardScreen> createState() => _WizardScreenState();
}

class _WizardScreenState extends State<WizardScreen> {
  // Store the currently visible page
  int _currentPage = 0;
  // Define a controller for the pageview
  final PageController _pageController = PageController(initialPage: 0);

  // Form Controllers
  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _contextController = TextEditingController();
  final TextEditingController _successController = TextEditingController();
  final TextEditingController _responseController = TextEditingController();

  // Services
  final AIService _aiService = AIService();
  final FirestoreService _firestoreService = FirestoreService();

  bool _isLoading = false;

  // Prompt Types
  String _selectedPromptType = 'Standard';
  final List<Map<String, String>> _promptTypes = [
    {
      'title': 'Standard',
      'description': 'Default, conversational, explanatory and non pretentious',
    },
    {
      'title': 'Professional',
      'description': 'Polished, formal, concise business-like language',
    },
    {
      'title': 'Step by step',
      'description': 'Instructional, guiding the reader through a process.',
    },
    {
      'title': 'Questions',
      'description': 'Frame the output as a Q&A or quiz-like format',
    },
  ];

  late List<OnboardingPageModel> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      OnboardingPageModel(
        title: 'Goal',
        description: 'What are you trying to accomplish?',
        imageUrl: 'https://i.ibb.co/cJqsPSB/scooter.png',
        bgColor: Colors.indigo,
        inputController: _goalController,
        inputLabel: 'Goal (Required)',
      ),
      OnboardingPageModel(
        title: 'Context',
        description: 'What does the AI need to know?',
        imageUrl: 'https://i.ibb.co/LvmZypG/storefront-illustration-2.png',
        bgColor: const Color(0xff1eb090),
        inputController: _contextController,
        inputLabel: 'Context',
      ),
      OnboardingPageModel(
        title: 'Success Criteria',
        description: 'What does success look like for you?',
        imageUrl: 'https://i.ibb.co/420D7VP/building.png',
        bgColor: const Color(0xfffeae4f),
        inputController: _successController,
        inputLabel: 'Success Criteria',
      ),
      OnboardingPageModel(
        title: 'Response Format',
        description: 'How should the AI respond?',
        imageUrl: 'https://i.ibb.co/cJqsPSB/scooter.png',
        bgColor: Colors.purple,
        // Removed controller, will use selection
        inputLabel: 'Response Format',
      ),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    _goalController.dispose();
    _contextController.dispose();
    _successController.dispose();
    _responseController.dispose();
    super.dispose();
  }

  void _handleSummarize() async {
    // Basic validation for required fields
    // Basic validation for required fields
    if (_goalController.text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill in the required fields.")),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final combinedInput =
        '''
      GOAL: ${_goalController.text}
      CONTEXT: ${_contextController.text}
      SUCCESS CRITERIA: ${_successController.text}
      RESPONSE FORMAT: $_selectedPromptType (See prompt type description below)
    ''';

    final responseMap = await _aiService.summarize(
      combinedInput,
      _selectedPromptType,
    );

    if (mounted) {
      final title = responseMap["title"]!;
      final body = responseMap["body"]!;

      try {
        await _firestoreService.savePrompt(title, body, _selectedPromptType);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Summary saved to Vault!")),
          );

          // Clear inputs
          _goalController.clear();
          _contextController.clear();
          _successController.clear();
          _responseController.clear();

          setState(() {
            _isLoading = false;
          });

          // Navigate back or call callback
          if (widget.onSaveSuccess != null) {
            widget.onSaveSuccess!();
          } else {
            Navigator.pop(context);
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Error saving to vault: $e")));
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        color: _pages[_currentPage].bgColor,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                // Pageview to render each page
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (idx) {
                    // Change current page when pageview changes
                    setState(() {
                      _currentPage = idx;
                    });
                  },
                  itemBuilder: (context, idx) {
                    final item = _pages[idx];
                    return SingleChildScrollView(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: Image.network(item.imageUrl),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      item.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: item.textColor,
                                          ),
                                    ),
                                  ),
                                  // NEW: Input Field injected here
                                  if (idx == 3)
                                    // Custom Selection for Step 4
                                    Container(
                                      height: 300,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24.0,
                                      ),
                                      child: ListView.separated(
                                        padding: EdgeInsets.zero,
                                        itemCount: _promptTypes.length,
                                        separatorBuilder: (ctx, i) =>
                                            const SizedBox(height: 8),
                                        itemBuilder: (ctx, i) {
                                          final type = _promptTypes[i];
                                          final isSelected =
                                              _selectedPromptType ==
                                              type['title'];
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _selectedPromptType =
                                                    type['title']!;
                                              });
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(
                                                12.0,
                                              ),
                                              decoration: BoxDecoration(
                                                color: isSelected
                                                    ? Colors.white.withOpacity(
                                                        0.2,
                                                      )
                                                    : Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                border: Border.all(
                                                  color: isSelected
                                                      ? Colors.white
                                                      : Colors.white
                                                            .withOpacity(0.3),
                                                  width: isSelected ? 2.0 : 1.0,
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    type['title']!,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    type['description']!,
                                                    style: TextStyle(
                                                      color: Colors.white
                                                          .withOpacity(0.9),
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  else
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24.0,
                                        vertical: 8.0,
                                      ),
                                      child: TextField(
                                        controller: item.inputController,
                                        style: TextStyle(color: item.textColor),
                                        decoration: InputDecoration(
                                          labelText: item.inputLabel,
                                          labelStyle: TextStyle(
                                            color: item.textColor.withOpacity(
                                              0.8,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: item.textColor.withOpacity(
                                                0.5,
                                              ),
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: item.textColor,
                                              width: 2.0,
                                            ),
                                          ),
                                        ),
                                        maxLines: 3,
                                      ),
                                    ),
                                  Container(
                                    constraints: const BoxConstraints(
                                      maxWidth: 280,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0,
                                      vertical: 16.0,
                                    ),
                                    child: Text(
                                      item.description,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: item.textColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Current page indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _pages
                    .map(
                      (item) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: _currentPage == _pages.indexOf(item) ? 30 : 8,
                        height: 8,
                        margin: const EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    )
                    .toList(),
              ),

              // Bottom buttons
              SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.comfortable,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        if (mounted) Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.comfortable,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        if (_currentPage == _pages.length - 1) {
                          _isLoading ? null : _handleSummarize();
                        } else {
                          _pageController.animateToPage(
                            _currentPage + 1,
                            curve: Curves.easeInOutCubic,
                            duration: const Duration(milliseconds: 250),
                          );
                        }
                      },
                      child: Row(
                        children: [
                          if (_isLoading)
                            const Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          Text(
                            _currentPage == _pages.length - 1
                                ? "Finish"
                                : "Next",
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            _currentPage == _pages.length - 1
                                ? Icons.done
                                : Icons.arrow_forward,
                          ),
                        ],
                      ),
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

class OnboardingPageModel {
  final String title;
  final String description;
  final String imageUrl;
  final Color bgColor;
  final Color textColor;
  final TextEditingController? inputController;
  final String? inputLabel;

  OnboardingPageModel({
    required this.title,
    required this.description,
    required this.imageUrl,
    this.bgColor = Colors.blue,
    this.textColor = Colors.white,
    this.inputController,
    this.inputLabel,
  });
}
