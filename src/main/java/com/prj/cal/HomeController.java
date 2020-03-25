package com.prj.cal;

import javax.servlet.http.HttpServletRequest;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class HomeController {

	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);

	// cal/
	@ModelAttribute("cp")
	public String getContextPath(HttpServletRequest request) {
		return request.getContextPath();
	}

	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String index() {
		return "/index";
	}

}
