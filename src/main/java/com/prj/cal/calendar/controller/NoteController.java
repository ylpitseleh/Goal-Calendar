package com.prj.cal.calendar.controller;

import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import net.sf.json.JSONArray;

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

	// @ResponseBody : 자바 객체를 HTTP 응답 객체로 전송할 수 있다.
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
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@RequestMapping("/test")
	public String memLogout(Note note) {
		return "test";
	}

	@RequestMapping("/testYL")
	public ModelAndView goToTestYL(Note note) {
		ModelAndView mav = new ModelAndView();

		try {
			//파라미터 Note note 추가했음
			List<Note> noteList = service.noteSearchAll();
			//noteList.getNoteProgress();
			for (int i = 0; i < noteList.size(); i++) {
				System.out.println("노트 내용 (" + i + ") : " + noteList.get(i).getNoteContent());
			}
			/* DB에 저장된 noteList를 Javascript에서 사용하기 위해 JSON으로 변환 */

			mav.addObject("jsonList", JSONArray.fromObject(noteList));
			mav.addObject("noteList", noteList);

			// noteList.getNoteProgress();
			for (int i = 0; i < noteList.size(); i++) {
				System.out.println("노트 내용 (" + i + ") : " + noteList.get(i).getNoteContent());
			}

			mav.addObject("noteList", noteList);
		} catch (NullPointerException e) {
			System.out.println("NullpointerException: There isn't any note in DB!");
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		mav.setViewName("testYL");
		return mav;
		// return "testYL";
	}

	// @RequestMapping("/testYL")
	// public String goToTestYL(Note note) {
	// 	return "testYL";
	// }

	// @RequestMapping(value = "/testYLReloadDBALL", method = RequestMethod.POST)
	// @ResponseBody
	// public void testYLReloadDBALL(Model model) {
	// 	try {
	// 		List<Note> noteList = service.noteSearchAll();

	// 		// noteList.getNoteProgress();
	// 		for (int i = 0; i < noteList.size(); i++) {
	// 			System.out.println("노트 내용 (" + i + ") : " + noteList.get(i).getNoteContent());
	// 		}

	// 		model.addAttribute("noteList", noteList);
	// 	} catch (NullPointerException e) {
	// 		System.out.println("NullpointerException: There isn't any note in DB!");
	// 		e.printStackTrace();
	// 	} catch (Exception e) {
	// 		e.printStackTrace();
	// 	}
	// }

	@RequestMapping(value = "/testYLReloadDBMatching", method = RequestMethod.POST)
	@ResponseBody
	public String testYLReloadDBMatching(Model model, HttpSession session, Member member, @RequestParam String year,
			@RequestParam String month, @RequestParam String day) {

		////////////////////////////////////////////////////////////////////////////////

		Note noteToSearch = new Note();

		try {
			member = (Member) session.getAttribute("member");
			noteToSearch.setNoteId(member.getMemId());
			noteToSearch.setNoteDate(year + "-" + month + "-" + day);
			// SELECT * FROM calendar WHERE noteId = ? AND noteDate = ?
			// 이므로, 아래의 값들은 필요 없다.
			// noteToSearch.setNoteProgress("");
			// noteToSearch.setNoteContent("");

			Note noteMatched = service.noteSearch(noteToSearch);
			System.out.println("Searched NoteId: " + noteToSearch.getNoteId());
			System.out.println("Searched NoteDate: " + noteToSearch.getNoteDate());

			if (noteMatched != null) {
				ArrayList<String> noteStr = new ArrayList<String>();
				noteStr.add(noteMatched.getNoteId());
				noteStr.add(noteMatched.getNoteDate());
				noteStr.add(Integer.toString(noteMatched.getNoteProgress()));
				noteStr.add(noteMatched.getNoteContent());

				System.out.println("Matched NoteId: " + noteStr.get(0));
				System.out.println("Matched NoteDate: " + noteStr.get(1));
				System.out.println("Matched NoteProgress: " + noteStr.get(2));
				System.out.println("Matched NoteContent: " + noteStr.get(3));

				String rtn = "";
				rtn += noteStr.get(0) + "|";
				rtn += noteStr.get(1) + "|";
				rtn += noteStr.get(2) + "|";
				rtn += noteStr.get(3);
				return rtn;
			}
		} catch (NullPointerException e) {
			System.out.println("NullpointerException: You need to login!");
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}

		System.out.println("There is no matching note in DB!");
		// System.out.println("Some error occured in NoteController testYLReloadDBMatching method");
		return "";
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

	@ModelAttribute("noteContent")
	public void getNoteProgress(Note note, HttpSession session) {

		/*
		 * List<Note> noteList = service.noteSearchAll(note);
		 *
		 * //noteList.getNoteProgress(); for(int i=0; i<noteList.size(); i++) {
		 * System.out.println("노트 내용 ("+i+") : "+noteList.get(i).getNoteContent()); }
		 */

	}

}
