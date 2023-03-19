package com.hbrs.booking.service;
import java.sql.Time;

public record HotelSettingsType (
    long id,
    Time checkin_time,
    Time checkout_time,
    float base_rate,
    float sales_tax,
    float resort_fee,
    int star_rating,
    String timezone_name
){}
