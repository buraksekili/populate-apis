# populate

## create.sh
Creates a specified number of APIs on the Tyk Dashboard. By default, it creates 5 APIs.

Usage:
```bash
TYK_AUTH=<AUTH_KEY> MAX=<MAX> sh create.sh
```

## delete.sh

Deletes all TykApis created on your k8s environment.

Usage: 
```bash
sh delete.sh
```

For example, let's say you have following resources on your k8s cluster.

```bash
$ kubectl get tykapis
NAME           DOMAIN   LISTENPATH   PROXY.TARGETURL       ENABLED
replace-me-0            /httpbin/    http://httpbin.org/   true
replace-me-1            /httpbin/    http://httpbin.org/   true
replace-me-2            /httpbin/    http://httpbin.org/   true
replace-me-3            /httpbin/    http://httpbin.org/   true
replace-me-4            /httpbin/    http://httpbin.org/   true
replace-me-5            /httpbin/    http://httpbin.org/   true
replace-me-6            /httpbin/    http://httpbin.org/   true
replace-me-7            /httpbin/    http://httpbin.org/   true
replace-me-8            /httpbin/    http://httpbin.org/   true
replace-me-9            /httpbin/    http://httpbin.org/   true
```

You can delete all as follows:
```
sh delete.sh
```