#INL-Retro Cartidge Dump Script v0.9 by JJ831
#Best to place this and NESMapper.json in the the host folder.  
#May require running PS Command "Set-ExecutionPolicy -ExecutionPolicy Unrestricted" to allow running scripts

#Set initial values and load assemblies for GUI (froms!)
function Initialize-script {
#Variables
    $inputJson = "NESMapper.json"
    $inputExe = ".\inlretro.exe"
#Assemblies  
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    Add-Type -AssemblyName PresentationFramework
    Test-exePath
}
#Check for the inlretro Executable.
function Test-exePath {
    if(!(Test-Path -Path ".\inlretro.exe")) {
            Get-inlretroExe
             }
        Else{
        Test-json
        }
}
#Dialog to find executable
function Get-inlretroExe($currentDiretory){ 
    $msgBoxExe = [System.Windows.Forms.MessageBox]::Show("No inlretro.exe found.  Please select the location")
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") |  Out-Null
    $openExeDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openExeDialog.InitialDirectory = $CurrentDirectory
    $openExeDialog.filter = "Executables (*.exe)| *.exe| All files (*.*)|*.*"
    $openExeDialog.ShowDialog() | Out-Null
    $chosenExe = $openExeDialog.FileName.ToString()
    $inputExe = "$chosenExe"
    $setLocationPath = Split-Path -Path $chosenExe -Parent
    Set-Location -Path "$setLocationPath"
    Test-json
}
#Check if NESMapper.json is in the local direcrtory and if found, call the function to process is
function Test-json {
    if(!(Test-Path ".\NESMapper.json")){
        Generate-Form
            }
    Else{
        Get-MapperCSV
        }
}
#Generate CSV from json
function Get-mapperCSV{ 
     $mapperList = Get-ChildItem $inputJson
     (Get-Content $mapperList | ConvertFrom-Json ) | 
     Export-Csv -NoTypeInformation .\NESMapper.csv -Force
     Generate-form
    }
#Generate the main window
function Generate-form {

    #Build Main Window
    $clickForm = New-Object System.Windows.Forms.Form
    $clickForm.Text = "Rom Dump"
    $clickForm.Width = 600
    $clickForm.Height = 450
    $clickForm.AutoScale = $true
    
    #Add Game Title Filed
    $titleLabel = New-Object System.Windows.Forms.Label
    $titleLabel.Text = "Game Title"
    $titleLabel.Location = New-Object System.Drawing.Size (10,10)
    $titleLabel.Height = 20
    $titleLabel.Width = 75
    $titleInput = New-Object System.Windows.Forms.combobox
    $titleInput.Location = New-Object System.Drawing.Size (110,10)
    $titleInput.AutoSize = $true
    $titleInput.Text = $gameTitle

    #Add PRG Size Field
    $PRGLabel = New-Object System.Windows.Forms.Label
    $PRGLabel.Text = "PRG Size"
    $PRGLabel.Location = New-Object System.Drawing.Size (10,60)
    $PRGLabel.AutoSize = $true
    $PRGInput = New-Object System.Windows.Forms.combobox
    $PRGInput.Location = New-Object System.Drawing.Size (110,60)
    $PRGInput.AutoSize = $true
    $PRGInput.Text = $prgValue

    #Add CHR Field
    $chrLabel = New-Object System.Windows.Forms.Label
    $chrLabel.Text = "CHR Size"
    $chrLabel.Location = New-Object System.Drawing.Size (10,110)
    $chrLabel.AutoSize = $true
    $chrInput = New-Object System.Windows.Forms.combobox
    $chrInput.Location = New-Object System.Drawing.Size (110,110)
    $chrInput.AutoSize = $true
    $chrInput.Text = $chrValue

    #Add Console Field
    $consoleLabel = New-Object System.Windows.Forms.Label
    $consoleLabel.Text = "Console"
    $consoleLabel.Location = New-Object System.Drawing.Size (10,160)
    $consoleLabel.AutoSize = $true
    $consoleInput = New-Object System.Windows.Forms.combobox
    $consoleInput.Location = New-Object System.Drawing.Size (110,160)
    $consoleInput.AutoSize = $true
    $ConsoleInput.Text = $chrValue

    #Add Game Mapper
    $mapperLabel = New-Object System.Windows.Forms.Label
    $mapperLabel.Text = "Mapper"
    $mapperLabel.Location = New-Object System.Drawing.Size (10,210)
    $mapperLabel.AutoSize = $true
    $mapperInput = New-Object System.Windows.Forms.Combobox
    $mapperInput.Location = New-Object System.Drawing.Size (110,210)
    $mapperInput.AutoSize = $true
    $mapperInput.Text = $chrValue

      
    #Add JSON Buttom
    $jsonButton = New-Object System.Windows.Forms.Button
    $jsonButton.Location = New-Object System.Drawing.Size (400,10)
    $jsonButton.Size = New-Object System.Drawing.Size (120,23)
    $jsonButton.Text = "Load json"

    #Add Open Script Button
    $openButton = New-Object System.Windows.Forms.Button
    $openButton.Location = New-Object System.Drawing.Size (400,60)
    $openButton.Size = New-Object System.Drawing.Size (120,23)
    $openButton.Text = "Open Script..."
    
    #Add Save As Button
    $saveButton = New-Object System.Windows.Forms.Button
    $saveButton.Location = New-Object System.Drawing.Size (400,110)
    $saveButton.Size = New-Object System.Drawing.Size (120,23)
    $saveButton.Text = "Save As..."
    
    #Add MapperLookup
    $mapperButton = New-Object System.Windows.Forms.Button
    $mapperButton.Location = New-Object System.Drawing.Size (400,160)
    $mapperButton.Size = New-Object System.Drawing.Size (120,23)
    $mapperButton.Text = "Game Lookup"
    
    #Add Go Button
    $goButton = New-Object System.Windows.Forms.Button
    $goButton.Location = New-Object System.Drawing.Size (400,210)
    $goButton.Size = New-Object System.Drawing.Size (120,23)
    $goButton.Text = "Go!"

    #Add Hash Button
    $hashButton = New-Object System.Windows.Forms.Button
    $hashButton.Location = New-Object System.Drawing.Size (400,260)
    $hashButton.Size = New-Object System.Drawing.Size (120,23)
    $hashButton.Text = "Get Hash"
   
    #Draw the elements on the main form
    $ClickForm.Controls.Add($goButton)
    $ClickForm.Controls.Add($openButton)
    $ClickForm.Controls.Add($saveButton)
    $ClickForm.Controls.Add($titleLabel)
    $ClickForm.Controls.Add($titleInput)
    $ClickForm.Controls.Add($PRGLabel)
    $ClickForm.Controls.Add($PRGInput)
    $ClickForm.Controls.Add($chrLabel)
    $ClickForm.Controls.Add($chrInput)
    $ClickForm.Controls.Add($consoleLabel)
    $ClickForm.Controls.Add($consoleInput)
    $ClickForm.Controls.Add($mapperLabel)
    $ClickForm.Controls.Add($mapperInput)
    $ClickForm.Controls.Add($mapperButton)
    $ClickForm.Controls.Add($jsonButton)
    $ClickForm.Controls.Add($hashButton)

#Setup Button click actions

    #Open json file button action
    $jsonButton.Add_Click({Select-Json})

    #Open LUA script location action
    $openButton.Add_Click({Select-luaScript})

    #Save As button action 
    $saveButton.Add_Click({Select-binFile})
    
    #Mapper Lookup button action
    $mapperButton.Add_Click({Select-Mapper})

    #Go button
    $goButton.Add_Click({
        $mapperValue = $mapperInput.Text
        $prgValue = $PRGInput.Text 
        $chrValue =  $chrInput.Text 
        $consoleValue = $consoleInput.Text
        Save-binFile
    })
    #Get-Hash button
    $HashButton.Add_Click({
        $romHash = Get-FileHash -Algorithm md5 -Path $romOut 
        $msgBoxRomHash = [System.Windows.Forms.MessageBox]::Show("$romHash")
    })

    #Show It
    $clickForm.ShowDialog()| Out-Null   
    
  }
