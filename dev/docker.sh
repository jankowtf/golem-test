docker build -t golem-test .

docker run -d --rm --name golem-test -e PORT=5000 -p 5001:5000 golem-test

open http://localhost:5001
