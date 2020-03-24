package com.prj.cal.calendar.controller;

import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.prj.cal.calendar.Note;
import com.prj.cal.calendar.service.NoteService;

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

	@RequestMapping("/test")
	public String memLogout(Note note) {
		return "test";
	}

	// // Prototype Modal
	// @RequestMapping(value = "/note/openModal", method = RequestMethod.POST)
	// public ModelAndView openModal(HttpServletRequest request) {

	// HttpSession session = request.getSession();
	// Note note = (Note) session.getAttribute("note");

	// ModelAndView mav = new ModelAndView();
	// mav.addObject("note", service.noteSearch(note));
	// mav.setViewName("/note/openModal");

	// return mav;
	// }

	// // Login
	//
	// @RequestMapping("/loginForm")
	// public String loginForm(Note note) {
	// return "/note/loginForm";
	// }
	//
	// @RequestMapping(value = "/login", method = RequestMethod.POST)
	// public String memLogin(Note note, HttpSession session) {
	//
	// Note mem = service.noteSearch(note);
	// if (mem == null)
	// return "/note/loginForm";
	//
	// session.setAttribute("note", mem);
	//
	// return "/note/loginOk";
	// }
	//
	// // Logout
	//
	// @RequestMapping("/logout")
	// public String memLogout(Note note, HttpSession session) {
	//
	// session.invalidate();
	//
	// return "/note/logoutOk";
	// }
	//
	// // Modify
	//
	// @RequestMapping(value = "/modifyForm")
	// public ModelAndView modifyForm(HttpServletRequest request) {
	//
	// HttpSession session = request.getSession();
	// Note note = (Note) session.getAttribute("note");
	//
	// ModelAndView mav = new ModelAndView();
	// mav.addObject("note", service.noteSearch(note));
	//
	// mav.setViewName("/note/modifyForm");
	//
	// return mav;
	// }
	//
	// @RequestMapping(value = "/modify", method = RequestMethod.POST)
	// public ModelAndView modify(Note note, HttpServletRequest request) {
	//
	// ModelAndView mav = new ModelAndView();
	// HttpSession session = request.getSession();
	//
	// Note mem = service.noteModify(note);
	// if (mem == null) {
	// mav.setViewName("/note/modifyForm");
	// } else {
	// session.setAttribute("note", mem);
	//
	// mav.addObject("memAft", mem);
	// mav.setViewName("/note/modifyOk");
	// }
	//
	// return mav;
	// }
	//
	// // Remove
	//
	// @RequestMapping("/removeForm")
	// public ModelAndView removeForm(HttpServletRequest request) {
	//
	// ModelAndView mav = new ModelAndView();
	//
	// HttpSession session = request.getSession();
	// Note note = (Note) session.getAttribute("note");
	//
	// mav.addObject("note", note);
	// mav.setViewName("/note/removeForm");
	//
	// return mav;
	// }
	//
	// @RequestMapping(value = "/remove", method = RequestMethod.POST)
	// public String memRemove(Note note, HttpServletRequest request) {
	//
	// int result = service.noteRemove(note);
	//
	// if (result == 0)
	// return "/note/removeForm";
	//
	// HttpSession session = request.getSession();
	// session.invalidate();
	//
	// return "/note/removeOk";
	// }

}
