﻿Function Test-RubrikSLA($SLA, $Inherit, $DoNotProtect, $Mandatory, $PrimaryClusterID) {
  <#
    .SYNOPSIS
    Retrieves an ID for a given SLA

    .DESCRIPTION
    The Test-RubrikSLA function retrieves the ID for a given SLA Domain name

    .PARAMETER SLA
    The SLA Domain name to lookup

    .PARAMETER Inherit
    Switch to set SLA to 'Inherit'

    .PARAMETER DoNotProtect
    Switch to set SLA to 'Unprotected'

    .PARAMETER Mandatory
    Switch to ensure SLA information was inputted

    .PARAMETER PrimaryClusterId
    The ID of the cluster to search
  #>

  # Determine the state of $PrimaryClusterID
  Write-Verbose -Message "Primary cluster ID currently set to: $PrimaryClusterID"
  if (!$PrimaryClusterID) {
    $PrimaryClusterID = 'local'
    Write-Verbose -Message "Null value found. Setting primary cluster ID to $PrimaryClusterID"
  }

  Write-Verbose -Message 'Determining the SLA Domain id'
  if ($SLA) {
    $slaid = (Get-RubrikSLA -SLA $SLA -PrimaryClusterID $PrimaryClusterID).id
    if ($slaid -eq $null) {
      throw "No SLA Domains were found that match $SLA for $PrimaryClusterID"
    }
    return $slaid
  }
  if ($Inherit) {
    return 'INHERIT'
  }
  if ($DoNotProtect) {
    return 'UNPROTECTED'
  }
  if ($Mandatory) {
    throw 'No SLA information was entered.'
  }
}

