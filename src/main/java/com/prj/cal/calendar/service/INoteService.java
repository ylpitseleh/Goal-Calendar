package com.prj.cal.calendar.service;

import java.util.List;

import com.prj.cal.calendar.Note;

public interface INoteService {
	void noteRegister(Note note);
	Note noteSearch(Note note);
	Note noteModify(Note note);
	int noteRemove(Note note);
	List<Note> noteSearchAll(Note note);
	
}
