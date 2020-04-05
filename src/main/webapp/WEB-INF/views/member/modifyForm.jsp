<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <!-- 뷰포트 -->
	<meta name="viewport" content="width=device-width" initial-scale="1">
  <link rel="stylesheet" href="${cp}/resources/css/custom.css">
  <link rel="stylesheet" href="${cp}/resources/css/bootstrap.min.css">
	<title>MEMBER MODIFY</title>
</head>

<body>
<!-- 네비게이션  -->
 <nav class="navbar navbar-default">
  <div class="navbar-header">
   <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
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

	<!-- Join Form -->
	<div class="container">
  	<div class="col-lg-4"></div>
  	<div class="col-lg-4">
  		<!-- 점보트론 -->
   		<div class="jumbotron" style="padding-top: 20px;">

  	<form:form action="${cp}/member/modify" method="post" commandName="member">
    	<h3 style="text-align: center;"> MODIFY </h3>
    		<div class="form-group">
    			<form:hidden path="memId" value="${member.memId}" />
    		</div>
        	<p>ID : ${member.memId}</p>
        	<div class="form-group">
          		<form:password path="memPw" class="form-control" placeholder="Password" name="userPassword" maxlength="20" />
          	</div>
          	<div class="form-group">
          		<form:input type="email" path="memMail" class="form-control" placeholder="Email" name="userEmail" maxlength="30"/>
        	</div>
      		<input type="submit" value="Modify" class="btn btn-primary form-control">
  </form:form>
  </div>
</div>
</div>
<!-- 애니매이션 담당 JQUERY -->
 <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>

</body>
</html>
