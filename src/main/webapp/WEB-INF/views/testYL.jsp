<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- <%@ page session="false"%> --%>
<html>

<head>
  <link href="<c:url value="/resources/css/testYL.css?after" />" rel="stylesheet">

  <!-- <script type="text/javascript" src="JS/jquery-1.4.2.min.js"></script>  -->
  <!-- <script src="./js/jquery-1.4.2.min.js"></script>  -->
  <script src="http://code.jquery.com/jquery-latest.js?ver=123"></script>

  <script type="text/javascript">
    $(document).ready(function () {

      function updateNoteList() {
        var year = "${curYear}"
        var month = document.querySelector(".months li a.selected").getAttribute("month-value");
        var day = document.querySelector(".days li a.selected").text;
        month = month.length == 1 ? "0" + month.slice(0) : month;
        day = day.length == 1 ? "0" + day.slice(0) : day;

        $.ajax({
          // url: "testYLReloadDBALL",
          url: "testYLReloadDBMatching",
          type: "post",
          data: {'year': year, 'month': month, 'day': day},

          //serialize() : 입력된 모든 Element를 문자열의 데이터에 serialize 한다.
          //{data1: value1, data2: value2, ...}
          success: function (data) {
            // alert("Reloading all note DB success! (No need to login)");
            // alert("Loading matching note from DB success!: " + data);

            // document.querySelectorAll('.noteList li').forEach(el => el.remove());
            // Spring 내부 브라우저에서는 ES6 문법이 지원 안 된다...IE11인가 보다.
            // IE11은 어떻게 ES6 지원율이 0%지? 빌어먹을 만악의 근원
            // ES6 쓰려면 호환성 때문에 Babel 써서 ES6 -> ES5로 polyfill 해야되잖아...
            // 그냥 jQuery로 땜빵하자...
            $(".noteList li").remove();

            if (data != "")
            {
              var strs = data.split("|");
              var html = "<li>";
              html += "Id: " + strs[0] + "<br>";
              html += "Date: " + strs[1] + "<br>";
              html += "Progress: " + strs[2] + "<br>";
              html += "Content: " + strs[3] + "";
              html += "</li>";
              document.querySelector('.noteList').innerHTML += html;
            }
            // for(var i = 0; i < data.length; i++) {
            //   var html = "<li>";
            //   html += "Id: " + data[0].noteId + "<br>";
            //   html += "Date: " + data[1].noteDate + "<br>";
            //   html += "Progress: " + data[2].noteProgress + "<br>";
            //   html += "Content: " + data[3].noteContent + "";
            //   html += "</li>";
            //   document.querySelector('.noteList').innerHTML += html;
            // }

            // <c:forEach items="${noteList}" var="noteUnit">
            //   var html = "<li>";
            //   html += "Id:${noteUnit.noteId}<br>";
            //   html += "Date: ${noteUnit.noteDate}<br>";
            //   html += "Progress: ${noteUnit.noteProgress}<br>";
            //   html += "Content: ${noteUnit.noteContent}";
            //   html += "</li>";
            //   document.querySelector('.noteList').innerHTML += html;
            // </c:forEach>
          },
          error: function (request, status, error) {
            alert("code = " + request.status + " message = " + request.responseText + " error = " + error);
          }
        });
      }

      updateNoteList();

      $('.reloadTrigger').click(function (e) {
        e.preventDefault();

        updateNoteList();
      });


      // ibutton 클릭 시
      $('#ibutton').click(function (e) {
        e.preventDefault();
        //selected된 날짜 넣어주기
        var year = "${curYear}"
        var month = document.querySelector(".months li a.selected").getAttribute("month-value");
        var day = document.querySelector(".days li a.selected").text;
        month = month.length == 1 ? "0" + month.slice(0) : month;
        day = day.length == 1 ? "0" + day.slice(0) : day;

        if ("${member}") {
          document.querySelector("#noteId").value = "${member.memId}";
          document.querySelector("#noteDate").value = year + "-" + month + "-" + day;
          console.log("memId: ${member.memId}");
        } else {
          console.log("Need Login!");
          alert("You need to login.");
        }
        /*
			url: 통신을 원하고자 하는 URL 주소(필수 입력 값)
        	data: 서버로 보낼 데이터
        	type: GET, POST 등의 통신 방식 지정
        	dataType: 통신의 결과로 넘어올 데이터의 종류 지정
        	success(data): 통신 성공시 호출 해야하는 함수를 지정. 매개변수 결과로 넘어온 데이터를 받음.
        	error: 통신 실패시 호출 해야하는 함수 지정
        	complete: 통신 성공 여부와 관계없이 통신이 끝난 후 호출 해야하는 함수를 지정
        	beforeSend: 통신 전에 호출 해야하는 함수를 지정
        	async: 비동기(true), 동기(true) 여부를 지정
        	*/
        $.ajax({
          url: "saveNoteContent",
          type: "post",
          //dataType: "JSON",
          //serialize() : 입력된 모든 Element를 문자열의 데이터에 serialize 한다.
          //{data1: value1, data2: value2, ...}
          data: $("#inputNote").serialize(),
          cache: false,
          success: function (data) {
            alert("data.noteId: " + data.noteId);
            $("#noteProgress").val('');
            $("#noteContent").val('');
            successFunction();
          },
          error: function (request, status, error) {
            alert("code = " + request.status + " message = " + request.responseText + " error = " + error);
          }
        });
      });


      function successFunction() {
        //day-value가 day이면 색깔 설정
        var day = document.querySelector(".days li a.selected").text;
        console.log(day);

        $(".days li a.selected").css("background-color", "#E8F8F5");
      };


    });


    /*
	success : function(data) { 통신이 성공적으로 이루어졌을 때 }
    complete : function(data) { 통신이 실패했어도 완료가 되었을 때 }
	complete or success 둘 중 하나만 써야 함.
	error : function(xhr, status, error) { alert("에러 발생"); }
	*/
    /*
      $('#execute').click(function(){ //ID가 execute인 버튼을 클릭했을때 function 실행
        $.ajax({ //ajax 통신을 한다.
            url:'./time2.php',
            type:'post', //default는 get
            data:$('form').serialize(), //서버로 전송할 데이터
            success:function(data){
                $('#time').text(data);
            }
        //성공했을떄 id가 time이라는 엘리먼트에 text로 추가해라.
        })
    })
    });
       */
    // @@T 날짜 클릭시 noteList 전부 지우고 선택된 날짜들 끌어와서 업데이트?
    //
    // 내가 구현할 함수
    //
    // querySelectAll등 js를 활용하여 <ul class="noteList"> 내부의 모든 <li> 내용을 지운다.
    // 같은 url requestMapping을 발동시킨다.
    // jsp에서 controller로 건네준 note 커맨드 객체의 noteDate 및 noteId와 일치하는 note들을 DB에서 읽어온다.
    // 읽어온 note들은 list<note> notes; 에 저장한다.
    // session에다가 notes를 등록한다.
    // notelist 파트를 day 파트처럼 동적으로 다시 생성한다.
  </script>

