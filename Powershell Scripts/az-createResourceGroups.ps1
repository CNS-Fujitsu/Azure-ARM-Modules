<#
    .DESCRIPTION
        This script iterates through an array of names and creates Azure AD user Groups (You must login to Azure via powershell before running this script)

    .PARAMETER parameterfilename
        Name and location of the CSV parameter file.
    
    .NOTES
        AUTHOR: Steve Owens
        LASTEDIT: Jan 29, 2019
#>

param(
 
    [string] $parameterfilename = "./resourceGroupParameters.csv"
)



    function main([array]$aparameterfilename) {
        #load parameters from CSV file
        $resourcegroups  = Import-Csv "$parameterfilename"


        # Loop to create all AzureAD resource groups
        foreach ($resourcegroup in $resourcegroups) {
            New-AzureRmResourceGroup -Name $resourcegroup.resourcegroupname  -Location $resourcegroup.resourcegrouplocation
        }
    }

# Run the main function
main -parameterfilename $parameterfilename







