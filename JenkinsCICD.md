#Jenkins CI Pipeline Setup for GitHub (Windows)
This documentation provides a step-by-step guide to set up a Continuous Integration (CI) pipeline using Jenkins on a Windows machine, with GitHub webhooks to trigger builds on push events.

Prerequisites
Jenkins installed and running on a Windows machine.
GitHub repository for the project.
Jenkins GitHub Plugin installed.
Ngrok (for exposing Jenkins to the internet for GitHub webhooks).
Step 1: Install and Configure Jenkins
Install Jenkins on Windows. Once installed, verify that Jenkins is running by accessing http://localhost:8080 or http://localhost:80.

Install Required Plugins in Jenkins:

Go to Manage Jenkins > Manage Plugins.
Install the GitHub and Pipeline plugins.
Step 2: Setup Ngrok for Webhooks
Install Ngrok and start it to expose Jenkins to the internet:

bash
Copy code
ngrok http 8080
Replace 8080 with the port Jenkins is running on.

Copy the Forwarding URL provided by Ngrok (e.g., https://<your-ngrok-id>.ngrok-free.app).

Step 3: Configure GitHub Webhooks
Go to your GitHub repository and navigate to Settings > Webhooks.

Click Add Webhook and set:

Payload URL: <Ngrok URL>/github-webhook/ (e.g., https://<ngrok-id>.ngrok-free.app/github-webhook/)
Content Type: application/json
Event: Just the push event.
Step 4: Configure Jenkins Job
Create a new Jenkins Job:

Go to New Item > Pipeline.
Name it pusheventjob and select Pipeline.
Configure the Job:

Definition: Pipeline script from SCM.
SCM: Git.
Repository URL: https://github.com/<your-username>/<your-repo>.git.
Branch: */main (or the branch you're working on).
Script Path: Jenkinsfile.
Triggers:

Enable GitHub hook trigger for GITScm polling under Build Triggers.
Step 5: Create Jenkinsfile in the GitHub Repository
Create a Jenkinsfile in the root of your GitHub repository with the following content (in groovy but no need to add extension):

groovy
```
pipeline {
    agent any
    stages {
        stage('Check Push') {
            steps {
                // Use 'bat' for Windows
                bat 'echo Push event received!'
            }
        }
    }
}
```
Commit and push the Jenkinsfile to your repository.

Step 6: Testing the Webhook and Build
Push Code to the repository (e.g., git push origin main).

Verify the Build:

Go to the Jenkins dashboard and check that the pusheventjob is triggered automatically by the GitHub webhook.
The build should complete successfully with a simple confirmation message in the log.
Troubleshooting
403 Error on Webhook Delivery: Ensure that the Ngrok URL is correct and that Jenkins is exposed on the right port.
nohup or Shell Errors: Since Jenkins is running on Windows, make sure to use bat commands instead of sh in your pipeline.
Conclusion
This setup will trigger a Jenkins build every time there’s a push to the GitHub repository, allowing for automated CI testing.