package com.prj.cal.calendar.dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.PreparedStatementSetter;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import com.mchange.v2.c3p0.ComboPooledDataSource;
import com.prj.cal.calendar.Note;

@Repository
public class NoteDao implements INoteDao {
	private JdbcTemplate template;

	//	CREATE TABLE Calendar (
	//		noteId VARCHAR2(15),
	//		noteDate DATE,
	//		noteContent VARCHAR2(150),
	//		noteProgress NUMBER(1),
	//	  PRIMARY KEY (noteId, noteDate)
	//	);
	//
	//	------------
	//	CREATE TABLE Member (
	//		memId VARCHAR2(15) CONSTRAINT memId_pk PRIMARY KEY,
	//		memPw VARCHAR2(20),
	//		memMail VARCHAR2(30)
	//	);

	@Autowired
	public NoteDao(ComboPooledDataSource dataSource) {
		this.template = new JdbcTemplate(dataSource);
	}

	@Override
	public int noteInsert(final Note note) {
		int result = 0;
		final String sql = "INSERT INTO calendar (noteId, noteDate, noteProgress, noteContent) values (?,?,?,?)";
		// final String sql = "UPDATE member SET memPw = ?, memMail = ? WHERE memId = ?";
		// if exists UPDATE, else INSERT

		result = template.update(sql, new PreparedStatementSetter() {

			@Override
			public void setValues(PreparedStatement pstmt) throws SQLException {

				SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
				try {
					String noteId = note.getNoteId();

					java.util.Date date = formatter.parse(note.getNoteDate());
					java.sql.Date noteDate = new java.sql.Date(date.getTime()); // DB에 넣기 위한 date 형변환

					int noteProgress = note.getNoteProgress();
					String noteContent = note.getNoteContent();

					// 1 = 첫 번째 ?에 note.getNoteId()를 세팅
					pstmt.setString(1, noteId);
					pstmt.setDate(2, noteDate);
					pstmt.setInt(3, noteProgress);
					pstmt.setString(4, noteContent);

					System.out.println("NoteId in DB : " + noteId);
					System.out.println("NoteDate in DB : " + noteDate);
					System.out.println("NoteProgress in DB : " + noteProgress);
					System.out.println("NoteContent in DB : " + noteContent);
				} catch (ParseException e) {
					System.out.println("ParseException: Need to modify some parsing process!");
					e.printStackTrace();
				} catch (Exception e) {
					e.printStackTrace();
				}

			}
		});

		return result;
	}

	@Override
	public List<Note> noteSelectAll(final Note noteToSearch) {
		/* Id와 Month가 매칭되는 모든 데이터를 찾아라 */
		final String sql = "SELECT * FROM calendar WHERE noteId = ? AND EXTRACT(YEAR FROM noteDate) = ? AND EXTRACT(MONTH FROM noteDate) = ?";
		List<Note> notes = null;

		try {
			String noteId = noteToSearch.getNoteId();

			String getYear = noteToSearch.getNoteDate().substring(0, 4);
			String getMonth = noteToSearch.getNoteDate().substring(5, 7);

			//원래처럼 new Object[]가 없으면 쿼리문에서 '?'에 뭐가 들어가는거지?
			//notes = template.query(sql, new RowMapper<Note>() {
			notes = template.query(sql, new Object[] { noteId, getYear, getMonth }, new RowMapper<Note>() { // noteId, getYear, getMonth -> '?'에 들어갈 값
				@Override
				public Note mapRow(ResultSet rs, int rowNum) throws SQLException {
					Note note = new Note();
					//DB에서 가져와서 여기서 하나씩 note로 set해서 notes에 모두 넣어라.
					note.setNoteId(rs.getString("noteId"));
					note.setNoteDate(rs.getString("noteDate"));
					note.setNoteProgress(rs.getInt("noteProgress"));
					note.setNoteContent(rs.getString("noteContent")); //noteProgress만 보여줄거라서 noteContent는 넣어줄 필요 없긴 함.
					return note;
				}

			});
			if (notes.isEmpty()) {
				System.out.println("Dao에서 notes는 비어있다.");
				return null;
			}
		} catch (Exception e) {
			System.out.println("Date 형식이 잘못되었다.");
			e.printStackTrace();
		}
		return notes;
	}

	@Override
	public Note noteSelect(final Note noteToSearch) {

		List<Note> notes = null;

		final String sql = "SELECT * FROM calendar WHERE noteId = ? AND noteDate = ?";

		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		try {
			String noteId = noteToSearch.getNoteId();

			java.util.Date date = formatter.parse(noteToSearch.getNoteDate());
			java.sql.Date noteDate = new java.sql.Date(date.getTime());

			notes = template.query(sql, new Object[] { noteId, noteDate }, new RowMapper<Note>() {

				@Override
				public Note mapRow(ResultSet rs, int rowNum) throws SQLException {
					Note note = new Note();
					note.setNoteId(rs.getString("noteId"));
					note.setNoteDate(rs.getString("noteDate"));
					note.setNoteProgress(rs.getInt("noteProgress"));
					note.setNoteContent(rs.getString("noteContent"));
					return note;
				}
			});

			if (notes.isEmpty())
				return null;

		} catch (ParseException e) {
			System.out.println("ParseException: Need to modify some parsing process!");
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return notes.get(0);
	}

	@Override
	public int noteUpdate(final Note note) {

		// int result = 0;

		// final String sql = "UPDATE note SET memPw = ?, memMail = ? WHERE memId = ?";

		// result = template.update(sql, new PreparedStatementSetter() {

		// @Override
		// public void setValues(PreparedStatement pstmt) throws SQLException {
		// pstmt.setString(1, note.getDataPw());
		// pstmt.setString(2, note.getDataMail());
		// pstmt.setString(3, note.getDataId());
		// }
		// });
		// return result;

		return 0;
	}

	@Override
	public int noteDelete(final Note note) {

		// int result = 0;

		// final String sql = "DELETE note WHERE memId = ? AND memPw = ?";

		// result = template.update(sql, new PreparedStatementSetter() {

		// @Override
		// public void setValues(PreparedStatement pstmt) throws SQLException {
		// pstmt.setString(1, note.getDataId());
		// pstmt.setString(2, note.getDataPw());
		// }
		// });

		// return result;

		return 0;
	}
}
