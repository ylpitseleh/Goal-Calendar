<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- <%@ page session="false"%> --%>
<html>

<head>
  <!-- QueryString으로 랜덤한 값을 붙임으로써, 이미 캐시로 저장된 css와 js파일이 아닌 새로운 파일을 계속 읽도록 함.
      이게 귀찮으면, xml configuration에서 webServer의 캐시 기능 자체를 off할 수도 있다.
      참고: https://stackoverflow.com/questions/12717993/stylesheet-not-updating
  -->
  <link href="<c:url value='/resources/css/testYL.css?${serverTime}' />" rel="stylesheet">
  <script src="http://code.jquery.com/jquery-latest.js"></script>

  <script type="text/javascript">
    // https://learn.jquery.com/using-jquery-core/document-ready/
    $(document).ready(function () {
      /* updateNoteList 함수는 조건에 맞는 note를 DB로부터 끌어온다.
        1. DOM에서 .selected 클래스가 붙은 element를 찾아 year, month, day값을 받아오고
        2. 그 값들을 $.ajax를 통해 post 방식으로 testYLReloadDBMatching url로 request 한 후
        3. NoteController.java의 testYLReloadDBMatching 메소드에서 @RequestParam으로 값을 넘겨 받으면
        4. 거기서 noteId와 noteDate값을 구한 후 이 둘이 매칭되는 노트를 DB로부터 가져온다.
        5. 이후 가져온 노트와 관련된 데이터를 @ResponseBody 로 리턴하면
        6. $.Ajax에서 리턴된 그 값을 다시 넘겨받는다.
        7. 넘겨받은 값은 success: function(data) 형식으로 사용할 수 있다. (return 값 == data 값)
         */
      //////////////////////////////////////////////////////////////////////////
      function updateNoteList() {
        var year = "${curYear}"
        var month = document.querySelector(".months li a.selected").getAttribute("month-value");
        var day = document.querySelector(".days li a.selected").text;
        month = month.length == 1 ? "0" + month.slice(0) : month;
        day = day.length == 1 ? "0" + day.slice(0) : day;

        $.ajax({
          url: "loadNoteListByDate",
          type: "post",
          data: {
            'year': year,
            'month': month,
            'day': day
          },

          success: function (data) {
            $("#noteContent").val("");
            $("#noteContent").focus();

            var strs = data.split("|");
            // strs = [noteId, noteDate, noteProgress, noteContent];

            $(".noteList li").remove();
            if (strs != "") {
              document.querySelector("#noteProgress").value = strs[2];

              // .noteList는 이제 디버깅 용도일 뿐!!
              var html = "<li class='notes'>\n<pre>";
              html += "<br>=== Debugging ===<br>";
              html += "Id: " + strs[0] + "<br>";
              html += "Date: " + strs[1] + "<br>";
              html += "Progress: " + strs[2] + "<br>";
              html += "Content: " + strs[3] + "";
              html += "</pre>\n</li>";
              document.querySelector('.noteList').innerHTML += html;
            } else {
              document.querySelector("#noteProgress").value = "";
              document.querySelector("#noteContent").value = "";
              $(".noteList li").remove();
            }
          },

          error: function (request, status, error) {
            alert("code = " + request.status + " message = " + request.responseText + " error = " + error);
          }
        });
      }
      //////////////////////////////////////////////////////////////////////////
      /* 페이지를 로드할 때마다 DB에서 현재 로그인 id, year, month와 일치하는 note들을 모두 찾아와서 noteProgress value별로 색깔을 입혀줌. */
      function updateProgressColors() {
        var year = "${curYear}"
        var month = document.querySelector(".months li a.selected").getAttribute("month-value");
        month = month.length == 1 ? "0" + month.slice(0) : month; //1월 -> 01월

        $.ajax({
          url: "loadNoteListByMonth",
          //dataType: 서버에서 return되는 데이터 형식
          dataType: 'json',
          type: "post",
          data: {
            'year': year,
            'month': month
          },

          success: function (data) {
            for (var i = 0 in data) {
              var tmp_day = data[i].noteDate;

              if (tmp_day.substr(8, 1) === ('0'))
                tmp_day = tmp_day.substr(9, 1);
              else
                tmp_day = tmp_day.substr(8, 2);

              var el = '#' + tmp_day;
              var color = "";
              if (data[i].noteProgress === 1) color = '#E8F8F5';
              else if (data[i].noteProgress === 2) color = '#D1F2EB';
              else if (data[i].noteProgress === 3) color = '#A3E4D7';
              else if (data[i].noteProgress === 4) color = '#76D7C4';
              else if (data[i].noteProgress === 5) color = '#48C9B0';
              $(el).css('background-color', color);
            }
          },

          error: function (request, status, error) {
            alert("code = " + request.status + " message = " + request.responseText + " error = " + error);
          }
        });
      }

      //////////////////////////////////////////////////////////////////////////

      // 함수 호출
      updateNoteList();
      updateProgressColors();

      $('.reloadTrigger').click(function (e) {
        // function stringifyEvent(e) {
        //   const obj = {};
        //   for (let k in e) {
        //     obj[k] = e[k];
        //   }
        //   return JSON.stringify(obj, (k, v) => {
        //     if (v instanceof Node) return 'Node';
        //     if (v instanceof Window) return 'Window';
        //     return v;
        //   }, ' ');
        // }
        // alert("디버깅!\n" + stringifyEvent(e));

        //e.preventDefault();
		console.log("reloadTrigger 실행되었습니다.");
        updateNoteList();
        updateProgressColors();
      });

      //////////////////////////////////////////////////////////////////////////

      /* modifyButton 누르면 noteContent(입력창)의 값을 post-it값으로 바꾸고 커서 포커싱 */
      $('.modifyButton').click(function (e) {
        $("#noteContent").val(
          $(".noteList li p").text()
        );
        $("#noteContent").focus();
      });

      //////////////////////////////////////////////////////////////////////////

      /* SAVE 버튼 클릭 시 */
      $('#saveButton').click(function (e) {
        e.preventDefault();
        /* selected된 날짜 넣어주기 */
        var year = "${curYear}"
        var month = document.querySelector(".months li a.selected").getAttribute("month-value");
        var day = document.querySelector(".days li a.selected").text;
        month = month.length == 1 ? "0" + month.slice(0) : month;
        day = day.length == 1 ? "0" + day.slice(0) : day;

        /* noteId, noteDate에 현재 로그인 된Id, selected 된 날짜 넣어주기 */
        if ("${member}") {
          document.querySelector("#noteId").value = "${member.memId}";
          document.querySelector("#noteDate").value = year + "-" + month + "-" + day;
          console.log("memId: ${member.memId}");
        } else {
          console.log("Need Login!");
          alert("You need to login.");
        }

        /* form 태그를 통해 input 값으로 들어온 noteProgress와 noteContent를 비동기 POST 방식으로 전송*/
        $.ajax({
          url: "saveNoteContent",
          type: "post",
          //dataType: "JSON", dataType 주석 처리 하니 에러 없어짐 //왜인지 알아보자!
          //serialize() : 입력된 모든 Element를 문자열의 데이터에 serialize 한다.
          data: $("#inputNote").serialize(),
          cache: false,
          success: function (data) {
            // alert("Save Success!");
            successFunction();

            updateNoteList();
            updateProgressColors();
          },
          error: function (request, status, error) {
            alert("code = " + request.status + " message = " + request.responseText + " error = " + error);
          }
        });
      });

      function successFunction() {
        /* 사용자가 입력한 noteProgress(0~5)만큼 색깔 지정(비동기 방식. 새로고침 하지 않아도 적용됨) */
        var color = "";
        if (document.querySelector("#noteProgress").value == "1")
          color = "#E8F8F5";
        else if (document.querySelector("#noteProgress").value == "2")
          color = "#D1F2EB";
        else if (document.querySelector("#noteProgress").value == "3")
          color = "#A3E4D7";
        else if (document.querySelector("#noteProgress").value == "4")
          color = "#76D7C4";
        else if (document.querySelector("#noteProgress").value == "5")
          color = "#48C9B0";
        $(".days li a.selected").css("background-color", color);
      };

      //////////////////////////////////////////////////////////////////////////

      // deleteButton 클릭 시
      $('#deleteButton').click(function (e) {
        e.preventDefault();
        /* selected된 날짜 넣어주기 */
        var year = "${curYear}"
        var month = document.querySelector(".months li a.selected").getAttribute("month-value");
        var day = document.querySelector(".days li a.selected").text;
        month = month.length == 1 ? "0" + month.slice(0) : month;
        day = day.length == 1 ? "0" + day.slice(0) : day;

        $.ajax({
          url: "deleteNote",
          type: "post",
          //dataType: "JSON", dataType 주석 처리 하니 에러 없어짐 //왜인지 알아보자!
          //serialize() : 입력된 모든 Element를 문자열의 데이터에 serialize 한다.
          data: {
            'year': year,
            'month': month,
            'day': day
          },
          cache: false,
          success: function (data) {
            $(".noteList li").remove();
            $(".days li a.selected").css("background-color", "#ffffff");
            alert("데이터가 정상적으로 삭제되었습니다.");
          },
          error: function (request, status, error) {
            alert("code = " + request.status + " message = " + request.responseText + " error = " + error);
          }
        });
      })

    });
  </script>

