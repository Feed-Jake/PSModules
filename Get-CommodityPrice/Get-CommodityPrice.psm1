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

        # Extract the first numeric value that looks like a price (e.g., 69.76)
        if ($html -match '(\d{1,5},?\d*\.\d{1,2})') {
            $price = $matches[1] -replace ",", ""  # Remove commas if they exist
            return "$Commodity Price: $price USD"
        }
        else {
            Write-Error "Unable to extract price for $Commodity. The webpage structure might have changed."
        }
    }
    catch {
        Write-Error "Error fetching data: $_"
    }
}

# Example Usage:
Get-CommodityPrice -Commodity Coffee
Get-CommodityPrice -Commodity Wheat
Get-CommodityPrice -Commodity Oil
