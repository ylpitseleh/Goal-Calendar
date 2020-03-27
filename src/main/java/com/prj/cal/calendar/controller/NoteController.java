package com.prj.cal.calendar.controller;

import java.text.DateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.prj.cal.calendar.Note;
import com.prj.cal.calendar.service.NoteService;
import com.prj.cal.member.Member;

@Controller
public class NoteController {

	@Autowired
	NoteService service;

	@ModelAttribute("cp")
	public String getContextPath(HttpServletRequest request) {
		return request.getContextPath();
	}

	@ModelAttribute("serverTime")
	public String getServerTime(Locale locale) {
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);

		return dateFormat.format(date);
	}

	
	
	@RequestMapping(value = "/saveNoteContent", method = RequestMethod.POST)
	@ResponseBody
	public void saveNote(Note note) {
		// 필요한 로직 처리
		service.noteRegister(note);
		System.out.println("in controller : " + note.getNoteContent());
	}
	
	
	
	
	
	@RequestMapping("/test")
	public String memLogout(Note note) {
		return "test";
	}

	@RequestMapping("/testYL")
	public String goToTestYL(Note note) {
		return "testYL";
	}

	@ModelAttribute("curYear")
	public String getCurYear(Locale locale) {
		int curYear_int;
		String curYear;

		Calendar calendar = new GregorianCalendar(Locale.KOREA);
		curYear_int = calendar.get(Calendar.YEAR);
		// Calendar cal = Calendar.getInstance(); // 현재 날짜와 시간
		curYear = Integer.toString(curYear_int);
		return curYear;
	}

	@ModelAttribute("curMonth")
	public String getCurMonth(Locale locale) {
		int curMonth_int;
		String curMonth;

		Calendar calendar = new GregorianCalendar(Locale.KOREA);
		curMonth_int = calendar.get(Calendar.MONTH) + 1;
		// Calendar cal = Calendar.getInstance(); // 현재 날짜와 시간
		curMonth = Integer.toString(curMonth_int);
		return curMonth;
	}

	@ModelAttribute("curDay")
	public String getCurDay(Locale locale) {
		int curDay_int;
		String curDay;

		Calendar calendar = new GregorianCalendar(Locale.KOREA);
		curDay_int = calendar.get(Calendar.DAY_OF_MONTH);
		curDay = Integer.toString(curDay_int);
		return curDay;
	}

}
