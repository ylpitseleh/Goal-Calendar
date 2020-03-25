package com.prj.cal.calendar.service;

import com.prj.cal.calendar.Note;

public interface INoteService {
	void noteRegister(Note note);
	Note noteSearch(Note note);
	Note noteModify(Note note);
	int noteRemove(Note note);
}
