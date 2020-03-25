package com.prj.cal.calendar.service;

import java.io.IOException;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.Locale;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.prj.cal.calendar.Note;

@Service
public class NoteService implements INoteService {
	//@Autowired
	//NoteDao dDao;
	// MemberDao mDao;
	/*int curYear, curMonth;
	
	
	
	protected void FindCurrentYearMonth(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //System.out.println("doPost 호출!");
        response.setCharacterEncoding("UTF-8");
 
        String content = request.getParameter("content");    
        
		Calendar calendar = new GregorianCalendar(Locale.KOREA);
		curYear = calendar.get(Calendar.YEAR);
		curMonth = calendar.get(Calendar.MONTH) + 1;
		Calendar cal = Calendar.getInstance(); // 현재 날짜와 시간
        
        request.setAttribute("content", content);
        
        ServletContext context = getServletContext();
        RequestDispatcher dispatcher = context.getRequestDispatcher("/main.jsp"); //넘길 페이지 주소
        dispatcher.forward(request, response);
 
    }*/
	
	
	
	@Override
	public void noteRegister(Note note){
		return ;
	}

	@Override
	public Note noteSearch(Note note){
		return null;
	}

	@Override
	public Note noteModify(Note note){
		return null;
	}

	@Override
	public int noteRemove(Note note){
		return 0;
	}

}
