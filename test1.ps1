git init
git add .
git commit -m 'first commit for shared repo on laptop'

git branch -M main
git remote add origin https://github.com/Yanek11/konrados.git
git push -u origin main
# change laptop
git add .
git commit
git push