</head>

<body>
  <a href="${cp}">MAIN</a>

  <div class="calendar">

    <div class="col leftCol">
      <div class="content">
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
          <%-- note라는 이름의 커맨드 객체를 Controller에 전송 --%>
          <%-- <form name="inputNote" action="saveNoteContent" id="inputNote" commandName="note"> --%>

          <%-- commandName="note"라고 커맨드 객체 이름을 따로 명시하지 않아도 note 커맨드 객체로 인식해서 자동으로 전송되네... 자동화 퀄 보소 --%>
          <form name="inputNote" action="saveNoteContent" id="inputNote">
            <input type="hidden" name="noteId" id="noteId" />
            <input type="hidden" name="noteDate" id="noteDate" />
            <input type="number" name="noteProgress" id="noteProgress" value="" placeholder="rate progress" min="0" max="5" step="1" oninput="
            if(this.value > 5) value = 5;
            if(this.value < 0) value = 0;
            " />
            <input type="text" name="noteContent" id="noteContent" value="" placeholder="new note" />
            <input type="button" id="ibutton" value="Save" p style="cursor:pointer" />
          </form>

          <ul class="noteList">
            <!-- <li>note: ${note} / note.noteDate: ${note.noteDate} <a href="#" title="Remove note" class="removeNote animate">x</a></li> -->
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
          <li><a class="reloadTrigger" href="#" title="Mon" data-value="1">Mon</a></li>
          <li><a class="reloadTrigger" href="#" title="Tue" data-value="2">Tue</a></li>
          <li><a class="reloadTrigger" href="#" title="Wed" data-value="3">Wed</a></li>
          <li><a class="reloadTrigger" href="#" title="Thu" data-value="4">Thu</a></li>
          <li><a class="reloadTrigger" href="#" title="Fri" data-value="5">Fri</a></li>
          <li><a class="reloadTrigger" href="#" title="Say" data-value="6">Sat</a></li>
          <li><a class="reloadTrigger" href="#" title="Sun" data-value="7">Sun</a></li>
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
              document.write('<li><a class="reloadTrigger" href="#" onclick="callFunction(title);" title="' + i + '" day-value="' + i + '"' + addSpace + '>' + i + '</a></li>');
            }


            document.querySelector('[day-value="${curDay}"]').classList.add("selected");
          </script>
        </ul>
        <div class="clearfix"></div>
      </div>
    </div>

    <div class="clearfix"></div>

  </div>

  <!-- DEBUG -->
  <div class="DEBUG">
    <p class="date">
      === DEBUG ===<br>
      testYL.jsp<br>
      cp: ${cp}<br>
      serverTime: ${serverTime}<br>
      member: ${member}<br>
      memId: ${member.memId}<br>
      memPw: ${member.memPw}<br>
      memMail: ${member.memMail}<br>

      <%-- <해결 완료>
    왜 note 는 새로고침 할 때마다 항상 note 주소가 변하고 null값만 가득 차는거지?
    이유를 모르겠다...
    아무튼 ${note.noteId} 결과값이 항상 null이었던 원인은 발견했네.

    @RequestMapping("/testYL")
  //public String goToTestYL(Note note) {
    public String goToTestYL() {
      return "testYL";
    }
    이게 원인이었구나!! 이 빌어먹을 놈!!! 드디어 찾았다!!
    --%>
      note: ${note}<br>
      noteId: ${note.noteId}<br>
      noteDate: ${note.noteDate}<br>
      noteProgress: ${note.noteProgress}<br>
      noteContent: ${note.noteContent}<br>

      <c:forEach items="${noteList}" var="noteUnit">
        ${noteUnit.noteContent}
      </c:forEach>
    </p>
  </div>

</body>

</html>
