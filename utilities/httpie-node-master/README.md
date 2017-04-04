# NodeJS + Httpie

## Usage

### Node

**Eval javascript code**

```bash
docker run --rm abner/httpie-node "node -e 'console.log(Math.random())'"
```

Will print a random number to the console.


**Use Node REPL (Interactive console)**

```bash
docker run --rm abner/httpie-node
```

### Httpie

**Make a http request**

```bash
docker run --rm --tty abner/httpie-node "http -v GET https://newton.now.sh/factor/x^2-1"
```

Will output something like:

```http
GET /factor/x%5E2-1 HTTP/1.1
Accept: */*
Accept-Encoding: gzip, deflate
Connection: keep-alive
Host: newton.now.sh
User-Agent: HTTPie/0.9.9



HTTP/1.1 200 OK
Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Encoding: gzip
Content-Type: application/json; charset=utf-8
Date: Sun, 02 Apr 2017 10:15:58 GMT
ETag: W/"46-VGup5StMSXh6YmdQzF3LLw"
Server: now
Strict-Transport-Security: max-age=31536000; includeSubDomains;
Transfer-Encoding: chunked
X-Powered-By: Express

{
    "expression": "x^2-1",
    "operation": "factor",
    "result": "(x - 1) (x + 1)"
}

To add an alias to your bash profile:

echo "httpie=\"docker run --rm --tty abner/httpie-node \"http $@\"\"" >> .profile