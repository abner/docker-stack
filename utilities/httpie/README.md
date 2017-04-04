HTTPIE

Docker Container with amazing http utility [httpie](https://httpie.org/doc#usage).

USAGE:

Add a alias `http`:

```bash
alias http="docker run --rm --tty abner/httpie" && \
alias http >> ~/.bashrc
```

Now you can make a http request:

```bash
http GET https://newton.now.sh/factor/x^2-1
```



