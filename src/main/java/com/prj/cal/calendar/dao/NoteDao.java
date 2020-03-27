package com.prj.cal.calendar.dao;

import com.prj.cal.calendar.Note;
import com.prj.cal.member.Member;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import com.mchange.v2.c3p0.ComboPooledDataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.PreparedStatementSetter;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

@Repository
public class NoteDao implements INoteDao {
	private JdbcTemplate template;

	@Autowired
	public NoteDao(ComboPooledDataSource dataSource) {
		this.template = new JdbcTemplate(dataSource);
	}

	@Override
	public int noteInsert(final Note note) {
		int result = 0;
		final String sql = "INSERT INTO calendar (noteId, noteContent) values (?,?)";
		result = template.update(sql, new PreparedStatementSetter() {
			
			@Override
			public void setValues(PreparedStatement pstmt) throws SQLException {
				//1 = 첫 번째 ?에 note.getNoteContent()를 세팅
				pstmt.setString(1, note.getNoteId());
				pstmt.setString(2, note.getNoteContent());
				System.out.println("NoteContent in Dao : "+note.getNoteContent());
				System.out.println("NoteId in Dao : "+note.getNoteId());
			}
		});
		
		return result;
	}

	@Override
	public Note noteSelect(final Note note) {
		// List<Note> note = null;
		// final String sql = "SELECT * FROM note WHERE memId = ? AND memPw = ?";

		// note = template.query(sql, new Object[] { note.getDataId(), note.getDataPw() }, new RowMapper<Note>() {
		// 	@Override
		// 	public Note mapRow(ResultSet rs, int rowNum) throws SQLException {
		// 		Note mem = new Note();
		// 		mem.setDataId(rs.getString("memId"));
		// 		mem.setDataPw(rs.getString("memPw"));
		// 		mem.setDataMail(rs.getString("memMail"));
		// 		mem.setDataPurcNum(rs.getInt("memPurcNum"));
		// 		return mem;
		// 	}

		// });

		// if (note.isEmpty())
		// 	return null;

		// return note.get(0);
		return null;
	}

	@Override
	public int noteUpdate(final Note note) {

		// int result = 0;

		// final String sql = "UPDATE note SET memPw = ?, memMail = ? WHERE memId = ?";

		// result = template.update(sql, new PreparedStatementSetter() {

		// 	@Override
		// 	public void setValues(PreparedStatement pstmt) throws SQLException {
		// 		pstmt.setString(1, note.getDataPw());
		// 		pstmt.setString(2, note.getDataMail());
		// 		pstmt.setString(3, note.getDataId());
		// 	}
		// });
		// return result;

		return 0;
	}

	@Override
	public int noteDelete(final Note note) {

		// int result = 0;

		// final String sql = "DELETE note WHERE memId = ? AND memPw = ?";

		// result = template.update(sql, new PreparedStatementSetter() {

		// 	@Override
		// 	public void setValues(PreparedStatement pstmt) throws SQLException {
		// 		pstmt.setString(1, note.getDataId());
		// 		pstmt.setString(2, note.getDataPw());
		// 	}
		// });

		// return result;

		return 0;
	}
}
