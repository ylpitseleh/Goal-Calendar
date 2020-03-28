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
		// Member member 는 아무런 값도 할당되지 않은 커맨드 객체이다. (Null값만 들어있는 상태)
		// Note note는 testYL.jsp 에서 ajax를 활용하여 값이 채워진 커맨드 객체이다.

		// getAttribute() 는 리턴 타입이 Object이므로 사용시 실제 할당된 객체 타입으로 casting 해야 함.
		member = (Member) session.getAttribute("member");
		// loginForm.jsp 에서
		// form을 작성하고 submit 함으로써
		// MemberController.java에 member 커맨드 객체가 생성되었고,
		//
		// MemberController.java 에서
		// session.setAttribute("member", service.memberSearch(member));을 함으로써
		// Session에 member 라는 객체가 등록되었다. (memberSearch 결과가 null이면 loginForm으로 다시 이동)
		//
		// 그리고 여기서
		// member = (Member) session.getAttribute("member"); 을 함으로써
		// Session에 등록된 member 객체의 값을, 아직 아무런 값도 할당되지 않은 member 커맨드 객체에 넣어주었다.
		//
		// 참고로, jsp에서,
		// ${value}는
		// @ModelAttribute("value") 등의 방식으로 Model에 등록된 어떠한 값으로 parse 된다.
		// ${member.memId}는
		// Session에 등록된 member 객체의 memId 값으로 parse 된다.
		// ???는
		// Command Object로 등록된 member 객체의 memId 값으로 parse 될 것이다. 필요하다면 찾아보자.

		try {
			System.out.println("=== In NoteController.java ===");

			System.out.println("--- note: command object by ajax at testYL.jsp ---");
			System.out.println("note.noteId       : " + note.getNoteId());
			System.out.println("note.noteDate     : " + note.getNoteDate());
			System.out.println("note.noteProgress : " + note.getNoteProgress());
			System.out.println("note.noteContent  : " + note.getNoteContent());

			System.out.println("--- member: session by memLogin method at MemberController.java ---");
			System.out.println("member.memId (in session member by ): " + member.getMemId());
			System.out.println("member.memPw (in session member by ): " + member.getMemPw());
			System.out.println("member.memMail (in session member by ): " + member.getMemMail());
			System.out.println("===============================");

			service.noteRegister(note);

			// session에 등록하면 jsp에서 ${note.noteId} 등으로 값을 불러올 수 있음.
			session.setAttribute("note", note);
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
	// public String goToTestYL(Note note) {
	public String goToTestYL() {
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
