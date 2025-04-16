package com.kh.member.service;

import static com.kh.common.JDBCTemplate.*;

import java.sql.Connection;

import com.kh.member.model.dao.MemberDao;
import com.kh.member.model.vo.Member;

public class MemberService {

	public Member loginMember(String userId,String userPwd) {
		Connection conn = getConnection();
		Member m = new MemberDao().loginMember(conn, userId, userPwd);
		
		close(conn);
		return m;
	}
	
	public int insertMember(Member m) {
		Connection conn = getConnection();
		int result = new MemberDao().insertMember(conn, m);
		
		if(result > 0) {
			commit(conn);
		} else {
			rollback(conn);
		}
		
		close(conn);
		
		return result;
	}
	
	public Member updateMember(Member m) {
		Connection conn = getConnection();
		int result = new MemberDao().updateMember(conn, m);
		
		Member updateMember = null;
		if(result > 0) {
			commit(conn);
			updateMember = new MemberDao().selectMemberByUserId(conn, m.getUserId());
		} else {
			rollback(conn);
		}
		
		close(conn);
		
		return updateMember;
	}
	
	public Member updateMemberPwd(String userId, String updatePwd) {
		Connection conn = getConnection();
		int result = new MemberDao().updateMemberPwd(conn, userId, updatePwd);
		
		Member updateMember = null;
		if(result > 0) {
			commit(conn);
			updateMember = new MemberDao().selectMemberByUserId(conn, userId);
		} else {
			rollback(conn);
		}
		
		close(conn);
		
		return updateMember;
	}
	
	public int deleteMeber(String userId) {
		Connection conn = getConnection();
		int result = new MemberDao().deleteMeber(conn, userId);
		
		if(result > 0) {
			commit(conn);
		} else {
			rollback(conn);
		}
		
		close(conn);
		
		return result;
	}
	
	public int idCheck(String checkId) {
		Connection conn = getConnection();
		
		int count = new MemberDao().idCheck(conn, checkId);
		
		close(conn);
		
		return count;
	}
}
