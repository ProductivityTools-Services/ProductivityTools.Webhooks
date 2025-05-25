properties([pipelineTriggers([githubPush()])])

pipeline {
    agent any

    stages {
        stage('hello') {
            steps {
                // Get some code from a GitHub repository
                echo 'hello'
            }
        }
        stage('Delete workspace') {
            steps {
                deleteDir()
            }
        }
        stage('Clone repository') {
            steps {
                // Get some code from a GitHub repository
                git branch: 'main',
                url: 'https://github.com/ProductivityTools-Services/ProductivityTools.Webhooks.git'
            }
        }
       
        stage('Change configuration') {
            steps {
                powershell('''
                function SetConfiguration(){
					Import-Module .\\Productivitytools.WebHooks.psm1 -Force
					Set-WebhooksAsInConfigurationFile
					Get-AllWebhooksDefinedInConfigurationFile

                }
                function GetConfiguration {
                    param(
                        [string]$FileName
                    )
                    $config = Get-Content $FileName | ConvertFrom-Json
                    return $config
                }
                $env:Path = 'C:\\Program Files\\GitHub CLI\\;;' + $env:Path
                $token=get-masterconfiguration GithubCLI
                $env:GITHUB_TOKEN = $token
                echo $env:GITHUB_TOKEN

                $config = GetConfiguration -FileName "Configuration.json"
                write-host "xxxx"
                write-host $config  
                foreach ($repository in $config) {
                    Write-Host $repository.RepositoryName;
                    # Write-Output $repository.WebHooks
                }

                #SetConfiguration  
                  
                ''')
            }
        }
		
        stage('byebye') {
            steps {
                // Get some code from a GitHub repository
                //				#Add-SqlLogin -ServerInstance ".\\sql2022" -LoginName "IIS APPPOOL\\PTTrips" -LoginType "WindowsUser" -DefaultDatabase "PTTrips"
                //	If(-not(Get-InstalledModule SQLServer -ErrorAction silentlycontinue)){
				//	Install-Module SQLServer -Confirm:$False -Force -AllowClobber 
				//}
                echo 'byebye1'
            }
        }
    }
	post {
		always {
            emailext body: "${currentBuild.currentResult}: Job ${env.JOB_NAME} build ${env.BUILD_NUMBER}\n More info at: ${env.BUILD_URL}",
                recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']],
                subject: "Jenkins Build ${currentBuild.currentResult}: Job ${env.JOB_NAME}"
		}
	}
}
