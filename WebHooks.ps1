function GetWebhooksUrls{
    param(
        [string]$FullRepositoryName
    )

    $fullRepositoryNameUrl="repos/${FullRepositoryName}/hooks"
    $responseArray=$( gh api $fullRepositoryNameUrl ) | ConvertFrom-Json
    $webhooksUrls=@()
    foreach($response in $responseArray)
    {
        $url=$response.config.url;
        $webhooksUrls+= $url;
    }
    Write-Output $webhooksUrls
}

GetWebhooksUrls -FullRepositoryName "ProductivityTools-Transfers/ProductivityTools.Transfers.Api"