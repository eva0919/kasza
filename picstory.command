NOW=$(date +"%T-%m-%d-%Y")
git add .
git commit -m $NOW
git push heroku master