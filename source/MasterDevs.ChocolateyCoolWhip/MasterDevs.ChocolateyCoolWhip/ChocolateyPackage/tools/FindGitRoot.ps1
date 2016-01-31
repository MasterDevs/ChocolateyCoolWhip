$githubRegex = "https://github.com/(?<username>\w+)/(?<projectName>\w+)(.git)?"

Function findGitRoot([string]$pathInGit)
{

    while(![string]::IsNullOrEmpty($pathInGit)) {

        #Check if .git folder exists
        if(Test-Path "$($pathInGit)\.git") {
            Return $pathInGit
        }

        $pathInGit =  Split-Path -Path $pathInGit -Parent;
    }

    Return ""
}

Function findRemoteOriginUrl([string] $gitRoot)
{
    $configFile = Join-Path $gitRoot ".git\config"
    $configContent = Get-Content $configFile
    $remoteUrlKey = '[remote "origin"]'

    $currentkey = "nokey"
    $config = @{ $currentkey = @{} }
    foreach($line in $configContent)
    {
        if ($line -match '\[.*\]')
        {
            $currentkey = $line
            if ($config.ContainsKey($currentkey) -eq 0)
            {
                $config.Add($currentkey, @{})
            }
        }
        elseif ($line.Contains('='))
        {
            $left, $right = $line.Split('=')
            $left = $left.Trim()
            $right = $right.Trim()

            $config[$currentkey][$left] = $right
        }
    }

    if ($config.ContainsKey($remoteUrlKey) -and $config[$remoteUrlKey].ContainsKey("url"))
    {
        return $config[$remoteUrlKey].url
    }

    Return 
}

Function getProjectNameFromUrl([string] $projectUrl)
{
    if ($projectUrl -match $githubRegex)
    {
        return $matches.projectName
    }

    return "{{GITHUB_PROJECT_NAME}}"
}

Function getUsernameFromUrl([string] $projectUrl)
{
    if ($projectUrl -match $githubRegex)
    {
        return $matches.username
    }

    return "{{GITHUB_USERNAME}}"
}