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
  <link href="<c:url value='/resources/css_my/main.css?${serverTime}' />" rel="stylesheet">
  <script src="http://code.jquery.com/jquery-latest.js"></script>

  <script type="text/javascript">
    // https://learn.jquery.com/using-jquery-core/document-ready/
    //
    // Code Workflow
    // 1. 처음 : html css javascript 상관 없이 위에서 아래로 쭉 실행
    // 2. $(document).ready(function () { ... }) : function() 내부 내용 쭉 실행
    // 3. $( window ).on( "load", function() { ... }) 내부 내용 쭉 실행

    /* 함수포인터를 전역변수로 선언하면 ready 내부의 function을 밖에서도 쓸 수 있다! */

    var addClickEventToUpdateTriggers;
    var updateAll; // updateNoteList(); updateProgressColors();
    var yearCurrent = new Date().getFullYear();
    var g_qId = "";

    //////////////////////////////////////////////////////////////////////////
    $(document).ready(function () {
      /* updateNoteList 함수는 조건에 맞는 note를 DB로부터 끌어온다.
        1. DOM에서 .selected 클래스가 붙은 element를 찾아 year, month, day값을 받아오고
        2. 그 값들을 $.ajax를 통해 post 방식으로 mainReloadDBMatching url로 request 한 후
        3. NoteController.java의 mainReloadDBMatching 메소드에서 @RequestParam으로 값을 넘겨 받으면
        4. 거기서 noteId와 noteDate값을 구한 후 이 둘이 매칭되는 노트를 DB로부터 가져온다.
        5. 이후 가져온 노트와 관련된 데이터를 @ResponseBody 로 리턴하면
        6. $.Ajax에서 리턴된 그 값을 다시 넘겨받는다.
        7. 넘겨받은 값은 success: function(data) 형식으로 사용할 수 있다. (return 값 == data 값)
       */

      function updateNoteList(qId) {
        var year = yearCurrent;
        var month = document.querySelector(".months li a.selected").getAttribute("month-value");
        var day = document.querySelector(".days li a.selected").text;
        month = month.length == 1 ? "0" + month.slice(0) : month;
        day = day.length == 1 ? "0" + day.slice(0) : day;

        // debugging
        document.querySelector("#showQId").value = g_qId;
        document.querySelector("#showMemId").value = "${member.memId}";


        $.ajax({
          url: "loadNoteListByDate",
          type: "post",
          data: {
            'year': year,
            'month': month,
            'day': day,
            'qId': qId
          },

          success: function (data) {

            $("#noteContent").val("");
            $("#noteContent").focus();

            var strs = data.split("|");
            // strs = [noteId, noteDate, noteProgress, noteContent];

            $(".noteList li").remove();
            if (strs[0] === "noMatchingData") {
              document.querySelector("#noteProgress").value = 0;
              document.querySelector("#noteContent").value = "";

              // // @@T
              // if (qId !== "${member.memId}")
              //   alert(strs[0] + ": The user [" + qId + "] does not exist OR has no data!");

            } else if (strs[0] !== "") {
              document.querySelector("#noteProgress").value = strs[2];

              // wrap='hard': wraps the words inside the text box and places line breaks at the end of each line
              var html = "<li class='notes'>\n<pre wrap='hard'>";
              html += "<br>" + strs[3] + "";
              html += "</pre>\n</li>";
              document.querySelector('.noteList').innerHTML += html;
            } else {
              alert("debug: ...!!? something is wrong!")
            }
          },

          error: function (request, status, error) {
            alert("[updateNoteList] code = " + request.status + " message = " + request.responseText + " error = " + error);
          }
        });
      }

      //////////////////////////////////////////////////////////////////////////
      /* 페이지를 로드할 때마다 DB에서 현재 로그인 id, year, month와 일치하는 note들을 모두 찾아와서 noteProgress value별로 색깔을 입혀줌. */
      function updateProgressColors(qId) {
        var year = yearCurrent;
        var month = document.querySelector(".months li a.selected").getAttribute("month-value");
        month = month.length == 1 ? "0" + month.slice(0) : month; //1월 -> 01월

        $.ajax({
          url: "loadNoteListByMonth",
          //dataType: 서버에서 return되는 데이터 형식
          dataType: 'json',
          type: "post",
          data: {
            'year': year,
            'month': month,
            'qId': qId
          },

          success: function (data) {
            // 색 미리 입혀진 거 지워주기 위함
            $(".days li a").css('background-color', "");

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
            alert("[updateProgressColors] code = " + request.status + " message = " + request.responseText + " error = " + error);
          }
        });
      }

      // 일반적으로 parameter qId에 argument memId 값이 기본값으로 할당된다.
      // 단, searchButton으로 호출되었을 시에는 searchInput의 값이 할당된다.
      updateAll = function (qId) {

        var memId = "${member.memId}"
        var displayValue = "";
        var elNoteProgress = document.querySelector("#noteProgress");
        // qId: 검색한/출력할 아이디, memId: 로그인 한 아이디
        if (qId === "" && memId === "") {
          displayValue = "none";
          elNoteProgress.disabled = true;
        } else if (qId === "" && memId !== "") {
          qId = memId;
          displayValue = "block";
          elNoteProgress.disabled = false;
        } else if (qId !== memId) {
          displayValue = "none";
          elNoteProgress.disabled = true;
        } else if (qId === memId) {
          displayValue = "block";
          elNoteProgress.disabled = false;
        }

        $(".needAuthority").css("display", displayValue);
        // var elements = document.querySelectorAll(".needAuthority");
        // var length = elements.length;
        // for (var index = 0; index < length; index++) {
        //   elements[index].style.display = displayValue;
        // }

        updateNoteList(qId);
        updateProgressColors(qId);
      }

      //////////////////////////////////////////////////////////////////////////

      /* modifyButton 누르면 noteContent(입력창)의 값을 post-it값으로 바꾸고 커서 포커싱 */
      $('.modifyButton').click(function (e) {
        $("#noteContent").val(
          $(".noteList li pre").text()
        );
        $("#noteContent").focus();
      });

      //////////////////////////////////////////////////////////////////////////

      /* SAVE 버튼 클릭 시 */
      $('#saveButton').click(function (e) {
        e.preventDefault(); //a 태그의 href를 비활성화
        /* selected된 날짜 넣어주기 */
        var year = yearCurrent;
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

        if (g_qId === "")
          g_qId = "${member.memId}";
        /* form 태그를 통해 input 값으로 들어온 noteProgress와 noteContent를 비동기 POST 방식으로 전송*/
        $.ajax({
          url: "saveNoteContent",
          type: "post",
          //dataType: "JSON", dataType 주석 처리 하니 에러 없어짐 //왜인지 알아보자!
          //serialize() : 입력된 모든 Element를 문자열의 데이터에 serialize 한다.
          data: $("#inputNote").serialize() + "&qId=" + g_qId,
          cache: false,
          success: function (data) {
            if (data === "success") {
              updateAll(g_qId);
            } else if (data === "detectedHacking") {
              // qId != "" && qId != memId
              alert("Nice try... you little rat!! Did you think you could ruin other user's data? really? lol lol");
            }
          },
          error: function (request, status, error) {
            alert("[saveButton] code = " + request.status + " message = " + request.responseText + " error = " + error);
          }
        });
      });

      //////////////////////////////////////////////////////////////////////////

      // deleteButton 클릭 시
      $('#deleteButton').click(function (e) {
        e.preventDefault();
        /* selected된 날짜 넣어주기 */
        var year = yearCurrent;
        var month = document.querySelector(".months li a.selected").getAttribute("month-value");
        var day = document.querySelector(".days li a.selected").text;
        month = month.length == 1 ? "0" + month.slice(0) : month;
        day = day.length == 1 ? "0" + day.slice(0) : day;

        if (g_qId === "")
          g_qId = "${member.memId}";
        $.ajax({
          url: "deleteNote",
          type: "post",
          //dataType: "JSON", dataType 주석 처리 하니 에러 없어짐 //왜인지 알아보자!
          //serialize() : 입력된 모든 Element를 문자열의 데이터에 serialize 한다.
          data: {
            'year': year,
            'month': month,
            'day': day,
            'qId': g_qId
          },
          cache: false,
          success: function (data) {
            if (data === "success") {
              $(".noteList li").remove();
              $(".days li a.selected").css("background-color", "#ffffff");
            } else if (data === "detectedHacking") {
              // qId != "" && qId != memId
              alert("Nice try... you little rat!! Did you think you could ruin other user's data? really? lol lol");
            }
          },
          error: function (request, status, error) {
            alert("[deleteButton] code = " + request.status + " message = " + request.responseText + " error = " + error);
          }
        });
      })

      /* 날짜 초기화, 날짜 선택, 달 선택시 아래 함수 콜 */
      addClickEventToUpdateTriggers = function () {
        // $('.updateTrigger').click(function (e) {

        // $('.updateTrigger').unbind("click.addClickEventToUpdateTriggers");
        // $('.updateTrigger').bind("click.addClickEventToUpdateTriggers", function (e) {
        $('.updateTrigger').off("click.noMoreDuplicated");
        $('.updateTrigger').on("click.noMoreDuplicated", function (e) {
          updateAll(g_qId);
          console.log("updateTrigger가 실행되었습니다.");
        });

        console.log("addClickEventToUpdateTriggers 실행 완료")
      };

      addClickEventToUpdateTriggers();
      updateAll(g_qId);
    });

    /* event 가 무엇인지 보고 싶을 때 참고 */
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
  </script>

