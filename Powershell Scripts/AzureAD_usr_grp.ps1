<#
    .DESCRIPTION
        This script iterates through an array of names and create Azure AD user Groups (You must login to Azure via powershell before running this script)

    .PARAMETER adusrgroups
        list of Azure Ad User Group names
    
    .NOTES
        AUTHOR: Steve Owens
        LASTEDIT: Jan 29, 2019
#>

param(
 
    [array] $adusrgroups = @(
                                "Azure-Global-Administrators-aadsecg",
                                "Azure-Network-Administrators-aadsecg",
                                "Azure-Billing-Adminstrators-aadsecg",
                                "Azure-Develeopers-aadsecg",
                                "Azure-Auditors-aadsdecg",
                                "Azure-Ad-User-Administrators-aadsecg"
                            )
)

    function createadgroup([string]$adusergroup) {
        # Create AzureAd User group
        New-AzureRMADGroup -DisplayName $adusergroup -MailNickname $adusergroup
    }

    function main([array]$adusrgroups) {
        # Loop to create all AzureAD resource groups
        foreach ($adusergroup in $adusrgroups) {
            createadgroup -adusergroup $adusergroup
        }
    }

# Run the main function
main -adusrgroups $adusrgroups







