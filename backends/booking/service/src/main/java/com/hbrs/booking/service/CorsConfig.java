package com.hbrs.booking.service;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
@EnableWebMvc
public class CorsConfig implements WebMvcConfigurer {

  // config for cross origin calls
   @Override
   public void addCorsMappings(CorsRegistry registry) {

    registry.addMapping("/**")
    .allowedOrigins("http://localhost,http://127.0.0.1")
    .allowedMethods("GET", "POST", "OPTIONS", "PUT").allowCredentials(true)
    .allowedHeaders("Content-Type", "X-Requested-With", "accept", "Origin", "Access-Control-Request-Method",
    "Access-Control-Request-Headers")
    .exposedHeaders("Access-Control-Allow-Origin", "Access-Control-Allow-Credentials");
   }
 }