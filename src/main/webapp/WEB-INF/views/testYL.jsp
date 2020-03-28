<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- <%@ page session="false"%> --%>
<html>

<head>
  <link href="<c:url value="/resources/css/test.css?after" />" rel="stylesheet">

  <%-- No need to use ajax ..? --%>

  <!-- <script type="text/javascript" src="JS/jquery-1.4.2.min.js"></script>  -->
  <!-- <script src="./js/jquery-1.4.2.min.js"></script>  -->
  <script src="http://code.jquery.com/jquery-latest.js"></script>

  <script type="text/javascript">
    $(document).ready(function () {
      $('#ibutton').click(function (e) {
        e.preventDefault();

        var year = "${curYear}"
        var month = document.querySelector(".months li a.selected").getAttribute("month-value");
        var day = document.querySelector(".days li a.selected").text;
        month = month.length == 1 ? "0" + month.slice(0) : month;
        day = day.length == 1 ? "0" + day.slice(0) : day;

        if ("${member}") {
          document.querySelector("#noteId").value = "${member.memId}";
          document.querySelector("#noteDate").value = year + "-" + month + "-" + day;
          console.log("mdmId: ${member.memId}");
        } else
        {
          console.log("Need Login!");
        }

        $.ajax({
          url: "saveNoteContent",
          type: "post",
          dataType: "JSON",
          //serialize() : 입력된 모든 Element를 문자열의 데이터에 serialize 한다.
          //{data1: value1, data2: value2, ...}
          data: $("#inputNote").serialize(),
          cache: false,
          success: function (data) {
            $("#noteProgress").val('');
            $("#noteContent").val('');
          }
        });
      });
    });
  </script>
</head>

<body>
  <div class="calendar">

    <div class="col leftCol">
      <div class="content">
        <!-- TEMP -->
        <div class="TEMP">
          <a href="${cp}">MAIN</a>
          <p class="date">
            testYL.jsp<br>
            <br>
            cp: ${cp}<br>
            serverTime: ${serverTime}<br>
            empty member: ${empty member}<br>
            member: ${member}
          </p>
        </div>
        <!-- TEMP -->
        <!-- <h1 class="title">임시 타이틀</h1> -->
        <div class="notes">
            <script>
              // function fillInputNote() {
              //   if ("${member}") {
              //     document.querySelector("#noteId").value = ${member.memId};
              //     document.querySelector("#noteDate").value = "2020-01-31";
              //     console.log("mdmId: ${member.memId}");
              //   }
              // }
            </script>
            <%-- note라는 이름의 커맨드 객체를 session에 추가하였음. --%>
            <form name="inputNote" action="saveNoteContent" id="inputNote" commandName="note">
              <input type="hidden" name="noteId" id="noteId"/>
              <input type="hidden" name="noteDate" id="noteDate"/>
              <input type="text" name="noteProgress" id="noteProgress" value="" placeholder="rate progress" />
              <input type="text" name="noteContent" id="noteContent" value="" placeholder="new note" />
              <input type="button" id="ibutton" value="Save" p style="cursor:pointer" />
            </form>

          <ul class="noteList">
            <li>note: ${note} / note.noteDate: ${note.noteDate} <a href="#" title="Remove note" class="removeNote animate">x</a></li>
          </ul>
        </div>
      </div>
    </div>

    <div class="col rightCol">
      <div class="content">
        <h2 class="curYear">${curYear}</h2>

        <ul class="months">
          <li><a href="#" title="Jan" month-value="1">Jan</a></li>
          <li><a href="#" title="Feb" month-value="2">Feb</a></li>
          <li><a href="#" title="Mar" month-value="3">Mar</a></li>
          <li><a href="#" title="Apr" month-value="4">Apr</a></li>
          <li><a href="#" title="May" month-value="5">May</a></li>
          <li><a href="#" title="Jun" month-value="6">Jun</a></li>
          <li><a href="#" title="Jul" month-value="7">Jul</a></li>
          <li><a href="#" title="Aug" month-value="8">Aug</a></li>
          <li><a href="#" title="Sep" month-value="9">Sep</a></li>
          <li><a href="#" title="Oct" month-value="10">Oct</a></li>
          <li><a href="#" title="Nov" month-value="11">Nov</a></li>
          <li><a href="#" title="Dec" month-value="12">Dec</a></li>
        </ul>
        <script>
          document.querySelector('[month-value="${curMonth}"]').classList.add("selected");
        </script>
        <div class="clearfix"></div>
        <ul class="weekdays">
          <li><a href="#" title="Mon" data-value="1">Mon</a></li>
          <li><a href="#" title="Tue" data-value="2">Tue</a></li>
          <li><a href="#" title="Wed" data-value="3">Wed</a></li>
          <li><a href="#" title="Thu" data-value="4">Thu</a></li>
          <li><a href="#" title="Fri" data-value="5">Fri</a></li>
          <li><a href="#" title="Say" data-value="6">Sat</a></li>
          <li><a href="#" title="Sun" data-value="7">Sun</a></li>
        </ul>
        <div class="clearfix"></div>
        <ul class="days">
          <script>
            var today = new Date(); //오늘 날짜//내 컴퓨터 로컬을 기준으로 today에 Date 객체를 넣어줌
            var date = new Date(); //today의 Date를 세어주는 역할
            //이번 달의 첫째 날
            //new를 쓰는 이유 : new를 쓰면 이번달의 로컬 월을 정확하게 받아온다. getMonth()는 0~11을 반환하기 때문에 new를 쓰지 않았을때 이번달을 받아오려면 +1 해줘야한다.
            var thisMonthDay1 = new Date(today.getFullYear(), today.getMonth(), 1);
            //이번 달의 마지막 날
            //new를 써주면 정확한 월을 가져옴, getMonth()+1을 해주면 다음달로 넘어가는데 day를 1부터 시작하는게 아니라 0부터 시작하기 때문에 제대로 된 다음달 시작일(1일)은 못가져오고 1 전인 0, 즉 전달 마지막일 을 가져오게 된다
            var lastDate = new Date(today.getFullYear(), today.getMonth() + 1, 0);

            var addSpace = '';
            //ThisMonth.getDay() = 이번 달 1일이 무슨 요일인지
            //getDay() : 요일을 알아내는 메소드. 반환값은 0부터 7까지이며 0은 일요일, 1은 월요일...
            //1일 전에 빈 칸 띄워주기
            for (i = 0; i < thisMonthDay1.getDay(); i++) { //공백을 줄 수 있는 방법이 a href 뿐인지 모르겠음
              document.write('<li><a href="#">' + ' ' + '</a></li>');
            }

            function callFunction(t) {
            	// t의 자료형 : String
            	// 현재 selected 되어있던것들 모두 remove하고 선택된 것만 selected
            	var sections = document.querySelectorAll('[day-value]');
                for (i = 0; i < sections.length; i++){
                    sections[i].classList.remove('selected');
                }
            	console.log(t);
            	document.querySelector('[title="'+t+'"]').classList.add("selected");
            }
            //1일부터 마지막 일까지 돌림
            for (var i = 1; i <= lastDate.getDate(); i++) {
              document.write('<li><a href="#" onclick="callFunction(title);" title="' + i + '" day-value="' + i + '"' + addSpace + '>' + i + '</a></li>');
            }


            document.querySelector('[day-value="${curDay}"]').classList.add("selected");
          </script>
        </ul>
        <div class="clearfix"></div>
      </div>
    </div>

    <div class="clearfix"></div>

  </div>
</body>

</html>
