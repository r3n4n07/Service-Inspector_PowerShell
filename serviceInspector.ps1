Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$FormObject = [System.Windows.Forms.Form]
$LabelObject = [System.Windows.Forms.Label]
$ComboBoxObject = [System.Windows.Forms.ComboBox]
$PanelObject = [System.Windows.Forms.Panel]

$DefaultFont = New-Object System.Drawing.Font("Segoe UI", 11)

# Janela principal
$AppForm = New-Object $FormObject
$AppForm.ClientSize = '600,350'
$AppForm.Text = '🔧 Service Inspector'
$AppForm.BackColor = '#6cb4f4'
$AppForm.Font = $DefaultFont
$AppForm.StartPosition = 'CenterScreen'

# Título
$labelTitle = New-Object $LabelObject
$labelTitle.Text = 'Verificador de Serviços do Sistema'
$labelTitle.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$labelTitle.AutoSize = $true
$labelTitle.Location = New-Object System.Drawing.Point(20, 15)
$labelTitle.ForeColor = '#ffffff'

# Painel de seleção de serviço
$panel = New-Object $PanelObject
$panel.Size = New-Object System.Drawing.Size(550, 230)
$panel.Location = New-Object System.Drawing.Point(25, 60)
$panel.BackColor = 'White'

# Label do ComboBox
$labelService = New-Object $LabelObject
$labelService.Text = 'Serviços disponíveis:'
$labelService.AutoSize = $true
$labelService.Location = New-Object System.Drawing.Point(20, 20)
$labelService.ForeColor = '#444444'

# ComboBox
$ddlService = New-Object $ComboBoxObject
$ddlService.Width = 300
$ddlService.DropDownStyle = 'DropDownList'
$ddlService.Location = New-Object System.Drawing.Point(180, 16)
$ddlService.BackColor = 'WhiteSmoke'
$ddlService.ForeColor = '#000000'

Get-Service | Sort-Object Name | ForEach-Object {
    $ddlService.Items.Add($_.Name)
}

# Label para nome amigável
$labelForName = New-Object $LabelObject
$labelForName.Text = 'Nome do Serviço:'
$labelForName.AutoSize = $true
$labelForName.Location = New-Object System.Drawing.Point(20, 70)
$labelForName.ForeColor = '#444444'

$labelName = New-Object $LabelObject
$labelName.Text = ''
$labelName.AutoSize = $false
$labelName.MaximumSize = New-Object System.Drawing.Size(300, 0)  
$labelName.Size = New-Object System.Drawing.Size(300, 50)
$labelName.Location = New-Object System.Drawing.Point(180, 70)
$labelName.ForeColor = '#007acc'
$labelName.Font = 'Segoe UI, 10'

# Label para status
$labelForStatus = New-Object $LabelObject
$labelForStatus.Text = 'Status atual:'
$labelForStatus.AutoSize = $true
$labelForStatus.Location = New-Object System.Drawing.Point(20, 120)
$labelForStatus.ForeColor = '#444444'

$labelStatus = New-Object $LabelObject
$labelStatus.Text = ''
$labelStatus.AutoSize = $true
$labelStatus.Location = New-Object System.Drawing.Point(180, 120)
$labelStatus.ForeColor = '#444444'

# Adiciona elementos ao painel
$panel.Controls.AddRange(@(
    $labelService, $ddlService,
    $labelForName, $labelName,
    $labelForStatus, $labelStatus
))

# Adiciona elementos ao formulário principal
$AppForm.Controls.AddRange(@($labelTitle, $panel))

# Selecionar serviço
function GetServiceDetails {
    $ServiceName = $ddlService.SelectedItem
    if ($ServiceName) {
        $details = Get-Service -Name $ServiceName
        $labelName.Text = $details.DisplayName
        $labelStatus.Text = $details.Status

        if ($details.Status -eq 'Running') {
            $labelStatus.ForeColor = 'Green'
        } elseif ($details.Status -eq 'Stopped') {
            $labelStatus.ForeColor = 'Red'
        } else {
            $labelStatus.ForeColor = 'DarkOrange'
        }
    }
}

# Evento
$ddlService.Add_SelectedIndexChanged({ GetServiceDetails })

# Mostrar janela
$AppForm.ShowDialog()
$AppForm.Dispose()
