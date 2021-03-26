# dumpScriptAssist


WORK IN PROGRESS - Now runs an md5 and  sha1 on the full rom file


Script to Assist in dumping roms.  This requires a json file with headers "Title", "PRGSize", "CHRSize" and "Mapper" fields (included, but it's accuracy is unknown).  Script will look in the local running directory for NESMapper.json by default or can be custom loaded via the GUI.  dumpFunctions_script.ps1 and dumpFunctions_Module1.psm1 are the same, only the former is set to be ran a script, the latter is an importable module.  Run the Script or Start-Dump from the Host folder. If ilnretro.exe is not found, it will prompt to find and try to move your location 


You may require running PS Command "Set-ExecutionPolicy -ExecutionPolicy Unrestricted" to allow running scripts

Module:
dumpFunctions_Module1.psm1
Usage -
Import-Module -Path \<path to dumpFunctions_Module1.psm1\> 
Start-Dump

Script:
dumpFunctions_script.ps1 
Usage -
./dumpFunctions_script.ps1 
