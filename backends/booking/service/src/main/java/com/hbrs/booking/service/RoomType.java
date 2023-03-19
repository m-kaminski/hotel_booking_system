package com.hbrs.booking.service;


public record RoomType(
    long id, 
    long sqft, 
    String name, 
    String description, 
    boolean smoking, 
    int beds, 
    boolean disability, 
    int count, 
    int max, 
    float price) 
    { }d