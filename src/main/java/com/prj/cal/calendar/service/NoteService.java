package com.prj.cal.calendar.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.prj.cal.calendar.Note;

@Service
public class NoteService implements INoteService {
	// @Autowired
	// NoteDao dDao;
	// MemberDao mDao;

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
