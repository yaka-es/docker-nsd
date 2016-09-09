# docker-alpine-nginx
Dockerized minimal nsd installation based on Alpine Linux.

Do not use this build!

Basic usage:

```
$ docker run --rm -it \
	-v /mnt/docker/nsd-server/etc/nsd:/etc/nsd \
	-v /mnt/docker/nsd-server/data:/var/lib/nsd \
	yakaes/docker-nsd
```

