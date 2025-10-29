# setup-tfvars.ps1
# PowerShell script to create terraform.tfvars file with current user's Object ID
# Usage: .\setup-tfvars.ps1

param(
    [string]$TfvarsPath = "terraform.tfvars",
    [string]$ExamplePath = "terraform.tfvars.example"
)

Write-Host "Setting up Terraform variables file..." -ForegroundColor Green

# Check if example file exists
if (-Not (Test-Path $ExamplePath)) {
    Write-Error "Example file '$ExamplePath' not found."
    exit 1
}

# Get current user's Object ID
Write-Host "Getting your Azure AD Object ID..." -ForegroundColor Yellow
try {
    $objectId = az ad signed-in-user show --query id -o tsv
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to get user Object ID"
    }
    Write-Host "Found Object ID: $objectId" -ForegroundColor Green
}
catch {
    Write-Error "Failed to get your Object ID. Make sure you're logged in with 'az login'"
    Write-Host "You can also manually get your Object ID with: az ad signed-in-user show --query id -o tsv" -ForegroundColor Cyan
    exit 1
}

# Check if tfvars file already exists
if (Test-Path $TfvarsPath) {
    $overwrite = Read-Host "File '$TfvarsPath' already exists. Overwrite? (y/N)"
    if ($overwrite.ToLower() -ne 'y') {
        Write-Host "Aborted. You can manually edit $TfvarsPath" -ForegroundColor Yellow
        exit 0
    }
}

# Copy example file and replace placeholder
try {
    $content = Get-Content $ExamplePath -Raw
    $content = $content -replace "REPLACE_WITH_YOUR_OBJECT_ID", $objectId
    
    # Write to tfvars file
    Set-Content -Path $TfvarsPath -Value $content
    
    Write-Host "`nSuccessfully created '$TfvarsPath'" -ForegroundColor Green
    Write-Host "Object ID has been automatically filled in." -ForegroundColor Green
    Write-Host "`nYou can now:" -ForegroundColor Cyan
    Write-Host "1. Review and customize $TfvarsPath if needed" -ForegroundColor White
    Write-Host "2. Load environment variables: .\set-env.ps1" -ForegroundColor White
    Write-Host "3. Run Terraform: terraform init && terraform plan" -ForegroundColor White
}
catch {
    Write-Error "Failed to create tfvars file: $_"
    exit 1
}