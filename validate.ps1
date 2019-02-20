<#
    .DESCRIPTION
        xxx

    .PARAMETER parameterfilename
        xx.
    
    .NOTES
        AUTHOR: Steve Owens
        LASTEDIT: Feb 20, 2019
        VERSION: 1.0.0.1
#>

param(
    [string] [Parameter(Mandatory=$true)] $rgName,
    [string] $modules = "./modules/",
    [string] $parameters = "./parameters/"
)
Function checkForParameterFile ($parameterFile) {
    $return = Test-Path $parameterFile
    return $return
}

Function validatejson ($filename) {
    
    Test-AzureRmResourceGroupDeployment
}

Function validateTemplate ($templateFileName, $parameterFileName, $modules, $parameters ) {
    $templateFile = "$modules$templateFileName"
    $parameterFile = "$parameters$parameterFileName"

    if (checkForParameterFile -parameterFile $parameterFile) {
        "Success"

    } else {
        Write-Host "No parameter file exsists for template file - $templateFileName"
    }
}


Param(
  [string] [Parameter(Mandatory=$true)] $ResourceGroupName,
  [string] [Parameter(Mandatory=$true)] $TemplateFile,
  [hashtable] [Parameter(Mandatory=$true)] $Parameters
)

Describe "Logic App Deployment Tests" {
  BeforeAll {
    $DebugPreference = "Continue"
  }

  AfterAll {
    $DebugPreference = "SilentlyContinue"
  }

function validatearmtemplate (){
    Context "When Logic App deployed without parameters" {
        try {
        $output = Test-AzureRmResourceGroupDeployment `
                    -ResourceGroupName $ResourceGroupName `
                    -TemplateFile $TemplateFile `
                    -ErrorAction Stop `
                    5>&1
        }
        catch {
        $ex = $_.Exception | Format-List -Force
        }

        It "Should throw exception" {
        $ex | Should -Not -Be $null
        $ex.Message | Should -Not -Be ([string]::Empty)
        }
    }

    Context "When Logic App deployed with parameters" {
        $output = Test-AzureRmResourceGroupDeployment `
                -ResourceGroupName $ResourceGroupName `
                -TemplateFile $TemplateFile `
                -TemplateParameterObject $Parameters `
                -ErrorAction Stop `
                5>&1
        $result = (($output[32] -split "Body:")[1] | ConvertFrom-Json).properties

        It "Should be deployed successfully" {
        $result.provisioningState | Should -Be "Succeeded"
        }

        It "Should have name of" {
        $expected = $Parameters.LogicAppName1 + "-" + $Parameters.LogicAppName2
        $resource = $result.validatedResources[0]

        $resource.name | Should -Be $expected
        }
    }
    }
}