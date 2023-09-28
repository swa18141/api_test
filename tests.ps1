# Install the YAML module (if not already installed)
if (-not (Get-Module -Name "PSReadLine" -ListAvailable)) {
    Install-Module -Name "PSReadLine" -Force -AllowClobber
}

# Load the YAML module
Import-Module -Name "PSReadLine"

# Read the YAML configuration file
$apiConfig = Get-Content -Path "api_test.yml" | ConvertFrom-Yaml

# Extract values from the configuration
$apiUrl = $apiConfig.api_url
$httpMethod = $apiConfig.http_method
$headers = $apiConfig.headers
$queryParameters = $apiConfig.query_parameters
$scriptUrl = $apiConfig.script_url

# Fetch and execute the script from the provided URL
try {
    $scriptContent = Invoke-RestMethod -Uri $scriptUrl -Method GET

    # Execute the fetched script
    Invoke-Expression -Command $scriptContent

    # Make the API request using Invoke-RestMethod
    $response = Invoke-RestMethod -Uri $apiUrl -Method $httpMethod -Headers $headers -OutFile 'test.json'

    # Handle the API response here
    Write-Host "API Response:"
    Write-Host $response
} catch {
    # Handle any errors that occur during the script execution or API request
    Write-Host "An error occurred: $_"
}