#Get the location of a json file
function Select-Json ($currentDiretory){ 
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") |  Out-Null
    $jsonFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $jsonFileDialog.InitialDirectory = $CurrentDirectory
    $jsonFileDialog.filter = "json Files (*.json)| *.json| All Files (*.*)|*.*"
    $jsonFileDialog.ShowDialog() | Out-Null
    $jsonPath = $jsonFileDialog.FileName.ToString()
    Set-Variable -name inputJson -Value $jsonPath
    Get-MapperCSV2
    }
#Convert json to CSV if loaded by button (doesn't spwan another form).
function Get-MapperCSV2{ 
     $mapperList2 = Get-ChildItem $inputJson
     (Get-Content $mapperList2 | ConvertFrom-Json ) | 
     Export-Csv -NoTypeInformation .\NESMapper.csv -Force
}
#Select mapper values from datatable
function Select-Mapper{
#Use Out-Gridview to view dataset and select game
    $script:mapperData = Import-Csv .\NESMapper.csv | Out-GridView -outputMode Multiple | Select-Object Title, PRGSize, CHRSize, Mapper
#Set varibales and fill in the form
    $gameTitle  =  $mapperData.Title
    $prgValue = $mapperData.PRGSize
    $chrvalue   =  $mapperData.CHRSize
    $mapperValue  =  $mapperData.Mapper   
    $consoleValue = "NES"
    $titleInput.Text  =  $mapperData.Title 
    $PRGInput.Text  =   $mapperData.PRGSize   
    $chrInput.Text   =  $mapperData.CHRSize 
    $consoleInput.Text  =  $consoleValue 
    $mapperInput.Text  =  $mapperData.Mapper 
}
#Setup File Open Operation for Script
function Select-luaScript ($currentDiretory){ 
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") |  Out-Null
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.InitialDirectory = $CurrentDirectory
    $openFileDialog.filter = "All Files (*.*)| *.*"
    $openFileDialog.ShowDialog() | Out-Null
    $Script:inputScript = $openFileDialog.FileName.ToString()
}
#Setup Save Location Dialog for Dump
function Select-binFile($initialDirectory){
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") |  Out-Null
    $saveFileDialog = New-Object System.Windows.Forms.saveFileDialog
    $saveFileDialog.initialDirectory = $initialDirectory
    $saveFileDialog.filter = "All files (*.*)| *.*"
    $saveFileDialog.ShowDialog() | Out-Null
    $script:romOut = $saveFileDialog.filename.ToString()
    #Replace spaces with Underscores in filename
    $script:romOut = $script:romOut -replace '\s','_'
}
#Create Function to actually run everything
function Start-Dump {
    Initialize-script
    }
#Run the dump and redirect output
function Save-binFile{
          cmd /c "$inputExe -s $InputScript -m $mapperValue -c $consoleValue -x $prgValue -y $chrValue -d $romOut" | Out-Host 
              Get-RomHash
               }

function Get-RomHash {
      Get-FileHash -Algorithm md5 -Path $romOut | Out-Host
      Get-FileHash -Algorithm sha1 -Path $romOut | Out-Host

 }