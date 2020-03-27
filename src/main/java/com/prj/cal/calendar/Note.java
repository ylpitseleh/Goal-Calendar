package com.prj.cal.calendar;

public class Note {
	private String noteId;
	private java.util.Date noteDate; // Date noteDate;
	private int noteProgress; // 0 1 2 3 4 5
	private String noteContent;

	public String getNoteId() {
		return noteId;
	}
	public void setNoteId(String noteId) {
		this.noteId = noteId;
	}

	public java.util.Date getNoteDate() {
		return this.noteDate;
	}

	public void setNoteDate(java.util.Date noteDate) {
		this.noteDate = noteDate;
	}

	public int getNoteProgress() {
		return this.noteProgress;
	}

	public void setNoteProgress(int noteProgress) {
		this.noteProgress = noteProgress;
	}

	public String getNoteContent() {
		return this.noteContent;
	}

	public void setNoteContent(String noteContent) {
		this.noteContent = noteContent;
	}
}
