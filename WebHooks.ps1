function GetWebhooks {
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
        $Webhook
    )
    $id=$Webhook.id
    $hookIdUrl="repos/ProductivityTools-Transfers/ProductivityTools.Transfers.Api/hooks/$id"
    gh api $hookIdUrl  -X DELETE
    
    Write-Output "Webhook $($Webhook.Url) removed"
   
}
function DeleteWebHooks {
    param(
        [string]$FullRepositoryName
    )
    $webhooks = GetWebhooks -FullRepositoryName $FullRepositoryName
    foreach ($webhook in $webhooks) {
        DeleteWebHook -Webhook $webhook
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
    echo $jsonPayload | gh api $hooksUrl  --input - -X POST

}
function AddWebhooks {
    param(
        $repository
    )
    foreach ($webhook in $repository.WebHooks) {
        AddWebhook -repositoryName $repository.RepositoryName -webHookUrl $webhook
    }
}

function Main {

    $config = GetConfiguration -FileName "Configuration.json"
    foreach ($repository in $config) {
        DeleteWebHooks($repository.RepositoryName)
        AddWebhooks($repository)
        #Write-Output $repository.RepositoryName;
        # Write-Output $repository.WebHooks
    }


}
Main
#$webhooksUrls=GetWebhooksUrls -FullRepositoryName "ProductivityTools-Transfers/ProductivityTools.Transfers.Api"
#Write-Output $webhooksUrls