</head>

<body>
  <c:if test="${empty member}">
    <a href="${cp}/member/loginForm">LOGIN</a> &nbsp;&nbsp;
  </c:if>

  <c:if test="${!empty member}">
    <a href="${cp}/member/logout">LOGOUT</a> &nbsp;
    <div class="removeMem">
      <a href="${cp}/member/removeForm">REMOVE</a> &nbsp;&nbsp;&nbsp;
    </div>

    <div class="modifyMem">
      <a href="${cp}/member/modifyForm">MODIFY</a> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    </div>
  </c:if>


  <div class="search-container">
    <input id="searchInput" type="text" placeholder="Search user.." name="search" />
    <button id="searchButton" type="button">Search</button>
  </div>

  <div class="debugging">
    <br>
    <br>
    <p style="color:black; font-size: 20px;">debugging: in updateNoteList</p style="color:black;">
    <p style="color:black;">g_qId</p style="color:black;">
    <input id="showQId" type="text">
    <br>
    <p style="color:black;">memId</p style="color:black;">
    <input id="showMemId" type="text">
  </div>

  <script>
    // function sayHo() {
    //   alert("Ho!")
    // }
    //    searchButton.addEventListener("click", function(e){ sayHo() });
    // == searchButton.onclick = function(e){ sayHo() };
    // == $("#searchButton").click(function(e) {sayHo()});
    //
    // != $("#searchButton").click(sayHo());
    // click 이벤트가 부여되지도 않고, sayHo(); 1회 자동실행 된 후 먹통

    // Get the input field
    var searchInput = document.querySelector("#searchInput");
    var searchButton = document.querySelector("#searchButton");

    // Execute a function when the user releases a key on the keyboard
    searchInput.addEventListener("keyup", function (event) {
      // Number 13 is the "Enter" key on the keyboard
      if (event.keyCode === 13) {
        // Cancel the default action, if needed
        event.preventDefault();
        // Trigger the button element with a click
        searchButton.click();
      }
    });

    searchButton.onclick = function (e) {
      g_qId = searchInput.value;
      if (g_qId !== "")
        updateAll(g_qId);
    }
  </script>

  <div class="calendar">

    <div class="col leftCol">
      <div class="content">
        <div class="notes">
          <form name="inputNote" action="saveNoteContent" id="inputNote">
            <input type="hidden" name="noteId" id="noteId" />
            <input type="hidden" name="noteDate" id="noteDate" />
            <div class="slideContainer">
              <input type="range" name="noteProgress" id="noteProgress" value="0" placeholder="rate progress" min="0" max="5" step="1" class="slider" />
            </div>
            <br>
            <span>0 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;20&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
              40&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 60&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 80&nbsp;&nbsp;&nbsp;&nbsp;100 (%)</span>
            <textarea name="noteContent" id="noteContent" value="" placeholder="New note" class="needAuthority"></textarea>
            <button id="saveButton" class="needAuthority" style="cursor: pointer">Save</button>
          </form>

          <div class="postIt" id="postIt">
            <div class="contents" id="contents">

              <button id="deleteButton" title="Remove note" class="deleteButton needAuthority" style="cursor: pointer;">X</button>
              <button id="modifyButton" title="Modify note" class="modifyButton needAuthority" style="cursor: pointer;">Modify</button>

              <!-- 날짜 클릭시 해당 날짜의 note를 이 곳에 display 해 줌.(noteList 아님. 매칭된 note는 하나임) -->
              <ul class="noteList">
              </ul>

            </div>
          </div>

        </div>
      </div>
    </div>

    <script>
      function printDays() {
        var today = new Date(); //오늘 날짜.  내 컴퓨터 로컬을 기준으로 today에 Date 객체를 넣어줌
        var date = new Date(); //today의 Date를 세어주는 역할

        tmpMonth = document.querySelector(".months li a.selected").getAttribute("month-value");
        //var thisMonthDay1 = new Date(today.getFullYear(), tmpMonth-1, 1);
        var thisMonthDay1 = new Date(yearCurrent, tmpMonth - 1, 1);
        //이번 달의 마지막 날
        //new를 써주면 정확한 월을 가져옴, getMonth()+1을 해주면 다음달로 넘어가는데 day를 1부터 시작하는게 아니라 0부터 시작하기 때문에 제대로 된 다음달 시작일(1일)은 못가져오고 1 전인 0, 즉 전달 마지막일 을 가져오게 된다
        var lastDate = new Date(yearCurrent, tmpMonth, 0);

        var addSpace = '';
        //ThisMonth.getDay() = 이번 달 1일이 무슨 요일인지
        //getDay() : 요일을 알아내는 메소드. 반환값은 0부터 7까지이며 0은 일요일, 1은 월요일...
        //1일 전에 빈 칸 띄워주기
        $(".days li").remove();
        for (i = 0; i < thisMonthDay1.getDay(); i++) {
          document.querySelector('.days').innerHTML += '<li><p>' + ' ' + '</p></li>';
        }

        /* Day(1~30) 출력 */
        for (var i = 1; i <= lastDate.getDate(); i++) {
          document.querySelector('.days').innerHTML += '<li><a class="updateTrigger" href="#" onclick="daySelected(title);" id="' + i + '"title="' + i + '" day-value="' + i + '"' + addSpace + '>' + i + '</a></li>';
        }
        document.querySelector('[day-value="1"]').classList.add("selected"); //다른 month 클릭했을 때 임의로 1일에 selected 해줌(안 하면 day=null 에러)
      }
    </script>
    <div class="col rightCol">
      <div class="content">
        <button class="updateTrigger" onclick="goToAfterYear(); printDays();" id="afterYear" style="cursor:pointer">&nbsp;&nbsp;&gt;</button>
        <h2 id="year" class="curYear"></h2>
        <button class="updateTrigger" onclick="goToPrevYear(); printDays();" id="prevYear" style="cursor:pointer">&lt;&nbsp;&nbsp;</button><br><br><br>
        <script>
          /*  < 2020 >   '<' 클릭시 year - 1, '<' 클릭시 year + 1 */
          //var yearCurrent = new Date().getFullYear();
          document.getElementById("year").innerHTML = yearCurrent;


          function goToPrevYear() {
            --yearCurrent;
            document.querySelector("#year").textContent = yearCurrent;
          }

          function goToAfterYear() {
            ++yearCurrent;
            document.querySelector("#year").textContent = yearCurrent;
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

          /* 클릭된 날짜 Selected class 추가해주기 */
          function monthSelected(t) {
            console.log("yearCurrent : " + yearCurrent);

            // 현재 selected 되어있던것들 모두 remove하고 선택된 것만 selected
            var sections = document.querySelectorAll('[month-value]');
            for (i = 0; i < sections.length; i++) {
              sections[i].classList.remove('selected');
            }
            console.log(t + ", " + typeof (t));
            document.querySelector('[title="' + t + '"]').classList.add("selected");

            /*  Selected month의 Days(1~30) 다시 출력 */

            /* Days 생성하는 함수 */
            printDays();

            if (addClickEventToUpdateTriggers != undefined) {
              addClickEventToUpdateTriggers();
            }

            updateAll(g_qId);
          }
        </script>
        <ul class="months">
          <li><a class="updateTrigger" onclick="monthSelected(title);" href="#" title="Jan" month-value="1">Jan</a></li>
          <li><a class="updateTrigger" onclick="monthSelected(title);" href="#" title="Feb" month-value="2">Feb</a></li>
          <li><a class="updateTrigger" onclick="monthSelected(title);" href="#" title="Mar" month-value="3">Mar</a></li>
          <li><a class="updateTrigger" onclick="monthSelected(title);" href="#" title="Apr" month-value="4">Apr</a></li>
          <li><a class="updateTrigger" onclick="monthSelected(title);" href="#" title="May" month-value="5">May</a></li>
          <li><a class="updateTrigger" onclick="monthSelected(title);" href="#" title="Jun" month-value="6">Jun</a></li>
          <li><a class="updateTrigger" onclick="monthSelected(title);" href="#" title="Jul" month-value="7">Jul</a></li>
          <li><a class="updateTrigger" onclick="monthSelected(title);" href="#" title="Aug" month-value="8">Aug</a></li>
          <li><a class="updateTrigger" onclick="monthSelected(title);" href="#" title="Sep" month-value="9">Sep</a></li>
          <li><a class="updateTrigger" onclick="monthSelected(title);" href="#" title="Oct" month-value="10">Oct</a></li>
          <li><a class="updateTrigger" onclick="monthSelected(title);" href="#" title="Nov" month-value="11">Nov</a></li>
          <li><a class="updateTrigger" onclick="monthSelected(title);" href="#" title="Dec" month-value="12">Dec</a></li>
        </ul>
        <script>
          document.querySelector('[month-value="${curMonth}"]').classList.add("selected");
        </script>
        <div class="clearfix"></div>
        <ul class="weekdays">
          <li><a id="Sun" data-value="1">Sun</a></li>
          <li><a id="Mon" data-value="2">Mon</a></li>
          <li><a id="Tue" data-value="3">Tue</a></li>
          <li><a id="Wed" data-value="4">Wed</a></li>
          <li><a id="Thu" data-value="5">Thu</a></li>
          <li><a id="Fri" data-value="6">Fri</a></li>
          <li><a id="Sat" data-value="7">Sat</a></li>
        </ul>
        <script>
          $("#Sun").css("color", "red");
          $("#Sat").css("color", "blue");
        </script>
        <div class="clearfix"></div>
        <ul class="days">
          <script>
            //  jsp는 한 번 쭉 읽고 끝임. onClickEvent로 반복해주는 것임.
            var today = new Date(); //오늘 날짜//내 컴퓨터 로컬을 기준으로 today에 Date 객체를 넣어줌
            var date = new Date(); //today의 Date를 세어주는 역할
            console.log("yearCurrent : " + yearCurrent);
            //이번 달의 첫째 날
            //new를 쓰는 이유 : new를 쓰면 이번달의 로컬 월을 정확하게 받아온다. getMonth()는 0~11을 반환하기 때문에 new를 쓰지 않았을때 이번달을 받아오려면 +1 해줘야한다.
            var thisMonthDay1 = new Date(yearCurrent, today.getMonth(), 1);
            //이번 달의 마지막 날
            //new를 써주면 정확한 월을 가져옴, getMonth()+1을 해주면 다음달로 넘어가는데 day를 1부터 시작하는게 아니라 0부터 시작하기 때문에 제대로 된 다음달 시작일(1일)은 못가져오고 1 전인 0, 즉 전달 마지막일 을 가져오게 된다
            var lastDate = new Date(yearCurrent, today.getMonth() + 1, 0);

            var addSpace = '';
            //ThisMonth.getDay() = 이번 달 1일이 무슨 요일인지
            //getDay() : 요일을 알아내는 메소드. 반환값은 0부터 7까지이며 0은 일요일, 1은 월요일...
            //1일 전에 빈 칸 띄워주기
            for (i = 0; i < thisMonthDay1.getDay(); i++) {
              document.write('<li><p>' + ' ' + '</p></li>');
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
              document.write('<li><a class="updateTrigger" href="#" onclick="daySelected(title);" id="' + i + '"title="' + i + '" day-value="' + i + '"' + addSpace + '>' + i + '</a></li>');
            }

            document.querySelector('[day-value="${curDay}"]').classList.add("selected");

            if (addClickEventToUpdateTriggers != undefined)
              addClickEventToUpdateTriggers();
          </script>
        </ul>
        <div class="clearfix"></div>
      </div>
    </div>

    <div class="clearfix"></div>

  </div>


</body>
<script type="text/javascript">
  $(document).ready(function () {
    if ("${modifySuccess}" == 1) {
      // alert("Member modify success.");
    }
    if ("${joinSuccess}" == 1) {
      // alert("Member join success.");
    }
    if ("${removeError}" == 1) {
      // alert("Member remove failed.");
    }
    if ("${removeSuccess}" == 1) {
      // alert("Member remove success.");
    }
    if ("${logoutSuccess}" == 1) {
      // alert("Logout success.");
    }
  });
</script>

</html>
