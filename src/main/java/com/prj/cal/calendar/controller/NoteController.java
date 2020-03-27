package com.prj.cal.calendar.controller;

import java.text.DateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

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
	public void saveNote(Note note, Member member, HttpSession session) {
		// Member member 는 loginForm.jsp 를 통해서 값이 할당된 커맨드 객체이다. (다만, 값은 null로 가득 차있음.)
		// Note note는 testYL.jsp 를 통해서 값이 할당된 커맨드 객체이다. (다만, 값은 null로 가득 차있음.)

		// getAttribute() 는 리턴 타입이 Object이므로 사용시 실제 할당된 객체 타입으로 casting 해야 함.
		//
		// Object tmp_mem = session.getAttribute("member");
		// Member mem = (Member)tmp_mem;
		//
		member = (Member) session.getAttribute("member");

		try {
			note.setNoteId(member.getMemId()); // 현재 세션의 id값을 넣어줌.
			note.setNoteDate(new java.util.Date());

			service.noteRegister(note);
		} catch (NullPointerException e) {
			System.out.println("NullPointerException: You need to login!");
		} catch (Exception e) {
			e.printStackTrace();
		}
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
