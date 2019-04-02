Google Trend Election Predictor (GTEP)
---
Files:
- gtep_EER_diagram.mwb: MySQL Workbench ERD
- db_gtep_test.sql: create and populate data for 'gtep_test'. Data point is the date script created.
- re_create_database_gtep.sql: script to (re)create database schema (gtep) on MariaDB.
- gtep_test.sql: script to (re)create database schema (gtep) on MariaDB WITHOUT any constraints. This is for test purpose.
- state_data.csv: raw data collected from https://www.electoral-vote.com/evp2016/Info/delegates.html
- populate_state_data.sql : execute this sql file to generate data for state table.
- state.sql, candidate.sql : execute this sql file to create `state`, `candidate` table, and also populate data for it. Can be selectively used to just populating data.