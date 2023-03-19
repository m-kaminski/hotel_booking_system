package com.hbrs.booking.service;

import java.util.Optional;

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
	public Optional<Person>  getlogin(HttpSession session) {           
        
        System.out.println("finding user info");

        try {
            long loginId = (long)session.getAttribute("USER_LOGIN_ID");
            return Optional.of(persons.getPersonById(loginId));
        } catch (NullPointerException e) { // no attribute
            return Optional.empty();
        }
	}

	@GetMapping("/login")
	public Optional<Person> login(@RequestParam("email") String loginEmail, 
                            @RequestParam("password") String loginPassword, 
                            HttpServletRequest request) {
        Person person = persons.validatePassword(loginEmail, loginPassword);
        System.out.println("LOGIN");
        if (person != null) {
		    request.getSession().setAttribute("USER_LOGIN_ID", person.id());
            System.out.println("Saving user ID of " + String.valueOf(person.id()));
            return Optional.of(person);
        } else {
            return Optional.empty();
        }
	}

	@GetMapping("/logout")
	public String logout(HttpServletRequest request) {
		request.getSession().invalidate();
		return "logged out";
	}
}

