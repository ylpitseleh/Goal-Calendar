package com.prj.cal.calendar.dao;

import java.util.List;

import com.prj.cal.calendar.Note;

public interface INoteDao {
	int noteInsert(Note note);
	Note noteSelect(Note note);
	int noteUpdate(Note note);
	int noteDelete(Note note);
	List<Note> noteSelectAll(final Note noteToSearch);
}
