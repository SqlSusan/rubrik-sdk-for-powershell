#Requires -Version 3
function Get-RubrikVCenter
{
  <#  
      .SYNOPSIS
      Connects to Rubrik and retrieves the current Rubrik vCenter settings
            
      .DESCRIPTION
      The Get-RubrikVCenter cmdlet will retrieve the all vCenter settings actively running on the system. This does require authentication.
            
      .NOTES
      Adapted by Adam Shuttleworth from scripts by Chris Wahl for community usage
            
      .LINK
      https://rubrik.gitbook.io/rubrik-sdk-for-powershell/command-documentation/reference/get-rubrikvcenter
            
      .EXAMPLE
      Get-RubrikVCenter
      This will return the vCenter settings on the currently connected Rubrik cluster
  #>

  [CmdletBinding()]
  Param(
    # vCenter Name
    [String]$Name,
    # Rubrik server IP or FQDN
    [String]$Server = $global:RubrikConnection.server,
    # Filter the summary information based on the primarycluster_id of the primary Rubrik cluster. Use 'local' as the primary_cluster_id of the Rubrik cluster that is hosting the current REST API session.
    [Alias('primary_cluster_id')]
    [String]$PrimaryClusterID,  
    # API version
    [ValidateNotNullorEmpty()]
    [String]$api = $global:RubrikConnection.api
  )

  Begin {

    # The Begin section is used to perform one-time loads of data necessary to carry out the function's purpose
    # If a command needs to be run with each iteration or pipeline input, place it in the Process section

    # Check to ensure that a session to the Rubrik cluster exists and load the needed header data for authentication
    Test-RubrikConnection
    
    # API data references the name of the function
    # For convenience, that name is saved here to $function
    $function = $MyInvocation.MyCommand.Name
        
    # Retrieve all of the URI, method, body, query, result, filter, and success details for the API endpoint
    Write-Verbose -Message "Gather API Data for $function"
    $resources = Get-RubrikAPIData -endpoint $function
    Write-Verbose -Message "Load API data for $($resources.Function)"
    Write-Verbose -Message "Description: $($resources.Description)"
  
  }

  Process {

    $uri = New-URIString -server $Server -endpoint ($resources.URI) -id $id
    $uri = Test-QueryParam -querykeys ($resources.Query.Keys) -parameters ((Get-Command $function).Parameters.Values) -uri $uri
    $body = New-BodyString -bodykeys ($resources.Body.Keys) -parameters ((Get-Command $function).Parameters.Values)
    $result = Submit-Request -uri $uri -header $Header -method $($resources.Method) -body $body
    $result = Test-ReturnFormat -api $api -result $result -location $resources.Result
    $result = Test-FilterObject -filter ($resources.Filter) -result $result
    $result = Set-ObjectTypeName -TypeName $resources.ObjectTName -result $result

    return $result

  } # End of process
} # End of function