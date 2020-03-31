package com.prj.cal.calendar.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.prj.cal.calendar.Note;
import com.prj.cal.calendar.dao.NoteDao;

@Service
public class NoteService implements INoteService {
	@Autowired
	NoteDao nDao;
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



	// DB에 현재 로그인된 ID(Session이용), Note Content 등록
	@Override
	public void noteRegister(Note note){
		int result = nDao.noteInsert(note);

		if (result == 0) {
			System.out.println("T_T Note: DB register Fail!!");
		} else {
			System.out.println("^_^ Note: DB register Success!!");
		}
	}

	@Override
	public Note noteSearch(Note note){
		Note noteList = nDao.noteSelect(note);
		
		if(noteList == null) {
			System.out.println("Note is empty.");
		}
		
		return noteList;
	}
	
	@Override
	public List<Note> noteSearchAll(Note note){
		List<Note> noteList = nDao.noteSelectAll();
		
		if(noteList == null) {
			System.out.println("Note is empty.");
		}
		
		return noteList;
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
