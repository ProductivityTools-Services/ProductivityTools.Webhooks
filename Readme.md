
List all the webhooks for the repository with cli
```
gh api repos/ProductivityTools-Transfers/ProductivityTools.Transfers.Api/hooks 
```

Add a new webhook
```
echo '{"name":"web","active":true,"events":["push","pull_request","release"],"config":{"url":"http://xjenkinswebhook.productivitytytools.top","content_type":"form","insecure_ssl":"0"}}' | gh api repos/ProductivityTools-Transfers/ProductivityTools.Transfers.Api/hooks --input - -X POST
```

[documentation](https://cli.github.com/manual/gh_api)
[stackoverflow](https://stackoverflow.com/questions/75794370/create-a-github-webhook-using-the-github-cli)