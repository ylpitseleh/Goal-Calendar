package com.prj.cal.calendar;

public class Note {
	int noteProgress; // 0 1 2 3 4 5
	String noteDate; // Date noteDate;
	String noteContent;

	public int getNoteProgress() {
		return this.noteProgress;
	}

	public void setNoteProgress(int noteProgress) {
		this.noteProgress = noteProgress;
	}

	public String getNoteDate() {
		return this.noteDate;
	}

	public void setNoteDate(String noteDate) {
		this.noteDate = noteDate;
	}

	public String getNoteContent() {
		return this.noteContent;
	}

	public void setNoteContent(String noteContent) {
		this.noteContent = noteContent;
	}
}
