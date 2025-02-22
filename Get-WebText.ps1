function Get-WebText {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Url
    )

    # Fetch the HTML content of the website
    $response = Invoke-WebRequest -Uri $Url

    # Extract the raw HTML content
    $htmlContent = $response.Content

    # Use regex to remove HTML tags
    $textOnlyContent = [regex]::Replace($htmlContent, '<[^>]+>', ' ')

    # Display the text-only content
    $textOnlyContent
}

# Example usage
Get-WebText -Url "https://www.example.com"