<#
.SYNOPSIS
    Having fun with PowerShell by fetching specific commodity prices from a website.    
.DESCRIPTION
    This Module is intended to have a little fun with keeping close to the Agricultural scene with PowerShell. 
    Trying to see what's going on in the market with a few commodities.
.PARAMETER Commodity
    The name of the commodity to fetch the price for. Valid values are: Coffee, LiveCattle, Wheat, Corn, Oil.
.NOTES
    We are fetching the data from the https://tradingeconomics.com/commodity/ website.
    The website structure might change, so this script may need to be updated accordingly.
.LINK
    At thi smoment, there is no online help link for this module.
.EXAMPLE
    Get-CommodityPrice -Commodity Coffee
    Get-CommodityPrice -Commodity Wheat
    Get-CommodityPrice -Commodity Oil
    These examples will fetch the current price of Coffee, Wheat, and Oil, respectively.
#>
function Get-CommodityPrice {
    param (
        [string]$Commodity
    )

    # Define the commodity URLs
    $commodityUrls = @{
        "Coffee"      = "https://tradingeconomics.com/commodity/coffee"
        "LiveCattle"  = "https://tradingeconomics.com/commodity/cattle"
        "Wheat"       = "https://tradingeconomics.com/commodity/wheat"
        "Corn"        = "https://tradingeconomics.com/commodity/corn"
        "Oil"         = "https://tradingeconomics.com/commodity/crude-oil"
    }

    # Validate user input
    if (-not $commodityUrls.ContainsKey($Commodity)) {
        Write-Error "Invalid commodity name. Use: Coffee, LiveCattle, Wheat, Corn, Oil."
        return
    }

    $url = $commodityUrls[$Commodity]

    try {
        # Fetch the webpage
        $response = Invoke-WebRequest -Uri $url -UseBasicParsing
        $html = $response.Content

        # Extract the first numeric value that looks like a price
        if ($html -match '(\d{1,5},?\d*\.\d{1,2})') {
            $currentPrice = $matches[1] -replace ",", ""  # Remove commas
        }
        else {
            Write-Error "Unable to extract price for $Commodity."
            return
        }

        # Extract price change (+/- value)
        if ($html -match '([-+]?\d*\.\d{1,2})\s*\(([-+]?\d*\.\d{1,2})%\)') {
            $priceChange = $matches[1]
            $percentChange = $matches[2]
        }
        else {
            Write-Error "Unable to extract price change for $Commodity."
            return
        }

        return "$Commodity Price: $currentPrice USD | Change: $priceChange ($percentChange%)"
    }
    catch {
        Write-Error "Error fetching data: $_"
    }
}

# Example Usage:
Get-CommodityPrice -Commodity Oil
Get-CommodityPrice -Commodity Wheat
