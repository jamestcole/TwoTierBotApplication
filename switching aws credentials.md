For Linux/Mac:

bash
```
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
```
For Windows:

powershell
```Copy code
[System.Environment]::SetEnvironmentVariable('AWS_ACCESS_KEY_ID', $null)
[System.Environment]::SetEnvironmentVariable('AWS_SECRET_ACCESS_KEY', $null)
[System.Environment]::SetEnvironmentVariable('AWS_SESSION_TOKEN', $null)
```
Profile Switching:

If you have multiple profiles set up in your configuration, make sure to specify the correct one when running AWS commands:
bash
Copy code
aws sts get-caller-identity --profile <your-profile-name>