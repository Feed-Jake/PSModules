<#
.SYNOPSIS
    A quick probe into the Stock quotes using Alpha Vantage Free API.
.DESCRIPTION
    Using this PowerShell Module is a quick way to keep track of many stock quotes using the Alpha Vantage API.
    The function Get-Stocks retrieves the latest stock data for a given symbol (e.g., WTI, VMW) from Alpha Vantage.
    It will display the most recent data, including the opening, high, low, and closing prices. With a color code,
    it will highlight whether the closing price is higher (in green), lower (in red), or equal (in yellow) to the opening price.
.NOTES
    Alpha Vantage is pleased to provide free stock API service covering the majority of our datasets for up to 25 requests per day
.LINK
    https://www.alphavantage.co/support/#support
.EXAMPLE
    Get-Stocks -Id VMW -Verbose
    This command will reach out and get the most recent data for the stock symbol VMW (VMWare) from Alpha Vantage.
.EXAMPLE 
    Get-Stocks -Id WTI -Verbose
    This command will reach out and get the most recent data for the stock symbol WTI (West Texas Intermediate) from Alpha Vantage.   
#>

# Define the function Get-Stocks
function Get-Stocks {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Id  # The symbol for the commodity or stock (e.g., WTI, VMW)
    )
    
    $apiKey = Get-Secret -Name AlfaVantageAPI -AsPlainText   # Replace with your Alpha Vantage API Key
    $url = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=$Id&apikey=$apiKey"
    
    try {
        # Fetch data from Alpha Vantage 
        $response = Invoke-RestMethod -Uri $url -Method Get
        
        # Check if the response contains the Time Series data
        if ($response.'Time Series (Daily)') {
            $commodityData = $response.'Time Series (Daily)'
            
            # Display the most recent data (e.g., the latest date and its price)
            $latestDate = $commodityData.PSObject.Properties.Name | Sort-Object -Descending | Select-Object -First 1
            $latestData = $commodityData.$latestDate
            
            $openPrice = $latestData.'1. open'
            $closePrice = $latestData.'4. close'
            
            # Check if closing price is higher or lower than opening price and highlight with color
            if ($closePrice -gt $openPrice) {
                # Green if closing price is higher than open
                Write-Host "Latest price for $Id on $latestDate" -ForegroundColor Magenta
                Write-Host "Open: $openPrice" -ForegroundColor White
                Write-Host "High: $($latestData.'2. high')" -ForegroundColor White
                Write-Host "Low: $($latestData.'3. low')" -ForegroundColor White
                Write-Host "Close: $closePrice" -ForegroundColor Green
            } elseif ($closePrice -lt $openPrice) {
                # Red if closing price is lower than open
                Write-Host "Latest price for $Id on $latestDate" -ForegroundColor Magenta
                Write-Host "Open: $openPrice" -ForegroundColor White
                Write-Host "High: $($latestData.'2. high')" -ForegroundColor White
                Write-Host "Low: $($latestData.'3. low')" -ForegroundColor White
                Write-Host "Close: $closePrice" -ForegroundColor Red
            } else {
                # Yellow if closing price is equal to open (neutral)
                Write-Host "Latest price for $Id on $latestDate" -ForegroundColor Magenta
                Write-Host "Open: $openPrice" -ForegroundColor White
                Write-Host "High: $($latestData.'2. high')" -ForegroundColor White
                Write-Host "Low: $($latestData.'3. low')" -ForegroundColor White
                Write-Host "Close: $closePrice" -ForegroundColor Yellow
            }
        } else {
            Write-Host "No data found or invalid symbol. Please check your API request."
        }
    } catch {
        Write-Host "Error retrieving data: $_" 
    }
}

# If this script is being run directly (not from a module), call the function with parameters
if ($PSCmdlet.MyInvocation.InvocationName -eq 'Get-Stocks') {
    param(
        [string]$Id = "WTI"  # Default to WTI if no ID is provided
    )
    Get-Stocks -Id $Id
}

