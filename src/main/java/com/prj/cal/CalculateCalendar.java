package com.prj.cal;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.Locale;

public class CalculateCalendar {
	//public static void main(String[] args) {
		// ��� ���� �Է� �޾� �޷��� ���
		/*
		int year, month;

		Calendar calendar = new GregorianCalendar(Locale.KOREA);
		year = calendar.get(Calendar.YEAR);
		month = calendar.get(Calendar.MONTH) + 1;

		Calendar cal = Calendar.getInstance(); // ���� ��¥�� �ð�

		// �ش� ���� ù��° ��¥�� ����
		// DAY_OF_WEEK
		cal.set(year, month - 1, 1);
		int dayOfweek = cal.get(Calendar.DAY_OF_WEEK) - 1; // 1~7 -> 0~6
		// int dayOfweek = (lastYear + leapYear_cnt + dayOfYear)%7;

		// ���� ���� ��¥ ��� ����
		// getActualMAXIMUM -> ���� ��ü�� �ִ밪 ��ȯ / getMAXIMUM -> ��ü ��, �ִ밪�� ��ȯ
		int lastday = cal.getActualMaximum(Calendar.DAY_OF_MONTH);

		System.out.printf("                     %d�� %02d��\n", year, month);
		System.out.printf("��\t��\tȭ\t��\t��\t��\t��\n");

		// ���� ���
		for (int i = 0; i < dayOfweek; i++) {
			System.out.print("\t");
		}
		// ��¥ ���
		for (int i = 1; i <= lastday; i++) {
			System.out.print(i + "\t");
			if ((dayOfweek + i) % 7 == 0) {
				System.out.println();
			}
		}
		*/
	//}

}