</head>

<body>
  <a href="${cp}">MAIN</a>

  <div class="calendar">

    <div class="col leftCol">
      <div class="content">
        <div class="notes">
          <form name="inputNote" action="saveNoteContent" id="inputNote">
            <input type="hidden" name="noteId" id="noteId" />
            <input type="hidden" name="noteDate" id="noteDate" />
            <div class="slidecontainer">
              <input type="range" name="noteProgress" id="noteProgress" value="0" placeholder="rate progress" min="0" max="5" step="1" class="slider" />
            </div>
            <br>
            <span>0 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;20&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
              40&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 60&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 80&nbsp;&nbsp;&nbsp;&nbsp;100 (%)</span>
            <textarea name="noteContent" id="noteContent" value="" placeholder="New note"></textarea>
            <!-- <input type="text" name="noteContent" id="noteContent" value="" placeholder="New note" />  -->
            <input type="button" id="saveButton" value="Save" p style="cursor:pointer" />
          </form>

          <!-- 날짜 클릭시 해당 날짜의 note를 이 곳에 display 해 줌.(noteList 아님. 매칭된 note는 하나임) -->
          <!-- 현재는 디버그용으로 용도가 바뀌었음!!! -->
          <div class="postIt" id="postIt">
            <div class="contents" id="contents">
              <input type="button" id="deleteButton" title="Remove note" class="deleteButton" p style="cursor:pointer" value="X" />
              <input type="button" id="modifyButton" title="Modify note" class="modifyButton" p style="cursor:pointer" value="Modify" />

              <!-- <ul><li><a href="#" title="Remove note" class="removeNote animate">X</a></li></ul> -->
              <!-- <ul><li><a href="#" title="Modify note" class="removeNote animate">Modify</a></li></ul> -->

              <!-- <input type="button" id="saveButton" value="Save" p style="cursor:pointer" /> -->

              	<ul class="noteList">
              	</ul>
              
              
            </div>
          </div>

        </div>
      </div>
    </div>

    <div class="col rightCol">
      <div class="content">
        <h2 class="curYear">${curYear}</h2>
		<script>
			/* 클릭된 날짜 Selected class 추가해줌 */
        	function daySelected(t) {
          		// 현재 selected 되어있던것들 모두 remove하고 선택된 것만 selected
          		var sections = document.querySelectorAll('[day-value]');
          		for (i = 0; i < sections.length; i++) {
           	 		sections[i].classList.remove('selected');
          		}
          		console.log(t);
          		document.querySelector('[title="' + t + '"]').classList.add("selected");
        	}
			
			/* 클릭된 날짜 Selected class 추가해주기 */
            function monthSelected(t) {
				
              // 현재 selected 되어있던것들 모두 remove하고 선택된 것만 selected
              var sections = document.querySelectorAll('[month-value]');
              for (i = 0; i < sections.length; i++) {
                sections[i].classList.remove('selected');
              }
              console.log(t+", "+typeof(t));
              document.querySelector('[title="' + t + '"]').classList.add("selected");   
              
              /*  Selected month의 Days(1~30) 다시 출력 */
              var today = new Date(); //오늘 날짜//내 컴퓨터 로컬을 기준으로 today에 Date 객체를 넣어줌
              var date = new Date(); //today의 Date를 세어주는 역할
              //이번 달의 첫째 날
              var tmpMonth = 0;
              if (t === 'Jan')
            	  tmpMonth = 1;
              else if (t === 'Feb')
            	  tmpMonth = 2;
              else if (t === 'Mar')
            	  tmpMonth = 3;
              else if (t === 'Apr')
            	  tmpMonth = 4;
              else if (t === 'May')
            	  tmpMonth = 5;
              else if (t === 'Jun')
            	  tmpMonth = 6;
              else if (t === 'Jul')
            	  tmpMonth = 7;
              else if (t === 'Aug')
            	  tmpMonth = 8;
              else if (t === 'Sep')
            	  tmpMonth = 9;
              else if (t === 'Oct')
            	  tmpMonth = 10;
              else if (t === 'Nov')
            	  tmpMonth = 11;
              else if (t === 'Dec')
            	  tmpMonth = 12;
              console.log("today.getMonth() : "+today.getMonth()+", "+typeof(today.getMonth()));
              console.log("tmpMonth : "+tmpMonth+", "+typeof(tmpMonth));
              
              var thisMonthDay1 = new Date(today.getFullYear(), tmpMonth, 1);
              //이번 달의 마지막 날
              //new를 써주면 정확한 월을 가져옴, getMonth()+1을 해주면 다음달로 넘어가는데 day를 1부터 시작하는게 아니라 0부터 시작하기 때문에 제대로 된 다음달 시작일(1일)은 못가져오고 1 전인 0, 즉 전달 마지막일 을 가져오게 된다
              var lastDate = new Date(today.getFullYear(), tmpMonth + 1, 0);

              var addSpace = '';
              //ThisMonth.getDay() = 이번 달 1일이 무슨 요일인지
              //getDay() : 요일을 알아내는 메소드. 반환값은 0부터 7까지이며 0은 일요일, 1은 월요일...
              //1일 전에 빈 칸 띄워주기
              $(".days li").remove();
              for (i = 0; i < thisMonthDay1.getDay(); i++) {
                //document.write('<li><a href="#">' + ' ' + '</a></li>');
                document.querySelector('.days').innerHTML += '<li><a href="#">' + ' ' + '</a></li>';
              }
              
  			
              /* Day(1~30) 출력 */
              for (var i = 1; i <= lastDate.getDate(); i++) {
                //document.write('<li><a class="reloadTrigger" href="#" onclick="daySelected(title);" id="' + i + '"title="' + i + '" day-value="' + i + '"' + addSpace + '>' + i + '</a></li>');
              	document.querySelector('.days').innerHTML += '<li><a class="reloadTrigger" href="#" onclick="daySelected(title);" id="' + i + '"title="' + i + '" day-value="' + i + '"' + addSpace + '>' + i + '</a></li>';
              }
              document.querySelector('[day-value="1"]').classList.add("selected");
              
              /*
              var html = "<li class='notes'>\n<p>";
              html += "<br>=== Debugging ===<br>";
              html += "Id: " + strs[0] + "<br>";
              html += "Date: " + strs[1] + "<br>";
              html += "Progress: " + strs[2] + "<br>";
              html += "Content: " + strs[3] + "";
              html += "</p>\n</li>";
              document.querySelector('.noteList').innerHTML += html;
              */
              
              
              
              
            }
			
			
         </script>
        <ul class="months">
          <li><a class="reloadTrigger" onclick="monthSelected(title);" href="#" title="Jan" month-value="1">Jan</a></li>
          <li><a class="reloadTrigger" onclick="monthSelected(title);" href="#" title="Feb" month-value="2">Feb</a></li>
          <li><a class="reloadTrigger" onclick="monthSelected(title);" href="#" title="Mar" month-value="3">Mar</a></li>
          <li><a class="reloadTrigger" onclick="monthSelected(title);" href="#" title="Apr" month-value="4">Apr</a></li>
          <li><a class="reloadTrigger" onclick="monthSelected(title);" href="#" title="May" month-value="5">May</a></li>
          <li><a class="reloadTrigger" onclick="monthSelected(title);" href="#" title="Jun" month-value="6">Jun</a></li>
          <li><a class="reloadTrigger" onclick="monthSelected(title);" href="#" title="Jul" month-value="7">Jul</a></li>
          <li><a class="reloadTrigger" onclick="monthSelected(title);" href="#" title="Aug" month-value="8">Aug</a></li>
          <li><a class="reloadTrigger" onclick="monthSelected(title);" href="#" title="Sep" month-value="9">Sep</a></li>
          <li><a class="reloadTrigger" onclick="monthSelected(title);" href="#" title="Oct" month-value="10">Oct</a></li>
          <li><a class="reloadTrigger" onclick="monthSelected(title);" href="#" title="Nov" month-value="11">Nov</a></li>
          <li><a class="reloadTrigger" onclick="monthSelected(title);" href="#" title="Dec" month-value="12">Dec</a></li>
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
          <!-- jsp는 한 번 쭉 읽고 끝임. onClickEvent로 반복해주는 것임. -->
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
            for (i = 0; i < thisMonthDay1.getDay(); i++) {
              document.write('<li><a href="#">' + ' ' + '</a></li>');
            }
            
			/* 클릭된 날짜 Selected class 추가해줌 */
            function daySelected(t) {
              // 현재 selected 되어있던것들 모두 remove하고 선택된 것만 selected
              var sections = document.querySelectorAll('[day-value]');
              for (i = 0; i < sections.length; i++) {
                sections[i].classList.remove('selected');
              }
              console.log(t);
              document.querySelector('[title="' + t + '"]').classList.add("selected");
            }
			
            /* Day(1~30) 출력 */
            for (var i = 1; i <= lastDate.getDate(); i++) {
              document.write('<li><a class="reloadTrigger" href="#" onclick="daySelected(title);" id="' + i + '"title="' + i + '" day-value="' + i + '"' + addSpace + '>' + i + '</a></li>');
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
