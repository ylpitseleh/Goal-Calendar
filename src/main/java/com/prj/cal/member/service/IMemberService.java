package com.prj.cal.member.service;

import com.prj.cal.member.Member;

public interface IMemberService {
	int memberRegister(Member member);
	Member memberSearch(Member member);
	Member memberModify(Member member);
	int memberRemove(Member member);
}