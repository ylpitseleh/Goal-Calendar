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
	public Note noteSearch(Note noteToSearch){
		Note noteMatched = nDao.noteSelect(noteToSearch);

		if(noteMatched == null) {
			System.out.println("Note is empty.");
		}

		return noteMatched;
	}

	@Override
	public List<Note> noteSearchAll(Note noteToSearch){
		List<Note> noteList = nDao.noteSelectAll(noteToSearch);

		if(noteList.isEmpty()) {
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
		int result = nDao.noteDelete(note);

		if (result == 0) {
			System.out.println("T_T Note: DB remove Fail!!");
		} else {
			System.out.println("^_^ Note: DB remove Success!!");
		}
		return result;
	}

}
