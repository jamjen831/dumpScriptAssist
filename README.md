# dumpScriptAssist
WORK IN PROGRESS
Script to Assist in dumping roms.  This requires a json file with headers "Title", "PRGSize", "CHRSize" and "Mapper" fields.  Script will look in the local running directory for NESMapper.json by default or can be custom loaded via the GUI.  dumpFunctions_script.ps1 and dumpFunctions_Module1.psm1 aree the same, only the former is set to be ran a script, the latter is an importable module.  Run the Script or Start-Dump from the Host folder.  

dumpFunctions_Module1.psm1 -  Module 
Use "Import-Module -Path <path to dumpFunctions_Module1.psm1>".  Then Start-Dump from the Host folder

dumpFunctions_script.ps1 - Script 

Run like any normal powershell script - ./dumpFunctions_script.ps1 .  

