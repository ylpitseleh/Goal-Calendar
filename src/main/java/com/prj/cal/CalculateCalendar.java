package com.prj.cal;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.Locale;

public class CalculateCalendar {
	//public static void main(String[] args) {
		// 년와 월을 입력 받아 달력을 출력
		/*
		int year, month;

		Calendar calendar = new GregorianCalendar(Locale.KOREA);
		year = calendar.get(Calendar.YEAR);
		month = calendar.get(Calendar.MONTH) + 1;

		Calendar cal = Calendar.getInstance(); // 현재 날짜와 시간

		// 해당 월의 첫번째 날짜의 요일
		// DAY_OF_WEEK
		cal.set(year, month - 1, 1);
		int dayOfweek = cal.get(Calendar.DAY_OF_WEEK) - 1; // 1~7 -> 0~6
		// int dayOfweek = (lastYear + leapYear_cnt + dayOfYear)%7;

		// 월에 따른 날짜 출력 조건
		// getActualMAXIMUM -> 현재 객체의 최대값 반환 / getMAXIMUM -> 전체 중, 최대값만 반환
		int lastday = cal.getActualMaximum(Calendar.DAY_OF_MONTH);

		System.out.printf("                     %d년 %02d월\n", year, month);
		System.out.printf("일\t월\t화\t수\t목\t금\t토\n");

		// 공백 출력
		for (int i = 0; i < dayOfweek; i++) {
			System.out.print("\t");
		}
		// 날짜 출력
		for (int i = 1; i <= lastday; i++) {
			System.out.print(i + "\t");
			if ((dayOfweek + i) % 7 == 0) {
				System.out.println();
			}
		}
		*/
	//}

}
