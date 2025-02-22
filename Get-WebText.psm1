<#
.SYNOPSIS
    Getting the text content of a Web site. 
.DESCRIPTION
    This module is simply to try and gather all of the text content of a Web site. 
.LINK
    No links for this module
.EXAMPLE
    Get-WebText -Url "https://www.example.com"
The above command (with a url) will get you the text (HTML included) of a website.
#>

function Get-WebText {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$Url
    ) 
    process {
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
}