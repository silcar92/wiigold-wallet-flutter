import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';

//? MODELS

//? IMAGES & COLORS

//? WIDGETS

//? OTHERS
import 'package:intl/intl.dart';
import 'package:wiigold/app/common/utils/extensions.dart';
import 'package:wiigold/app/data/models/entities/payments_model.dart';
import 'package:wiigold/app/modules/home/widgets/tab_transactions.dart';
import 'package:wiigold/theme/Colors.dart';

class PaymentList extends StatelessWidget {
  final List<Payment> payments;

  const PaymentList({super.key, required this.payments});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    if (payments.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Text(
            'loan.payment_list.no_payments_found'.tr,
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge?.copyWith(color: AppColors.main),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'loan.payment_list.payments_made_title'.tr,
          textAlign: TextAlign.start,
          style: textTheme.bodyLarge?.copyWith(color: AppColors.main),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: payments.length,
          itemBuilder: (context, index) {
            final payment = payments[index];

            return PaymentItem(
              payment: payment,
              onTap: () {
                print(
                  'Tapped on payment with reference: ${payment.payment_reference}',
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class PaymentItem extends StatelessWidget {
  final Payment payment;
  final VoidCallback? onTap;

  const PaymentItem({super.key, required this.payment, this.onTap});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    final String amountString = payment.amount_usd;
    final String dateTimeString = payment.payment_date;

    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 4.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'loan.payment_list.amount_in_usd'.trParams({
                            'amount': amountString
                                .toString()
                                .toHauvNumericString(decimals: 2),
                          }),
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.end,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Text(
                            dateTimeString,
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.dark3,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StatusLabelSwitcher(
                          status: payment.status.toLowerCase(),
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
}
