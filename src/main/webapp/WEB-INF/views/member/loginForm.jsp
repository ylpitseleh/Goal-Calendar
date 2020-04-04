<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <!-- 뷰포트 -->
	<meta name="viewport" content="width=device-width" initial-scale="1">
  <link rel="stylesheet" href="${cp}/resources/css/bootstrap.min.css">
	<title>MEMBER LOGIN</title>
</head>
<body>
<!-- 네비게이션  -->
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
	<li><a href="${cp}/member/joinForm">JOIN</a></li>
   </ul>

  </div> 
 </nav>

 <!-- Login Form -->
 <div class="container">
  <div class="col-lg-4"></div>
  <div class="col-lg-4">
  <!-- 점보트론 -->
   <div class="jumbotron" style="padding-top: 20px;">

   <%-- member라는 이름의 커맨드 객체를 Controller에 전송 --%>
   <form:form action="${cp}/member/login" method="post" commandName="member">
    <h3 style="text-align: center;"> LOGIN </h3>
    	<div class="form-group">
     		<form:input path="memId" class="form-control" placeholder="ID" name="userID" maxlength="20" />
    	</div>
    	<div class="form-group">
     		<form:password path="memPw" class="form-control" placeholder="Password" name="userPassword" maxlength="20" />
    	</div>
    <input type="submit" id="submit" value="Login" class="btn btn-primary form-control">
   </form:form>
  </div>
 </div>
</div>

 <!-- 애니매이션 담당 JQUERY -->
 <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
  
  
 
 <script type="text/javascript">
	if ("${loginError}" == 1) {
		alert("Login Failed.");
	}

</script>
</body>
</html>