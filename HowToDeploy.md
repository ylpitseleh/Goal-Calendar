# AWS 배포에 필요한 단계

- war 파일 생성 후 프로젝트 최상단에 있는 war파일 덮어씌우기
- (filezila 사용 안 하므로) git push
- putty로 aws 인스턴스 접속
- sudo su
- cd Goal-Calendar
- git pull
- cp Share-Calendar.war /var/lib/tomcat8/webapps
- service tomcat8 restart
- (mysql config 수정시) service mysql restart
