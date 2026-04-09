-- Author: oneaarmdeveloper
-- File: schema/01_create_database.sql
-- Purpose: creating databsase for this project 
-- Date: 09.04.2026   


DROP DATABASE IF EXISTS retail_analytics;

CREATE DATABASE retail_analytics
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE retail_analytics;
SELECT DATABASE() AS current_database;