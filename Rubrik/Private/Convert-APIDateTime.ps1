function Convert-APIDateTime {
    <#
        .SYNOPSIS
        Converts a string to a datetime object

        .DESCRIPTION
        The Rubrik API endpoints often return dates within the response. These dates are treated as strings within the response. 
        This function may be used to convert these returned date strings into a properly formated datetime object.

        .EXAMPLE
        Convert-APIDateTime "Thu Aug 08 20:31:36 UTC 2019" 

        Thursday, August 8, 2019 8:31:36 PM
    #>
    [cmdletbinding()]
    param(
        [parameter(
            Position = 0,
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [ValidateNotNullOrEmpty()]
        [string] $DateTimeString
    )

    begin {
        [System.Globalization.DateTimeFormatInfo]::InvariantInfo.get_abbreviatedmonthnames() | ForEach-Object -Begin {
            $MonthHash = @{}
            $Count = 0
        } -Process {
            $Count++
            if ($_) {
                $MonthHash.$_ = $Count.ToString().Padleft(2,'0')
            }
        }
    }

    process {
        $NewDateTimeString = $DateTimeString.Substring(4) -replace 'UTC '
        $MonthHash.GetEnumerator() | ForEach-Object {
            $NewDateTimeString = $NewDateTimeString -replace $_.Key,$_.Value
        }

        try {
            [DateTime]::ParseExact($NewDateTimeString,'MM dd HH:mm:ss yyyy',$null)
        } catch {
        }
    }
}