import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/expense_provider.dart';
import '../../../domain/entities/expense_entity.dart';

class AddExpensePage extends ConsumerStatefulWidget {
  const AddExpensePage({super.key});

  @override
  ConsumerState<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends ConsumerState<AddExpensePage> {
  final title = TextEditingController();
  final amount = TextEditingController();
  final List<String> categories = const [
    'Groceries',
    'Food',
    'Transport',
    'Shopping',
    'Bills',
  ];

  String selectedCategory = 'Groceries';
  int selectedDateIndex = 0;
  DateTime selectedDate = DateTime.now();

  static const Color _bgColor = Color(0xFFF5F7FB);
  static const Color _fieldColor = Color(0xFFF2F3F7);
  static const Color _primaryBlue = Color(0xFF5B67FF);
  static const Color _primaryPurple = Color(0xFF7C83FD);

  @override
  void dispose() {
    title.dispose();
    amount.dispose();
    super.dispose();
  }

  Future<void> save() async {
    final parsedAmount = double.tryParse(amount.text.trim());

    if (title.text.trim().isEmpty || parsedAmount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid title and amount.')),
      );
      return;
    }

    try {
      await ref
          .read(expenseProvider.notifier)
          .addExpense(
            ExpenseEntity(
              id: DateTime.now().toString(),
              title: title.text.trim(),
              amount: parsedAmount,
              category: selectedCategory,
              date: selectedDate,
            ),
          );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save expense: $e')));
      return;
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  List<DateTime> get _dateOptions {
    final now = DateTime.now();
    return [
      now,
      now.subtract(const Duration(days: 1)),
      now.subtract(const Duration(days: 2)),
    ];
  }

  String _weekdayShort(DateTime date) {
    const days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    return days[date.weekday - 1];
  }

  String _displayAmount() {
    final value = double.tryParse(amount.text.trim()) ?? 0;
    return value.toStringAsFixed(2);
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        selectedDateIndex = -1;
      });
    }
  }

  Widget _buildLabeledFieldTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.1,
        color: Color(0xFF8D95A5),
      ),
    );
  }

  Widget _buildDateChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          height: 50,
          decoration: BoxDecoration(
            gradient: selected
                ? const LinearGradient(colors: [_primaryBlue, _primaryPurple])
                : null,
            color: selected ? null : _fieldColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: selected
                ? const [
                    BoxShadow(
                      color: Color(0x335B67FF),
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ]
                : const [],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : const Color(0xFF7D8798),
              letterSpacing: 0.6,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateOptions = _dateOptions;

    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Add Expense',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1B2230),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz_rounded),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFE8ECF4)),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Column(
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDEFFF),
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x14000000),
                          blurRadius: 14,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_rounded,
                      color: _primaryBlue,
                      size: 38,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'NEW TRANSACTION',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      color: Color(0xFF9AA3B2),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x120C1A4B),
                          blurRadius: 28,
                          offset: Offset(0, 14),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(child: _buildLabeledFieldTitle('AMOUNT')),
                        const SizedBox(height: 8),
                        Center(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: '₹ ',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF222B3B),
                                  ),
                                ),
                                TextSpan(
                                  text: _displayAmount(),
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 34,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF121A2B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: amount,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: 'Enter amount',
                            prefixIcon: const Icon(
                              Icons.currency_rupee,
                              size: 15,
                            ),
                            filled: true,
                            fillColor: _fieldColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Color(0x335B67FF),
                                width: 1.5,
                              ),
                            ),
                            hintStyle: const TextStyle(
                              fontFamily: 'Poppins',
                              color: Color(0xFFA0A9B8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        _buildLabeledFieldTitle('TITLE'),
                        const SizedBox(height: 8),
                        TextField(
                          controller: title,
                          decoration: InputDecoration(
                            hintText: 'What did you buy?',
                            prefixIcon: const Icon(
                              Icons.edit_note_rounded,
                              size: 20,
                            ),
                            filled: true,
                            fillColor: _fieldColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Color(0x335B67FF),
                                width: 1.5,
                              ),
                            ),
                            hintStyle: const TextStyle(
                              fontFamily: 'Poppins',
                              color: Color(0xFFA0A9B8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        _buildLabeledFieldTitle('CATEGORY'),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: _fieldColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedCategory,
                              icon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                              ),
                              isExpanded: true,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 15,
                                color: Color(0xFF2A3445),
                              ),
                              borderRadius: BorderRadius.circular(15),
                              onChanged: (value) {
                                if (value == null) return;
                                setState(() => selectedCategory = value);
                              },
                              items: categories
                                  .map(
                                    (category) => DropdownMenuItem(
                                      value: category,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.category_outlined,
                                            size: 18,
                                            color: Color(0xFF738099),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(category),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildLabeledFieldTitle('TRANSACTION DATE'),
                            TextButton(
                              onPressed: _pickDate,
                              style: TextButton.styleFrom(
                                foregroundColor: _primaryBlue,
                                textStyle: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              child: const Text('View Calendar'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _buildDateChip(
                              label: 'TODAY',
                              selected: selectedDateIndex == 0,
                              onTap: () {
                                setState(() {
                                  selectedDateIndex = 0;
                                  selectedDate = dateOptions[0];
                                });
                              },
                            ),
                            const SizedBox(width: 10),
                            _buildDateChip(
                              label:
                                  '${_weekdayShort(dateOptions[1])} ${dateOptions[1].day}',
                              selected: selectedDateIndex == 1,
                              onTap: () {
                                setState(() {
                                  selectedDateIndex = 1;
                                  selectedDate = dateOptions[1];
                                });
                              },
                            ),
                            const SizedBox(width: 10),
                            _buildDateChip(
                              label:
                                  '${_weekdayShort(dateOptions[2])} ${dateOptions[2].day}',
                              selected: selectedDateIndex == 2,
                              onTap: () {
                                setState(() {
                                  selectedDateIndex = 2;
                                  selectedDate = dateOptions[2];
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [_primaryBlue, _primaryPurple],
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x3B5B67FF),
                                  blurRadius: 16,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: save,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Text(
                                'Save Expense',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'A copy of this transaction will be automatically categorized and synced with your weekly budget goals.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: Color(0xFF97A1B2),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
