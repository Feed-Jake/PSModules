<#
.SYNOPSIS
    This module is simply to try and gather all of the text content of a Web site. 
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Test-MyTestFunction -Verbose
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>



function Get-WebText {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Url
    ) 
    if (-not $PSCmdlet.MyInvocation.BoundParameters.ContainsKey('Url')) {
        $Url = Read-Host "Please enter the Web URL"
    }
    # Fetch the HTML content of the website
    $response = Invoke-WebRequest -Uri $Url

    # Extract the raw HTML content
    $htmlContent = $response.Content

    # Use regex to remove HTML tags
    $textOnlyContent = [regex]::Replace($htmlContent, '<[^>]+>', ' ')

    # Display the text-only content
    $textOnlyContent
}