<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="${cp}/resources/css/custom.css">
  <link rel="stylesheet" href="${cp}/resources/css/bootstrap.min.css">
	<title>MEMBER REMOVE</title></head>
<body>
<!-- 네비게이션 -->
 <nav class="navbar navbar-default">
  <div class="navbar-header">
   <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expaned="false">
     <span class="icon-bar"></span>
     <span class="icon-bar"></span>
     <span class="icon-bar"></span>
    </button>
    <a class="navbar-brand">Goal Calendar</a>
  </div>

  <div class="collapse navbar-collapse" id="#bs-example-navbar-collapse-1">
   <ul class="nav navbar-nav">
    <li><a href="${cp}/main">MAIN</a></li>
   </ul>
  </div> 
 </nav>
	<!-- Remove Form -->
	<div class="container">
  	<div class="col-lg-4"></div>
  	<div class="col-lg-4">
  		<!-- 점보트론 -->
   		<div class="jumbotron" style="padding-top: 20px;">
   		
	<form:form action="${cp}/member/remove" method="post" commandName="member">
		<h3 style="text-align: center;"> REMOVE </h3>
				<input type="hidden" name="memId" value="${member.memId}">
				<p>ID : ${member.memId}</p>
				<div class="form-group">
					<form:password path="memPw" class="form-control" placeholder="Password" name="userPassword" maxlength="20" />
				</div>
				<input type="submit" value="Remove" class="btn btn-primary form-control">
	</form:form>
	</div>
	</div>
</div>

<!-- 애니매이션 담당 JQUERY -->
<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
 
	
</body>
</html>