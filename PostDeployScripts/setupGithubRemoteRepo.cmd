@echo off
setlocal
rem ------------------------------------------------------------------------------------------
rem setupVsoRemoteRepo [remoteUser] [personalAccessToken] [projName] | [orgName(optional)]
rem create and populate VSO git repo for the ABS code instance
rem 
rem remoteUser: user account name of the personal access token
rem personalAccessToken: the personal access token used to access github REST API (requires repos scope)
rem projName the name of the project to create (default to WEBSITE_SITE_NAME)
rem orgName (optional) the orgName under which the repo should be created
rem ------------------------------------------------------------------------------------------
set remoteUrl=https://api.github.com
set remoteUser=%1
set remotePwd=%2
set projName=%3
set orgName=%4
if '%projName%'=='' set projName=%WEBSITE_SITE_NAME%
set pathName=%orgName%
set repoApiPath=orgs/%orgName%/repos
set errorno=0

if '%orgName%'=='' set repoApiPath=user/repos
if '%pathName%'=='' set pathName=%remoteUser%
set repoUrl=https://%remoteUser%:%remotePwd%@github.com/%pathName%/%projName%.git
rem use curl to create project
pushd ..\wwwroot
type PostDeployScripts\githubProject.json.template | sed -e s/\{WEB_SITE_NAME\}/%projName%/g > %TEMP%\githubProject.json
call curl -H "Content-Type: application/json" -u %remoteUser%:%remotePwd% -d "@%TEMP%\githubProject.json" -X POST  %remoteUrl%/%repoApiPath% -w "%%%%{http_code}" -o ..\curl.json > ..\curl.code
for /f "delims=" %%t in (..\curl.code) do set gitStatus=%%t
if %gitStatus% GEQ 300 set errorno=%gitStatus%
if %errorno% neq 0 goto :end
rem rm %TEMP%\githubProject.json
popd

popd
rem cd to project root
pushd ..\wwwroot
echo setting up git and upload to remote repo
rem init git
call git init
call git config user.name "%remoteUser%"
call git config user.password "%remotePwd%"
call git config user.email "util@botframework.com"
call git add .
call git commit -m "prepare to setup source control"
call git push %repoUrl% master
popd


rem cleanup git stuff
pushd ..\wwwroot
call rm -r -f .git
popd

endlocal

:end
echo errorno=%errorno%
exit /b %errorno%