#!/bin/bash

# Author: Bruno Rossi <brunorossiweb@gmail.com>
# Install the NGMC and a new GitHub repository on CentOS 7+ versions
# usage: ./init.sh

echo "----------------------------------"
echo "Please review the following values"
echo "----------------------------------"
echo "Project Name: $PROJECT_NAME"
echo "Project Folder: $PROJECT_FOLDER"
echo "Project Description: $PROJECT_DESCRIPTION"
echo "Github Access Token: $GITHUB_ACCESS_TOKEN"
echo "Github First Commit Message: $GITHUB_FIRST_COMMIT_MESSAGE"
echo "Theme Directory Name: $THEME_DIR_NAME"
echo "Contentful Access Token: $CONTENTFUL_ACCESS_TOKEN"
echo "Contentful Space Name: $CONTENTFUL_SPACE_NAME"
echo "Contentful Locale: $CONTENTFUL_LOCALE"
echo "Netlify Access Token: $NETLIFY_ACCESS_TOKEN"
echo "Web Site Title: $WEB_SITE_TITLE"
echo "Web Site Description: $WEB_SITE_DESCRIPTION"
echo "Web Site URL: $WEB_SITE_URL"
echo "Web Site Keywords: $WEB_SITE_KEYWORDS"
echo "Web Site Author: $WEB_SITE_AUTHOR"
echo "Web Site Email: $WEB_SITE_EMAIL"
echo "Local Web Server Deploy Folder: $LOCAL_WEB_SERVER_DEPLOY_FOLDER"
echo "Git User: $GITHUB_FULL_NAME"
echo "Git Email: $GITHUB_EMAIL"
echo "Git User Name: $GITHUB_USERNAME"
echo "Git Password: $GITHUB_PASSWORD"
echo -e "--------------------------------- \n"

git config --global user.name $GITHUB_FULL_NAME
git config --global user.email $GITHUB_EMAIL
git config --global credential.helper store

cat > /root/.git-credentials << EOL
https://${GITHUB_USERNAME}:${GITHUB_PASSWORD}@github.com
EOL

# create the repo for the project
GIT_RESPONSE=$(curl \
-u :${GITHUB_ACCESS_TOKEN} \
https://api.github.com/user/repos \
-d "{\"name\": \"${PROJECT_NAME}\", \"description\": \"${PROJECT_DESCRIPTION}\" }")

echo $GIT_RESPONSE

SSH_URL=$(echo $GIT_RESPONSE | jq -r .ssh_url)
GIT_URL=$(echo $GIT_RESPONSE | jq -r .git_url)
GIT_CLONE_URL=$(echo $GIT_RESPONSE | jq -r .clone_url)
GIT_REPO_PATH=$(echo $GIT_RESPONSE | jq -r .full_name)
GIT_NETLIFY_URL=$(echo $GIT_RESPONSE | jq -r .svn_url)

echo "Your repository has been successfully created."
echo "The clone URL is the following:"
echo $SSH_URL
echo "The Git URL is the following:"
echo $GIT_URL
echo "The Clone Url is the following:"
echo $GIT_CLONE_URL
echo "The Repo path is the following:"
echo $GIT_REPO_PATH

# Add the public ssh key for GitHub
# eval $(ssh-agent -s)
# ssh-add $GITHUB_SSH_PUBLIC_KEY_PATH

# Clone the main repository
git clone \
https://github.com/brunorossi/ngmc.git \
$PROJECT_FOLDER

# create the envs directories and files
mkdir -p $PROJECT_FOLDER/envs/production
cat > $PROJECT_FOLDER/envs/production/.env << EOL
SOURCE_CONFIG_DIR=./configs
SOURCE_MODELS_DIR=./content-models
THEME_DIR_NAME=$THEME_DIR_NAME
CONTENTFUL_ACCESS_TOKEN=$CONTENTFUL_ACCESS_TOKEN
CONTENTFUL_SPACE_NAME=$CONTENTFUL_SPACE_NAME
CONTENTFUL_LOCALE=$CONTENTFUL_LOCALE
CONTENTFUL_API_KEY_ID_PREFIX=metalsmith-api-key
CONTENTFUL_API_KEY_NAME_PREFIX=metalsmithApiKey
NETLIFY_ACCESS_TOKEN=$NETLIFY_ACCESS_TOKEN
EOL

cd $PROJECT_FOLDER

# sed -i s/\{webSiteTitle\}/$WEB_SITE_TITLE/g configs-templates/metadata.yml
# sed -i s/\{webSiteDescription\}/$WEB_SITE_DESCRIPTION/g configs-templates/metadata.yml
# sed -i s/\{webSiteUrl\}/$WEB_SITE_URL/g configs-templates/metadata.yml
# sed -i s/\{webSiteKeywords\}/$WEB_SITE_KEYWORDS/g configs-templates/metadata.yml
# sed -i s/\{webSiteAuthor\}/$WEB_SITE_AUTHOR/g configs-templates/metadata.yml

# sed -i s/\{localWebServerDeployFolder\}/$LOCAL_WEB_SERVER_DEPLOY_FOLDER/g configs-templates/deploy.yml
# sed -i s/\{email\}/$WEB_SITE_EMAIL/g configs-templates/deploy.yml
# sed -i s/\{contentfulAccessToken\}/$CONTENTFUL_ACCESS_TOKEN/g configs-templates/deploy.yml
# sed -i s/\{contentfulLocale\}/$CONTENTFUL_LOCALE/g configs-templates/deploy.yml
# sed -i s/\{gitHubRepoPath\}/$GIT_REPO_PATH/g configs-templates/deploy.yml
# sed -i s/\{gitHubRepoUrl\}/$GIT_NETLIFY_URL/g configs-templates/deploy.yml

# \cp configs-templates/deploy.template.yml $PROJECT_FOLDER/configs/deploy.yml
# \cp configs-templates/settings.template.yml $PROJECT_FOLDER/configs/settings.yml

# Remove the git folder
echo -e "I'm removing the .git folder \n"
rm -rf .git

# Reconfigure git
echo -e "I'm initializing the git repository \n"
git init

# Add the new files to the new repository
echo -e "I'm adding the new files to the new repository \n"
git add .

# Commit the changes
echo -e "I'm committing the changes \n"
git commit -m "${GITHUB_FIRST_COMMIT_MESSAGE}"

# Configure the remote origin
git remote add origin $GIT_CLONE_URL

# Push on master
git push -u origin master

exit 0

# install the nodejs packages
npm install

# run the installation process
export NODE_ENV=production \
&& npm run load \
&& npm run configure \
&& npm run generate \
&& npm run build \
&& npm run deploy

echo "Your project has been successfully initialized!"
echo "Soon you website will be visible at the following url:"
echo "$WEB_SITE_URL"
