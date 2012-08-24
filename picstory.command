NOW=$(date +"%m-%d-%Y")
git add .
git commit -m $NOW
git push heroku master