CREATE DATABASE [ArmyDB]
 ON  PRIMARY 
( NAME = N'ArmyDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\ArmyDB.mdf' , SIZE = 30720KB , MAXSIZE = 102400KB , FILEGROWTH = 10240KB )
 LOG ON 
( NAME = N'ArmyDB_log', FILENAME = N'D:\Temp\ArmyDB_log.ldf' , SIZE = 8192KB , FILEGROWTH = 65536KB)
COLLATE Ukrainian_100_CI_AS