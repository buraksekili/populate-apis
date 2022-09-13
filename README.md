# populate

## create.sh
Creates a specified number of APIs and SecurityPolicies on the Tyk Dashboard. By default, it creates 5 APIs.

Usage:
```bash
TYK_AUTH=<AUTH_KEY> MAX=<MAX> ./create.sh
```

## clean.sh

Deletes all TykApis and SecurityPolicies created on your Dashboard.

Usage: 
```bash
TYK_AUTH=<AUTH_KEY> ./clean.sh
```

## k8s-clean.sh

Deletes all TykApis and SecurityPolicies created on your k8s environment.

Usage: 
```bash
./k8s-clean.sh
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
./k8s-clean.sh
```
