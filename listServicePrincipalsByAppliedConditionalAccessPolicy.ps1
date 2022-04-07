# Uses the Microsoft Graph PowerShell SDK
# Required Module 
# Install-Module -Name Microsoft.Graph.Reports

$CondtionalAccessID = ""

# Request permissions and authenticate
Connect-MgGraph -Scopes "AuditLog.Read.All"

# Use Graph Beta endpoint
Select-MgProfile -Name "beta"

# Get all SP sign ins
$SPSignIns = Get-MgAuditLogSignIn -all -Filter "signInEventTypes/any(t: t eq 'servicePrincipal')"

# Initialize SPsWithCAPolicyApplied array
$SPsWithCAPolicyApplied = @()

# For each applied CA policy that contains the CA ID in each sign in, add to SPsWithCAPolicyApplied
foreach ($SPSignIn in $SPSignIns) {
    foreach ($AppliedConditionalAccessPolicy in $SPSignIn.AppliedConditionalAccessPolicies) {
        if ($AppliedConditionalAccessPolicy.id.contains($CondtionalAccessID)) {
            $SPsWithCAPolicyApplied += @($SPSignIn)
        }  
    }
}

$SPsWithCAPolicyApplied.appDisplayName | Get-Unique 
