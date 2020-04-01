<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- <%@ page session="false"%> --%>
<html>

<head>
  <link href="<c:url value="/resources/css/testYL.css?ver=1" />"
  rel="stylesheet">

  <script src="http://code.jquery.com/jquery-latest.js?ver=123"></script>

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
    	function updateNoteList() {
        var year = "${curYear}"
        var month = document.querySelector(".months li a.selected").getAttribute("month-value");
        var day = document.querySelector(".days li a.selected").text;
        month = month.length == 1 ? "0" + month.slice(0) : month;
        day = day.length == 1 ? "0" + day.slice(0) : day;
		
        $.ajax({
          url: "testYLReloadDBMatching",
          type: "post",
          data: {
            'year': year,
            'month': month,
            'day': day
          },

          //serialize() : 입력된 모든 Element를 문자열의 데이터에 serialize 한다.
          //{data1: value1, data2: value2, ...}
          success: function (data) {
            $(".noteList li").remove();

            if (data != "") {
              var strs = data.split("|");
              var html = "<li>";
              html += "Id: " + strs[0] + "<br>";
              html += "Date: " + strs[1] + "<br>";
              html += "Progress: " + strs[2] + "<br>";
              html += "Content: " + strs[3] + "";
              html += "</li>";
              document.querySelector('.noteList').innerHTML += html;
            }
           
          },
          error: function (request, status, error) {
            alert("code = " + request.status + " message = " + request.responseText + " error = " + error);
          }
        });
      }
      
      function updateProgressColors() {
          var year = "${curYear}"
          var month = document.querySelector(".months li a.selected").getAttribute("month-value");
          
          $.ajax({
            url: "loadNoteListByMonth",
            type: "post",
            data: {
              'year': year,
              'month': month,
            },

            //serialize() : 입력된 모든 Element를 문자열의 데이터에 serialize 한다.
            //{data1: value1, data2: value2, ...}
            success: function (data) {
              $(".noteList li").remove();

              if (data != "") {
                var strs = data.split("|");
                var html = "<li>";
                html += "Id: " + strs[0] + "<br>";
                html += "Date: " + strs[1] + "<br>";
                html += "Progress: " + strs[2] + "<br>";
                html += "Content: " + strs[3] + "";
                html += "</li>";
                document.querySelector('.noteList').innerHTML += html;
              }
             
            },
            error: function (request, status, error) {
              alert("code = " + request.status + " message = " + request.responseText + " error = " + error);
            }
          });
          }
      
      updateNoteList();
      updateProgressColors();
      $('.reloadTrigger').click(function (e) {
        e.preventDefault();
        updateNoteList();
        updateProgressColors();
      });


      // ibutton 클릭 시
      $('#ibutton').click(function (e) {
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
          //dataType: "JSON", dataType 주석 처리 하니 에러 없어짐
          //serialize() : 입력된 모든 Element를 문자열의 데이터에 serialize 한다.
          data: $("#inputNote").serialize(),
          cache: false,
          success: function (data) {
            alert("data.noteId: " + data.noteId);
            successFunction();
            $("#noteProgress").val('');
            $("#noteContent").val('');
          },
          error: function (request, status, error) {
            alert("code = " + request.status + " message = " + request.responseText + " error = " + error);
          }
        });
      });


      function successFunction() {
        /* 사용자가 입력한 noteProgress(0~5)만큼 색깔 지정(비동기 방식. 새로고침 하지 않아도 적용됨) */
        if (document.querySelector("#noteProgress").value == "1") {
        	$(".days li a.selected").css("background-color", "#E8F8F5");
        }
        else if (document.querySelector("#noteProgress").value == "2") {
        	$(".days li a.selected").css("background-color", "#D1F2EB");
        }
        else if (document.querySelector("#noteProgress").value == "3") {
        	$(".days li a.selected").css("background-color", "#A3E4D7");
        }
        else if (document.querySelector("#noteProgress").value == "4") {
        	$(".days li a.selected").css("background-color", "#76D7C4");
        }
        else if (document.querySelector("#noteProgress").value == "5") {
        	$(".days li a.selected").css("background-color", "#48C9B0");
        }
      };
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
            <input type="text" name="noteContent" id="noteContent" value="" placeholder="New note" />
            <input type="button" id="ibutton" value="Save" p style="cursor:pointer" />
          </form>

		<!-- 날짜 클릭시 해당 날짜의 note를 이 곳에 display 해 줌.(noteList 아님. 매칭된 note는 하나임) -->
          <ul class="noteList">
          </ul>
          
        </div>
      </div>
    </div>

    <div class="col rightCol">
      <div class="content">
        <h2 class="curYear">${curYear}</h2>

        <ul class="months">
          <li><a class="reloadTrigger" href="#" title="Jan" month-value="1">Jan</a></li>
          <li><a class="reloadTrigger" href="#" title="Feb" month-value="2">Feb</a></li>
          <li><a class="reloadTrigger" href="#" title="Mar" month-value="3">Mar</a></li>
          <li><a class="reloadTrigger" href="#" title="Apr" month-value="4">Apr</a></li>
          <li><a class="reloadTrigger" href="#" title="May" month-value="5">May</a></li>
          <li><a class="reloadTrigger" href="#" title="Jun" month-value="6">Jun</a></li>
          <li><a class="reloadTrigger" href="#" title="Jul" month-value="7">Jul</a></li>
          <li><a class="reloadTrigger" href="#" title="Aug" month-value="8">Aug</a></li>
          <li><a class="reloadTrigger" href="#" title="Sep" month-value="9">Sep</a></li>
          <li><a class="reloadTrigger" href="#" title="Oct" month-value="10">Oct</a></li>
          <li><a class="reloadTrigger" href="#" title="Nov" month-value="11">Nov</a></li>
          <li><a class="reloadTrigger" href="#" title="Dec" month-value="12">Dec</a></li>
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
              for (i = 0; i < sections.length; i++) {
                sections[i].classList.remove('selected');
              }
              console.log(t);
              document.querySelector('[title="' + t + '"]').classList.add("selected");
            }
            //1일부터 마지막 일까지 돌림
            for (var i = 1; i <= lastDate.getDate(); i++) {
              document.write('<li><a class="reloadTrigger" href="#" onclick="callFunction(title);" id="' + i + '"title="' + i + '" day-value="' + i + '"' + addSpace + '>' + i + '</a></li>');
            }

            document.querySelector('[day-value="${curDay}"]').classList.add("selected");


           	/* noteProgress 수치만큼 날짜에 background-color 입히기 */

       		//JSON.parse() = String 객체를 json 객체로 형변환 시켜준다.
            var json_arr = JSON.parse('${jsonList}');
            for(var i=0; i<json_arr.length; i++) { // DB에 저장된 모든 noteList 개수만큼 반복
            	// id 확인
            	if ("${member.memId}" == "") { //현재 로그인 상태가 아니면
            		continue ;
            	}
    			if ("${member.memId}" != json_arr[i].noteId)
    				continue ;

            	// 날짜 확인
            	var monthValue = json_arr[i].noteDate.substring(5,7);
            	if(monthValue.charAt(0) == '0') {
            		monthValue = monthValue.substring(1,2);
            	}

            	var monthSelected = document.querySelector(".months li a.selected").getAttribute("month-value");
				if (monthSelected != monthValue) { //현재 selected된 monthSelected와 noteList의 monthValue가 같은지 확인
            		continue ;
            	}

            	var dayValue = json_arr[i].noteDate.substring(8,10);
            	if(dayValue.charAt(0) == '0') {
            		dayValue = dayValue.substring(1,2);
            	}


            	// noteProgress값에 해당하는 backgroundColor 지정
            	if (json_arr[i].noteProgress == 1) {
            		var el = document.getElementById(dayValue);
            		el.style.backgroundColor="#E8F8F5";
            	}
            	else if (json_arr[i].noteProgress == 2) {
            		var el = document.getElementById(dayValue);
            		el.style.backgroundColor="#D1F2EB";
            	}
            	else if (json_arr[i].noteProgress == 3) {
            		var el = document.getElementById(dayValue);
            		el.style.backgroundColor="#A3E4D7";
            	}
            	else if (json_arr[i].noteProgress == 4) {
            		var el = document.getElementById(dayValue);
            		el.style.backgroundColor="#76D7C4";
            	}
            	else if (json_arr[i].noteProgress == 5) {
            		var el = document.getElementById(dayValue);
            		el.style.backgroundColor="#48C9B0";
            	}
            }
          </script>
        </ul>
        <div class="clearfix"></div>
      </div>
    </div>

    <div class="clearfix"></div>

  </div>


</body>

</html>
