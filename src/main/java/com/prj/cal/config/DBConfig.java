package com.prj.cal.config;

import java.beans.PropertyVetoException;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.mchange.v2.c3p0.ComboPooledDataSource;

@Configuration
public class DBConfig {

	@Bean
	public ComboPooledDataSource dataSource() throws PropertyVetoException {
		ComboPooledDataSource dataSource = new ComboPooledDataSource();

		// //dataSource.setDriverClass("oracle.jdbc.driver.OracleDriver");
		// dataSource.setDriverClass("com.mysql.jdbc.Driver");
		// //dataSource.setJdbcUrl("jdbc:oracle:thin:@localhost:1521/orcl");

		////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		// dataSource.setJdbcUrl("jdbc:mysql://localhost:3306/GOALCALENDAR?useLegacyDatetimeCode=false&serverTimezone=Asia/Seoul");
		// dataSource.setUser("root");
		// dataSource.setPassword("mysqlstrongweak987!");

		////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		// 임시 저장
		// GRANT ALL ON goalCalendar TO 'scott'@'localhost';

		dataSource.setDriverClass("com.mysql.jdbc.Driver");
		dataSource.setJdbcUrl(
				"jdbc:mysql://localhost:3306/goalCalendar?useLegacyDatetimeCode=false&serverTimezone=Asia/Seoul");
		dataSource.setUser("scott");
		dataSource.setPassword("tiger");
		dataSource.setMaxPoolSize(200);
		dataSource.setCheckoutTimeout(60000);
		dataSource.setMaxIdleTime(1800);
		dataSource.setIdleConnectionTestPeriod(600);

		// hmin: 이대로 따라치면 된다구욧!
		//
		// mysql -u root -p
		// CREATE USER 'scott'@'localhost' IDENTIFIED BY 'tiger';
		// CREATE DATABASE goalCalendar;
		// GRANT ALL PRIVILEGES ON goalCalendar TO 'scott'@'localhost';
		// exit
		//
		// mysql -uscott -ptiger
		// USE goalCalendar;
		//
		/* 한 방에 복붙!
		CREATE TABLE calendar (
			noteId VARCHAR(15),
			noteDate DATE,
			noteContent VARCHAR(200),
			noteProgress INT(1),
			PRIMARY KEY (noteId, noteDate)
		);

		CREATE TABLE member (
			memId VARCHAR(15),
			memPw VARCHAR(20),
			memMail VARCHAR(30),
			PRIMARY KEY (memId)
		);

		*/

		return dataSource;
	}
}
