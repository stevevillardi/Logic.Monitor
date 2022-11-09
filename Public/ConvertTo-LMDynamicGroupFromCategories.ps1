<#
.SYNOPSIS
Create a series of dynamic groups based off of active system.categories applied to your portal

.DESCRIPTION
Created dynamic groups based on in use device categories

.EXAMPLE
ConvertTo-LMDynamicGroupFromCategories

.NOTES
Created groups will be placed in devices by type default resource group

.INPUTS
None. You cannot pipe objects to this command.

.LINK
Module repo: https://github.com/stevevillardi/Logic.Monitor

.LINK
PSGallery: https://www.powershellgallery.com/packages/Logic.Monitor
#>
Function ConvertTo-LMDynamicGroupFromCategories {

    $device_list = @()
    $category_list = @()

    #Get list of LM devices
    $devices = Get-LMDevice

    #Loop through each device build custom object
    foreach ($dev in $devices) {
        $device_list += [PSCustomObject]@{
            id          = $dev.id
            displayName = ($dev.displayName).toupper()
            categories  = ($dev.customProperties[$dev.customProperties.name.IndexOf("system.categories")].value).Split(",")

        }
    }

    #Loop through custom object and aggregate categories
    foreach ($category in $device_list.categories) {
        $category_list += $category
    }

    #Dedupe list down to unique values
    $category_list = $category_list | Select-Object -Unique

    #Grab id for devices by type folder (could optionally be set to any group)
    $root_group = (Get-LMDeviceGroup -Name "Devices by Type").id

    #if we have a matching folder continue
    if ($root_group) {
        #Grab list of dynamic groups currently inside root group
        $current_groups = (Get-LMDeviceGroupGroups -Id $root_group).name

        #Compare the group list and pull out anything we already created or matches existing groups
        $creation_list = (Compare-Object -ReferenceObject $current_groups -DifferenceObject $category_list.Replace("/", " ").Replace("_", " ") | Where-Object { $_.SideIndicator -eq "=>" }).InputObject
    
        #Loop trough category list and create any groups not already exisitng
        foreach ($group in $creation_list) {
            $name = $group.Replace("/", " ").Replace("_", " ")
            New-LMDeviceGroup -Name $name -AppliesTo "hasCategory(`"$group`")" -ParentGroupId $root_group -Description "Auto created by PowerShell module"
        }
    }
}