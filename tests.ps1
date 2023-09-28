# Load the YAML module if not already loaded
if (-not (Get-Module -Name 'powershell-yaml' -ListAvailable)) {
    Install-Module -Name 'powershell-yaml' -Force -Scope CurrentUser
}

# Import the YAML module
Import-Module 'powershell-yaml'

# Read the YAML file
$apiRequest = Convert-FromYaml -Path '.\api_test.yaml'

# Define API request parameters
$apiUrl = $apiRequest.url
$apiMethod = $apiRequest.method
$apiHeaders = $apiRequest.headers
$queryParameters = $apiRequest.query_parameters

# Build the query string from query parameters
$queryString = [System.Web.HttpUtility]::ParseQueryString("")
foreach ($param in $queryParameters.Keys) {
    $queryString.Add($param, $queryParameters[$param])
}
$queryString = $queryString.ToString()

# Combine URL and query string
if ($queryString -ne '') {
    $apiUrl = "$apiUrl?$queryString"
}

# Make the API request
try {
    $response = Invoke-RestMethod -Uri $apiUrl -Method $apiMethod -Headers $apiHeaders

    # Print the response
    Write-Host "Response:"
    Write-Host $response
}
catch {
    Write-Host "API request failed: $_"
}
