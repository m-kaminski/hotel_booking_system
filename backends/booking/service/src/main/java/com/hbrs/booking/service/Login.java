package com.hbrs.booking.service;

import java.time.Instant;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAccessor;
import java.util.Date;
import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.hbrs.booking.service.persistence.Persons;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;



@RestController	
public class Login {

	private Persons persons;
	Login() {
		persons = new Persons();
	}


	@GetMapping("/getlogin")
	public Long process(HttpSession session) {
        Long loginId = (Long)session.getAttribute("USER_LOGIN_ID");

		if (loginId == null) {
			loginId = -1L;
		}

        return loginId;
	}

	@GetMapping("/login")
	public Long persistMessage(@RequestParam("email") String loginEmail, @RequestParam("password") String loginPassword, HttpServletRequest request) {


        Long loginId = persons.validatePassword(loginEmail, loginPassword);
       
		request.getSession().setAttribute("USER_LOGIN_ID", loginId);
		return loginId;
	}

	@GetMapping("/logout")
	public String destroySession(HttpServletRequest request) {
		request.getSession().invalidate();
		return "redirect:/getlogin";
	}


}

