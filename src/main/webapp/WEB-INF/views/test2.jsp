<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>

<head>
  <link href="<c:url value="/resources/css/test.css" />" rel="stylesheet">

  <script language='JavaScript'>
    document.write('<st' + 'yle>');
    document.write('td {font-size:12px; font-family:굴림; text-decoration:none; }');
    document.write('A:link,A:active,A:visited{text-decoration:none;font-size:12PX;color:#333333;}');
    document.write('A:hover {text-decoration:none; color:ff9900}');
    document.write('font { font-size: 9pt; }');
    document.write('.cnj_input {position:relative;}');
    document.write('.cnj_input2 {border-width:1; border-color:rgb(204,204,204); border-style:solid;}');
    document.write('.cnj_input3 { border-width:1; border-style:solid; border-color:#000000; color:#0084D4; background-color:white;text-align:right;}');
    document.write('.cnj_input4 { scrollbar-face-color: #FFCC33;scrollbar-shadow-color: #ffffff;scrollbar-highlight-color: #F3f3f3;scrollbar-3dlight-color: #ffffff;scrollbar-darkshadow-color: #F3f3f3;scrollbar-track-color: #ffffff;scrollbar-arrow-color: #f9f9f9; }');
    document.write('</st' + 'yle>');

    var monthName = new Array("1월", "2월", "3월", "4월", "5월", "6월", "7월",
      "8월", "9월", "10월", "11월", "12월")
    /*
    var monthName=new Array("January","February","March","April","May","June","July",
    "August","September","October","November","December")
    */
    var monthDays = new Array(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)
    var now = new Date
    var nowd = now.getDate()
    var nowm = now.getMonth()
    var nowy = now.getYear()

    function showCalendar(day, month, year) {
      if ((year % 4 == 0 || year % 100 == 0) && (year % 400 == 0)) monthDays[1] = 29;
      else monthDays[1] = 28 //leap year test
      var firstDay = new Date(year, month, 1).getDay()
      var cnj_str = "<table border=0 cellpadding=5 cellspacing=1 align=center bgcolor=#CCCCCC>"

      cnj_str += "<tr bgcolor=white><td colspan=7>"
      cnj_str += "<table border=0 cellpadding=0 cellspacing=0 align=center width=100%>"
      cnj_str += "<td><a href='javascript:;' onClick='nowm--; if (nowm<0) { nowy--; nowm=11; } showCalendar(nowd,nowm,nowy)' title='이전 월'> <<</a></td>"
      cnj_str += "<td align=center>" + monthName[month].toUpperCase() + " " + year + "년</td>"
      cnj_str += "<td align=right><a href='javascript:;' onClick='nowm++; if (nowm>11) { nowy++; nowm=0; } showCalendar(nowd,nowm,nowy)' title='다음 월'> >></a></td>"
      cnj_str += "</tr></table>"
      cnj_str += "</td></tr>"
      cnj_str += "<tr align=center bgcolor='#FFFFB9'>"
      cnj_str += "<th><font color='red'>일</font></th>"
      cnj_str += "<th><font color='black'>월</font></th>"
      cnj_str += "<th><font color='black'>화</font></th>"
      cnj_str += "<th><font color='black'>수</font></th>"
      cnj_str += "<th><font color='black'>목</font></th>"
      cnj_str += "<th><font color='black'>금</font></th>"
      cnj_str += "<th><font color='blue'>토</font></th>"
      cnj_str += "</tr>"

      var dayCount = 1

      cnj_str += "<tr bgcolor=white>"

      for (var i = 0; i < firstDay; i++) cnj_str += "<td> " //공백 asdf
      for (var i = 0; i < monthDays[month]; i++) {
        if (dayCount == nowd) {
          cnj_str += "<td align=center bgcolor='#FFFFB9'><b>" // 오늘 날짜일때 배경색 지정,글자 진하게
        } else {
          cnj_str += "<td align=center>" // 오늘 날짜가 아닐때 배경색 지정
        }

        cnj_str += "<a href=http://www.홈페이지.com/link" + dayCount + ".html target=_blank>" // 링크설정
        cnj_str += dayCount++ // 날짜
        cnj_str += "</a>"

        if (dayCount == nowd) {
          cnj_str += "</b>" // 오늘 날짜일때 글자 진하게
        } else {
          cnj_str += "" // 오늘 날짜가 글자 진하게 안함
        }

        if ((i + firstDay + 1) % 7 == 0 && (dayCount < monthDays[month] + 1)) cnj_str += "<tr bgcolor=white>"
      }
      var totCells = firstDay + monthDays[month]
      for (var i = 0; i < (totCells > 28 ? (totCells > 35 ? 42 : 35) : 28) - totCells; i++) cnj_str += "<td> "
      cnj_str += "</table><BR>"
      calendar.innerHTML = cnj_str
    }
  </script>
</head>

<body onLoad="showCalendar(nowd,nowm,nowy)">
  <span id="calendar" class="cnj_input"></span>
</body>

</html>
