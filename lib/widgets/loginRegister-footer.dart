import 'package:flutter/material.dart';
import 'package:curiosityclash/theme.dart';

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0), // Menambahkan padding bawah
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "By clicking create account, you agree to recognise/n",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.darkTheme.primaryColor, // Warna teks biasa
              fontSize: 14,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Term of Use",
                style: TextStyle(
                  color: AppTheme
                      .darkTheme.primaryColor, // Warna teks untuk "Term of Use"
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  decoration: TextDecoration.underline, // Menggarisbawahi teks
                  decorationColor: AppTheme.darkTheme.primaryColor,
                ),
              ),
              Text(" and ",
                  style: TextStyle(
                      color: AppTheme.darkTheme.primaryColor, fontSize: 14)),
              Text("Privacy Policy",
                  style: TextStyle(
                    color: AppTheme.darkTheme
                        .primaryColor, // Warna teks untuk "Privacy Policy"
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    decoration:
                        TextDecoration.underline, // Menggarisbawahi teks
                    decorationColor: AppTheme.darkTheme
                        .primaryColor, // Mengatur warna underline sesuai dengan warna teks
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
