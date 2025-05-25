function Get-WebhooksUrls {
    param(
        [string]$FullRepositoryName
    )

    $fullRepositoryNameUrl = "repos/${FullRepositoryName}/hooks"
    $responseArray = $( gh api $fullRepositoryNameUrl ) | ConvertFrom-Json
    $webhooks = @()
    foreach ($response in $responseArray) {
        $webook = [PSCustomObject]@{
            url = $response.config.url
            id  = $response.id
        }

        $webhooks += $webook;
    }
   
    return $webhooks
}

function GetConfiguration {
    param(
        [string]$FileName
    )
    $config = Get-Content $FileName | ConvertFrom-Json
    return $config
}

function DeleteWebHook {

    param(
        $Webhook,
        $FullRepositoryName
    )
    $id=$Webhook.id
    $hookIdUrl="repos/${FullRepositoryName}/hooks/$id"
    gh api $hookIdUrl  -X DELETE
    
    Write-Output "Webhook $($Webhook.Url) removed"
   
}
function DeleteWebHooks {
    param(
        [string]$FullRepositoryName
    ) 
    Write-Output "Deleting webhooks for $FullRepositoryName"
    $webhooks = Get-WebhooksUrls -FullRepositoryName $FullRepositoryName
    foreach ($webhook in $webhooks) {
        DeleteWebHook -Webhook $webhook -FullRepositoryName $FullRepositoryName
    }
}

function AddWebhook{
    param(
        $repositoryName,
        $webHookUrl
    )

    #$hooksUrl="repos/ProductivityTools-Transfers/ProductivityTools.Transfers.Api/hooks"
    $hooksUrl="repos/$repositoryName/hooks"
    $jsonPayload='{"name":"web","active":true,"events":["push","pull_request","release"],"config":{"url":"'+$webHookUrl+'","content_type":"form","insecure_ssl":"0"}}'
    #echo $jsonPayload
    Write-Host $jsonPayload
    $x=$(echo $jsonPayload | gh api $hooksUrl  --input - -X POST)
    Write-Output "Webhook $hooksUrl added"

}
function AddWebhooks {
    param(
        $repository
    )
    foreach ($webhook in $repository.WebHooks) {
        Write-Host "Adding webhook for"
        Write-host  $repository.RepositoryName
        Write-Host "Webhook url"
        Write-Host $webhook
        AddWebhook -repositoryName $repository.RepositoryName -webHookUrl $webhook
    }
}

function Set-WebhooksAsInConfigurationFile {

    $config = GetConfiguration -FileName "Configuration.json"
    foreach ($repository in $config) {
        DeleteWebHooks($repository.RepositoryName)
        AddWebhooks($repository)
        #Write-Output $repository.RepositoryName;
        # Write-Output $repository.WebHooks
    }
}

function Get-AllWebhooksDefinedInConfigurationFile{
     $config = GetConfiguration -FileName "Configuration.json"
    foreach ($repository in $config) {
        Write-Output $repository.RepositoryName
        $webhooksUrls= Get-WebhooksUrls -FullRepositoryName $repository.RepositoryName
        Write-Output $webhooksUrls
    }
}

Export-ModuleMember Get-WebhooksUrls 
Export-ModuleMember Set-WebhooksAsInConfigurationFile
Export-ModuleMember Get-AllWebhooksDefinedInConfigurationFile
#$webhooksUrls=GetWebhooksUrls -FullRepositoryName "ProductivityTools-Transfers/ProductivityTools.Transfers.Api"
#Write-Output $webhooksUrls