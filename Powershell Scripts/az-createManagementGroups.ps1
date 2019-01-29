<#
    .DESCRIPTION
        This script iterates through an array of names and creates the Azure Management Group Hierarcy (You must login to Azure via powershell before running this script)

    .PARAMETER parameterfilename
        Name and location of the CSV parameter file.
    
    .NOTES
        AUTHOR: Steve Owens
        LASTEDIT: Jan 29, 2019
#>

param(
 
    [string] $parameterfilename = "./xxx.csv"
)
    
    function main([string] $parameterfilename) {
        #load parameters from CSV file
        $managementgroups  = Import-Csv "$parameterfilename"

        # Loop to create all Azure Management groups
        foreach ($managementgroup in $managementgroups) {
            If ($managementgroup.managementgroupparent)
                {
                    New-AzureRmManagementGroup -GroupName $managementgroup.managementgroupname -DisplayName $managementgroup.managementgroupname -ParentId $managementgroup.managementgroupparent
                }
                Else
                {
                    New-AzureRmManagementGroup -GroupName $managementgroup.managementgroupname -DisplayName $managementgroup.managementgroupname
                }
        }
    }


# Run the main function
main -parameterfilename $parameterfilename







