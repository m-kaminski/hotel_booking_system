package com.hbrs.booking.service;

public record Person(long id, 
    String legal_first_name,
    String legal_middle_name,
    String legal_last_name,
    String preferred_name,
    String email, 
    long phone_num, 
    short phone_country_code)
    { }

