#INL-Retro Cartidge Dump Script v0.5 by JJ831
#Place this and NESMapper.json in the the host folder. 
#May require running PS Command "Set-ExecutionPolicy -ExecutionPolicy Unrestricted" to allow running scripts

#set default variables
$inputJson = "NESMapper.json"

#Function for mapper lookup CSV from json
function Get-mapperCSV 
    { 
     $mapperList = Get-ChildItem $inputJson
     (Get-Content $mapperList | ConvertFrom-Json ) | 
     Export-Csv -NoTypeInformation .\NESMapper.csv -Force
     Generate-form
    }
#Generate the main window
function Generate-form {
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    
    #Build Main Window
    $clickForm = New-Object System.Windows.Forms.Form
    $clickForm.Text = "Rom Dump"
    $clickForm.Width = 600
    $clickForm.Height = 400
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

    #Setup Button click actions
    #Open json file button action
    $jsonButton.Add_Click({Select-Json})

    #Open LUA script location action
    $openButton.Add_Click({Select-luaScript})

    #Save As button action 
    $saveButton.Add_Click({Select-binFile})
    
    #Mapper Lookup button action
    $mapperButton.Add_Click({
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
   )
    #Go button
    $goButton.Add_Click({
        $mapperValue = $mapperInput.Text
        $prgValue = $PRGInput.Text 
        $chrValue =  $chrInput.Text 
        $consoleValue = $consoleInput.Text
        Save-binFile
    })
    #Show It
    $clickForm.ShowDialog()| Out-Null   
    
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

function Select-Json ($currentDiretory){ 
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") |  Out-Null
    $jsonFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $jsonFileDialog.InitialDirectory = $CurrentDirectory
    $jsonFileDialog.filter = "json Files (*.json)| *.*"
    $jsonFileDialog.ShowDialog() | Out-Null
    $Script:inputJson = $jsonFileDialog.FileName.ToString()
    Get-MapperCSV
    }
#Setup Save Location Dialog for Dump
function Select-binFile($initialDirectory){
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") |  Out-Null
    $saveFileDialog = New-Object System.Windows.Forms.saveFileDialog
    $saveFileDialog.initialDirectory = $initialDirectory
    $saveFileDialog.filter = "All files (*.*)| *.*"
    $saveFileDialog.ShowDialog() | Out-Null
    $script:romOut = $saveFileDialog.filename.ToString()
}
#Create Function to actually run everything
function Start-Dump {
    Get-MapperCSV
    }

#Run the dump and redirect output
function Save-binFile{
          cmd /c "inlretro.exe -s $InputScript -m $mapperValue -c $consoleValue -x $prgValue -y $chrValue -d $romOut" 2'>'1 
     }
Start-Dump