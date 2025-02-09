# mysece

my security environment

## start
```
$ docker run --rm -v "$PWD/project:/home/dev/project" pjongy/mysece:{version}
```

## build
```
$ docker build . -f arch/arm/Dockerfile -t pjongy/mysece:arm64
$ docker build . -f arch/amd64/Dockerfile -t pjongy/mysece:amd64
```

## help
```
$ cat ~/HELP
```
