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

		//dataSource.setDriverClass("oracle.jdbc.driver.OracleDriver");
		dataSource.setDriverClass("com.mysql.jdbc.Driver");
		//dataSource.setJdbcUrl("jdbc:oracle:thin:@localhost:1521/orcl");
		dataSource.setJdbcUrl("jdbc:mysql://localhost:3306/GOALCALENDAR?useLegacyDatetimeCode=false&serverTimezone=Asia/Seoul");
		dataSource.setUser("root");
		dataSource.setPassword("mysqlstrongweak987!");
		dataSource.setMaxPoolSize(200);
		dataSource.setCheckoutTimeout(60000);
		dataSource.setMaxIdleTime(1800);
		dataSource.setIdleConnectionTestPeriod(600);

		return dataSource;
	}
}
