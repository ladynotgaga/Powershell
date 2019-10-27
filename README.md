MergeHashTables:

1. Write a script to merge two hash tables. 
Output should be sort by name column. 
Use next hash tables as example: 
	@{a = 1; c = 3; r = 6; d = 7} 
	@{c = 3; b = 4; d = 7; s = 9} 

RandomPasword:

1. Write a script which generate random password. 
2. Password length should be set from command line. Default length is 12-character. 
3. Password character set should be defined from command line. Default character set is “1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ”. 

Get-Translation:

1. Write a script that use Yandex.Translate API to translate text from module1-task3.txt file in English. 
2. Strings that contain latin characters should not be translated. 
3. Make sure you use splatting in your script. 
4. Format results as JSON and/or XML objects and put them into separate files. Output files should be defined from command line. JSON file content structure see below.

Get-OWMWeather:

1. Write a script for retrieving wheather data from openweathermap.org. 
2. Script is required getting data by city name or city id. 
3. Script is required having possibility to set temperature format (Kelvin, Imperial, Metric). 
4. Script must return hash table with next keys: City, Id, Country, Weather Now, Temperature Now, Weather Tomorrow, Temperature Tomorrow 



Get-OWMWeather Folder:

1. Based on function from Task 2 create PowerShell module that contains function Get-Wheather. 
2. Module must contain manifest file. 
3. Manifest file must contain next properties: 
	Module version is “0.17” Module author is “FarFarGalaxy” 
	Module company name is “FarFarGalaxy & Co” 
	Module copyright is “(c) 2019 FarFarGalaxy & Co” 
4. Module function should be discovered in exported commands 

Remote-ServersDataCollect:

1. Develop a script which will collect from remote servers following data: 
	- Free space on C:\ drive 
	- Name and ID of top 5 processes which consumes the most of CPU resources 
	- Current CPU load in % 
2. Use function with parameters where it is needed (it’s up to your decide) 
3. List of computers must be stored in a separate file.  
4. Implement “throttling” to define the maximum of servers queried  
5. Results must be saved into a single JSON file for all computers 

GetJob

1. Create a script that will display all the file names in any destination folder.  
2. Processing must proceed in parallel (use PS jobs for that). One job for single file to be created. 
3. Script should create job, execute it and delete job after. In case of failed job show warning in output. 
4. Number of currently executed jobs should be less than N (for example max 3 jobs running at the same time). 
You have to trigger new job only if you have free thread 
(Example: 3 jobs running and one of your jobs has been completed, 
but 2 of them still running – you trigger one more job to create). 
Tip: Use random delay 5-15 seconds inside job execution to see that logic is working as expected. 

SortErrorLogs:

1. Write a script for getting all error state from task1-dism.log file. 
2. Put all error state in separate task1-error.log file. 
3. task1-error.log file should contain extra-column with error code (ex. 0x800F0954) 

Try-Catch:

1. Implement error handling for script from module 3 task 1 (Translate text using Yandex api). 

HTMLAgilityPack:

1. Write a script for parsing GitHub trending (https://github.com/trending) using HTML Agility Pack assembly. 
2. Script should extract Name, Address, Language, Stars total, Stars today. 
3. All extracted data should be out to JSON task4.json file. JSON file content structure see below.  
4. Script should use HTML Agility Pack nuget package and out of the box shouldn’t contain any assemblies and/or executable files.


