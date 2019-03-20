Google Trend Election Predictor (GTEP)
---
Files:
- gtep_EER_diagram.mwb: MySQL Workbench ERD
- re_create_database_gtep.sql: script to (re)create database schema (gtep) on MariaDB.
- gtep_test.sql: script to (re)create database schema (gtep) on MariaDB WITHOUT any constraints. This is for test purpose.
- state_data.csv: raw data collected from https://www.electoral-vote.com/evp2016/Info/delegates.html
- populate_state_data.sql : execute this sql file to generate data for state table.