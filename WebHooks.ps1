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
        [string]$WebhookUrl
    )
    
    gh api repos/ProductivityTools-Transfers/ProductivityTools.Transfers.Api/hooks --input - -X POST

    Write-Output "Removing webhook $WebhookUrl"
}
function DeleteWebHooks {
    param(
        [string]$FullRepositoryName
    )
    $webhooksUrls = GetWebhooks -FullRepositoryName $FullRepositoryName
    foreach ($webhook in $webhooks) {
        DeleteWebHook -WebhookUrl $webhookUrl
    }
}

function AddMissingWebhooks {

}

function Main {

    $config = GetConfiguration -FileName "Configuration.json"
    foreach ($repository in $config) {
        DeleteWebHooks($repository.RepositoryName)
        #Write-Output $repository.RepositoryName;
        # Write-Output $repository.WebHooks
    }


}
Main
#$webhooksUrls=GetWebhooksUrls -FullRepositoryName "ProductivityTools-Transfers/ProductivityTools.Transfers.Api"
#Write-Output $webhooksUrls