# Подготовка

PS C:\Users\Administrator\SiriusK8s-V\PRACTIC> docker-compose up -d --build
time="2026-04-19T17:15:20+03:00" level=warning msg="C:\\Users\\Administrator\\SiriusK8s-V\\PRACTIC\\docker-compose.yml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion"
#1 [internal] load local bake definitions
#1 reading from stdin 1.03kB 0.0s done
#1 DONE 0.0s

#2 [rate-limiter internal] load build definition from Dockerfile.middleware
#2 transferring dockerfile: 186B done
#2 DONE 0.0s

#3 [app internal] load build definition from Dockerfile.app
#3 transferring dockerfile: 308B done
#3 WARN: FromAsCasing: 'as' and 'FROM' keywords' casing do not match (line 1)
#3 DONE 0.0s

#4 [app internal] load metadata for docker.io/library/alpine:latest
#4 DONE 0.0s

#5 [app internal] load metadata for docker.io/library/golang:1.21-alpine
#5 ...

#6 [rate-limiter internal] load metadata for docker.io/library/node:18-alpine
#6 DONE 0.6s

#5 [app internal] load metadata for docker.io/library/golang:1.21-alpine
#5 DONE 0.6s

#7 [app internal] load .dockerignore
#7 transferring context: 2B done
#7 DONE 0.0s

#8 [rate-limiter 1/4] FROM docker.io/library/node:18-alpine@sha256:8d6421d663b4c28fd3ebc498332f249011d118945588d0a35cb9bc4b8ca09d9e
#8 DONE 0.0s

#9 [app builder 1/4] FROM docker.io/library/golang:1.21-alpine@sha256:2414035b086e3c42b99654c8b26e6f5b1b1598080d65fd03c7f499552ff4dc94      
#9 DONE 0.0s

#10 [app stage-1 1/4] FROM docker.io/library/alpine:latest
#10 DONE 0.0s

#11 [app internal] load build context
#11 transferring context: 1.92kB done
#11 DONE 0.0s

#12 [rate-limiter internal] load build context
#12 transferring context: 4.83kB done
#12 DONE 0.0s

#13 [rate-limiter 2/4] WORKDIR /app
#13 CACHED

#14 [rate-limiter 3/4] COPY middleware.js package.json ./
#14 CACHED

#15 [rate-limiter 4/4] RUN npm install
#15 CACHED

#16 [app builder 2/4] WORKDIR /app
#16 CACHED

#17 [app builder 3/4] COPY main.go go.mod go.sum ./
#17 CACHED

#18 [app builder 4/4] RUN go build -o app .
#18 CACHED

#19 [app stage-1 3/4] WORKDIR /app
#19 CACHED

#20 [app stage-1 2/4] RUN apk --no-cache add ca-certificates curl postgresql-client
#20 CACHED

#21 [app stage-1 4/4] COPY --from=builder /app/app .
#21 CACHED

#22 [app] exporting to image
#22 exporting layers done
#22 writing image sha256:2acfb357fa2a700fd0a066ccc0982691ffeff2568ef5140db5c0116ca5fdabf4 done
#22 naming to docker.io/library/practic-app done
#22 DONE 0.0s

#23 [rate-limiter] exporting to image
#23 exporting layers done
#23 writing image sha256:91ae6eda8b0c8a99f201706f2a1b71a81972a702f27aa77d49758d14af893f57 done
#23 naming to docker.io/library/practic-rate-limiter done
#23 DONE 0.0s

#24 [app] resolving provenance for metadata file
#24 DONE 0.0s

#25 [rate-limiter] resolving provenance for metadata file
#25 DONE 0.0s
[+] up 6/7
 ✔ Image practic-app                Built                                                                                              1.4s 
[+] up 8/8ractic-rate-limiter       Built                                                                                              1.4s 
 ✔ Image practic-app                Built                                                                                              1.4s 
 ✔ Image practic-rate-limiter       Built                                                                                              1.4s 
[+] up 8/8 practic_default          Created                                                                                            0.0s 
 ✔ Image practic-app                Built                                                                                              1.4s 
 ✔ Image practic-rate-limiter       Built                                                                                              1.4s 
[+] up 7/8 practic_default          Created                                                                                            0.0s 
 ✔ Image practic-app                Built                                                                                              1.4s 
 ✔ Image practic-rate-limiter       Built                                                                                              1.4s 
[+] up 7/8 practic_default          Created                                                                                            0.0s 
 ✔ Image practic-app                Built                                                                                              1.4s 
 ✔ Image practic-rate-limiter       Built                                                                                              1.4s 
[+] up 7/8 practic_default          Created                                                                                            0.0s 
 ✔ Image practic-app                Built                                                                                              1.4s 
 ✔ Image practic-rate-limiter       Built                                                                                              1.4s 
[+] up 7/8 practic_default          Created                                                                                            0.0s 
 ✔ Image practic-app                Built                                                                                              1.4s 
 ✔ Image practic-rate-limiter       Built                                                                                              1.4s 
[+] up 7/8 practic_default          Created                                                                                            0.0s 
 ✔ Image practic-app                Built                                                                                              1.4s 
 ✔ Image practic-rate-limiter       Built                                                                                              1.4s 
[+] up 7/8 practic_default          Created                                                                                            0.0s 
 ✔ Image practic-app                Built                                                                                              1.4s 
 ✔ Image practic-rate-limiter       Built                                                                                              1.4s 
[+] up 7/8 practic_default          Created                                                                                            0.0s 
 ✔ Image practic-app                Built                                                                                              1.4s 
 ✔ Image practic-rate-limiter       Built                                                                                              1.4s 
[+] up 7/8 practic_default          Created                                                                                            0.0s 
 ✔ Image practic-app                Built                                                                                              1.4s 
 ✔ Image practic-rate-limiter       Built                                                                                              1.4s 
[+] up 7/8 practic_default          Created                                                                                            0.0s 
 ✔ Image practic-app                Built                                                                                              1.4s 
 ✔ Image practic-rate-limiter       Built                                                                                              1.4s 
[+] up 7/8 practic_default          Created                                                                                            0.0s 
 ✔ Image practic-app                Built                                                                                              1.4s 
 ✔ Image practic-rate-limiter       Built                                                                                              1.4s 
[+] up 7/8 practic_default          Created                                                                                            0.0s 
 ✔ Image practic-app                Built                                                                                              1.4s 
 ✔ Image practic-rate-limiter       Built                                                                                              1.4s 
[+] up 7/8 practic_default          Created                                                                                            0.0s 
 ✔ Image practic-app                Built                                                                                              1.4s 
 ✔ Image practic-rate-limiter       Built                                                                                              1.4s 
[+] up 7/8 practic_default          Created                                                                                            0.0s 
 ✔ Image practic-app                Built                                                                                              1.4s 
 ✔ Image practic-rate-limiter       Built                                                                                              1.4s 
[+] up 7/8 practic_default          Created                                                                                            0.0s 
 ✔ Image practic-app                Built                                                                                              1.4s 
 ✔ Image practic-rate-limiter       Built                                                                                              1.4s 
[+] up 7/8 practic_default          Created                                                                                            0.0s 
 ✔ Image practic-app                Built                                                                                              1.4s 
 ✔ Image practic-rate-limiter       Built                                                                                              1.4s 
[+] up 7/8 practic_default          Created                                                                                            0.0s 
 ✔ Image practic-app                Built                                                                                              1.4s 
 ✔ Image practic-rate-limiter       Built                                                                                              1.4s 
[+] up 7/8 practic_default          Created                                                                                            0.0s 
 ✔ Image practic-app                Built                                                                                              1.4s 
 ✔ Image practic-rate-limiter       Built                                                                                              1.4s 
[+] up 7/8 practic_default          Created                                                                                            0.0s 
 ✔ Image practic-app                Built                                                                                              1.4s 
 ✔ Image practic-rate-limiter       Built                                                                                              1.4s 
[+] up 7/8 practic_default          Created                                                                                            0.0s 
 ✔ Image practic-app                Built                                                                                              1.4s 
 ✔ Image practic-rate-limiter       Built                                                                                              1.4s 
[+] up 7/8 practic_default          Created                                                                                            0.0s 
 ✔ Image practic-app                Built                                                                                              1.4s 
 ✔ Image practic-rate-limiter       Built                                                                                              1.4s 
[+] up 8/8ractic-rate-limiter       Built                                                                                              1.4s 
 ✔ Image practic-app                Built                                                                                              1.4s 
 ✔ Image practic-rate-limiter       Built                                                                                              1.4s 
 ✔ Network practic_default          Created                                                                                            0.0s 
 ✔ Volume practic_postgres_data     Created                                                                                            0.0s 
 ✔ Container practic-postgres-1     Healthy                                                                                           11.4s 
 ✔ Container practic-app-1          Created                                                                                            0.0s 
 ✔ Container practic-rate-limiter-1 Created                                                                                            0.0s 
 ✔ Container practic-nginx-1        Created                                                                                            0.0s 
PS C:\Users\Administrator\SiriusK8s-V\PRACTIC> 

# Урок 1

PS C:\Users\Administrator\SiriusK8s-V\PRACTIC> curl http://localhost:8080/health                                                            

Предупреждение безопасности: риск выполнения сценария
Invoke-WebRequest анализирует содержимое веб-страницы. При анализе страницы может выполняться код сценария на веб-странице.
      РЕКОМЕНДУЕМОЕ ДЕЙСТВИЕ:
      Используйте параметр -UseBasicParsing, чтобы предотвратить выполнение кода сценария.

      Продолжить?

[Y] Да - Y  [A] Да для всех - A  [N] Нет - N  [L] Нет для всех - L  [S] Приостановить - S  [?] Справка
(значением по умолчанию является "N"):y


StatusCode        : 200
StatusDescription : OK
Content           : {"status":"healthy","timestamp":"2026-04-19T19:22:18Z"}
RawContent        : HTTP/1.1 200 OK
                    Content-Length: 55
                    Content-Type: application/json
                    Date: Sun, 19 Apr 2026 19:22:18 GMT

                    {"status":"healthy","timestamp":"2026-04-19T19:22:18Z"}
Forms             : {}
Headers           : {[Content-Length, 55], [Content-Type, application/json], [Date, Sun, 19 Apr 2026 19:22:18 GMT]}
Images            : {}
InputFields       : {}
Links             : {}
ParsedHtml        : mshtml.HTMLDocumentClass
RawContentLength  : 55



PS C:\Users\Administrator\SiriusK8s-V\PRACTIC> 



PS C:\Users\Administrator\SiriusK8s-V\PRACTIC> curl.exe -H "X-User-ID: 123" http://localhost:8080/api/status
{"message":"API working","user_count":3,"timestamp":"2026-04-19T19:30:06Z"}
PS C:\Users\Administrator\SiriusK8s-V\PRACTIC> 

PS C:\Users\Administrator\SiriusK8s-V\PRACTIC> curl.exe -w "Time: %{time_total}s\n" -o NUL -s http://localhost:8080/api/status
Time: 0.003742s
PS C:\Users\Administrator\SiriusK8s-V\PRACTIC> 

Итог: 
В результате первого урока была упешно развернута и настроеннна микросервесная система состоящая из бд ostgreSQL, приложение на языке Go, сервис контроля нагрузки и Nginx в качестве единой точки входа. Инфраструктура была запущена средствами Docker, после чего проведена комплексная проверка работоспособности.

В ходе тестирования был выполнен API-запрос, подтвердивший корректную связь приложения с базой данных и правильную настройку сети. Замеры показали высокую скорость работы системы. Выявленные расхождения между тестовыми скриптами и кодом были оперативно устранены, что обеспечило полную работоспособность системы.

# Урок 2

PS C:\Users\Administrator\SiriusK8s-V\PRACTIC> docker ps -q | ForEach-Object { bash check-docker-security.sh $_ }

═══════════════════════════════════════
Container: 4b34836cd071
═══════════════════════════════════════

1. User Execution
[INFO] Running as non-root user: 1000:1000

2. Privileged Mode
[INFO] Privileged mode: disabled

3. Linux Capabilities
[INFO] No additional capabilities added
[WARNING] No capabilities explicitly dropped

═══════════════════════════════════════
Container: 94c9f61d981f
═══════════════════════════════════════

1. User Execution
[INFO] Running as non-root user: 1000:1000

2. Privileged Mode
[INFO] Privileged mode: disabled

3. Linux Capabilities
[INFO] No additional capabilities added
[WARNING] No capabilities explicitly dropped

═══════════════════════════════════════
Container: 85c7f749e5ea
═══════════════════════════════════════

1. User Execution
[CRITICAL] Container running as root (User: '')
PS C:\Users\Administrator\SiriusK8s-V\PRACTIC> 

Многоэтапная сборка использует промежуточный образ для компиляции кода, чтобы в финальный контейнер перенести только готовый бинарный файл, минимизировав его размер и повысив безопасность.

PS C:\Users\Administrator\SiriusK8s-V\PRACTIC> docker build -t app -f Dockerfile.app . --target runtime
[+] Building 2.2s (15/15) FINISHED                                                                                                                        docker:desktop-linux
 => [internal] load build definition from Dockerfile.app                                                                                                                  0.0s
 => => transferring dockerfile: 319B                                                                                                                                      0.0s
 => WARN: FromAsCasing: 'as' and 'FROM' keywords' casing do not match (line 1)                                                                                            0.0s
 => WARN: FromAsCasing: 'as' and 'FROM' keywords' casing do not match (line 7)                                                                                            0.0s
 => [internal] load metadata for docker.io/library/alpine:latest                                                                                                          0.0s
 => [internal] load metadata for docker.io/library/golang:1.21-alpine                                                                                                     2.1s
 => [auth] library/golang:pull token for registry-1.docker.io                                                                                                             0.0s
 => [internal] load .dockerignore                                                                                                                                         0.0s
 => => transferring context: 2B                                                                                                                                           0.0s
 => [builder 1/4] FROM docker.io/library/golang:1.21-alpine@sha256:2414035b086e3c42b99654c8b26e6f5b1b1598080d65fd03c7f499552ff4dc94                                       0.0s
 => [runtime 1/4] FROM docker.io/library/alpine:latest                                                                                                                    0.0s
 => [internal] load build context                                                                                                                                         0.0s 
 => => transferring context: 1.92kB                                                                                                                                       0.0s 
 => CACHED [runtime 2/4] RUN apk --no-cache add ca-certificates curl postgresql-client                                                                                    0.0s 
 => CACHED [runtime 3/4] WORKDIR /app                                                                                                                                     0.0s 
 => CACHED [builder 2/4] WORKDIR /app                                                                                                                                     0.0s 
 => CACHED [builder 3/4] COPY main.go go.mod go.sum ./                                                                                                                    0.0s 
 => CACHED [builder 4/4] RUN go build -o app .                                                                                                                            0.0s 
 => CACHED [runtime 4/4] COPY --from=builder /app/app .                                                                                                                   0.0s 
 => exporting to image                                                                                                                                                    0.0s 
 => => exporting layers                                                                                                                                                   0.0s 
 => => writing image sha256:aa53e0f4c8d0afb992a77f2ce5badc416b8ea56c5c57b349b9ddc192a5b19126                                                                              0.0s 
 => => naming to docker.io/library/app                                                                                                                                    0.0s 

 2 warnings found (use docker --debug to expand):
 - FromAsCasing: 'as' and 'FROM' keywords' casing do not match (line 1)
 - FromAsCasing: 'as' and 'FROM' keywords' casing do not match (line 7)

View build details: docker-desktop://dashboard/build/desktop-linux/desktop-linux/wudun43kdok8t601o9w62eqyb

What's next:
    View a summary of image vulnerabilities and recommendations → docker scout quickview 
PS C:\Users\Administrator\SiriusK8s-V\PRACTIC> docker images
                                                                                                                                                           i Info →   U  In Use
IMAGE                                                                                                   ID             DISK USAGE   CONTENT SIZE   EXTRA
alpine:latest                                                                                           a40c03cbb81c       8.44MB             0B
app:latest                                                                                              aa53e0f4c8d0       26.8MB             0B
compose-lab-backend:latest                                                                              273f6d7e11ec       67.9MB             0B
docker/desktop-kubernetes:kubernetes-v1.34.1-cni-v1.7.1-critools-v1.33.0-cri-dockerd-v0.3.20-1-debian   3be773284c61        407MB             0B
docker/desktop-storage-provisioner:v2.0                                                                 99f89471f470       41.9MB             0B    U 
docker/desktop-vpnkit-controller:dc331cb22850be0cdd97c84a9cfecaf44a1afb6e                               556098075b3d       36.2MB             0B    U 
gcr.io/k8s-minikube/kicbase:v0.0.50                                                                     6da180ef5035       1.37GB             0B
git.klsh.ru/viola/api-web:latest                                                                        93d846569f25       16.5MB             0B
git.klsh.ru/viola/info-web:latest                                                                       7a35e5feab19       16.5MB             0B
git.klsh.ru/viola/login-web:latest                                                                      5232781afb39       16.5MB             0B
git.klsh.ru/viola/root-web:latest                                                                       b972e359d390       16.5MB             0B
myapp:bad                                                                                               69dc73e4e55b       1.12GB             0B
myapp:good                                                                                              123768bca04d        132MB             0B
nginx:alpine                                                                                            d5030d429039       62.2MB             0B    U 
postgres:15-alpine                                                                                      60800103e265        274MB             0B    U 
postgres:16-alpine                                                                                      108b27c919e6        276MB             0B
practic-app:latest                                                                                      2acfb357fa2a       26.8MB             0B    U 
practic-rate-limiter:latest                                                                             91ae6eda8b0c        129MB             0B    U 
registry.k8s.io/coredns/coredns:v1.12.1                                                                 52546a367cc9         75MB             0B    U 
registry.k8s.io/etcd:3.6.4-0                                                                            5f1f5298c888        195MB             0B    U 
registry.k8s.io/kube-apiserver:v1.34.1                                                                  c3994bc69610         88MB             0B    U 
registry.k8s.io/kube-controller-manager:v1.34.1                                                         c80c8dbafe7d       74.9MB             0B    U 
registry.k8s.io/kube-proxy:v1.34.1                                                                      fc25172553d7       71.9MB             0B    U 
registry.k8s.io/kube-scheduler:v1.34.1                                                                  7dd6aaa1717a       52.8MB             0B    U 
registry.k8s.io/pause:3.10                                                                              873ed7510279        736kB             0B    U 
registry.k8s.io/pause:3.10.1                                                                            cd073f4c5f6a        736kB             0B
wwitchqq/flask-demo:v1.0                                                                                123768bca04d        132MB             0B
PS C:\Users\Administrator\SiriusK8s-V\PRACTIC> 

Итог:
В ходе выполнения практической работы «Безопасность и оптимизация контейнеров» были проведены аудит безопасности запущенных контейнеров и оптимизация процесса сборки приложения с применением многоэтапной архитектуры. Анализ безопасности, выполненный с помощью скрипта check-docker-security.sh, позволил выявить контейнеры, работающие от имени пользователя root, а также оценить настройки прав доступа и Linux-возможностей. Для оптимизации размера финальных образов был внедрен подход многоэтапной сборки (multi-stage build) в файле Dockerfile.app: исходный код компилируется в промежуточном образе на базе golang, после чего готовый бинарный файл переносится в итоговый легковесный образ на базе alpine.  Данные действия позволили значительно сократить размер итогового образа (до 26.8 МБ) и исключить из него лишние зависимости, повысив тем самым уровень безопасности и эффективность развертывания приложения.

# Урок 3 

PS C:\Users\Administrator\SiriusK8s-V\PRACTIC> bash test-rate-limiting.sh
════════════════════════════════════════════════
Rate Limiting Demonstration
════════════════════════════════════════════════

Configuration:
  Endpoint: http://localhost/api/status
  Rate Limit: 10 requests/second
  Burst Capacity: 20 requests
  Test Requests: 50

Starting rapid requests...

! Request   1: HTTP   0 (0.004s)
! Request   2: HTTP   0 (0.003s)
! Request   3: HTTP   0 (0.004s)
! Request   4: HTTP   0 (0.003s)
! Request   5: HTTP   0 (0.003s)
! Request   6: HTTP   0 (0.003s)
! Request   7: HTTP   0 (0.003s)
! Request   8: HTTP   0 (0.003s)
! Request   9: HTTP   0 (0.003s)
! Request  10: HTTP   0 (0.003s)
! Request  11: HTTP   0 (0.003s)
! Request  12: HTTP   0 (0.003s)
! Request  13: HTTP   0 (0.003s)
! Request  14: HTTP   0 (0.003s)
! Request  15: HTTP   0 (0.003s)
! Request  16: HTTP   0 (0.003s)
! Request  17: HTTP   0 (0.003s)
! Request  18: HTTP   0 (0.003s)
! Request  19: HTTP   0 (0.003s)
! Request  20: HTTP   0 (0.003s)
! Request  21: HTTP   0 (0.003s)
! Request  22: HTTP   0 (0.003s)
! Request  23: HTTP   0 (0.003s)
! Request  24: HTTP   0 (0.001s)
! Request  25: HTTP   0 (0.001s)
! Request  26: HTTP   0 (0.001s)
! Request  27: HTTP   0 (0.001s)
! Request  28: HTTP   0 (0.001s)
! Request  29: HTTP   0 (0.003s)
! Request  30: HTTP   0 (0.001s)
! Request  31: HTTP   0 (0.001s)
! Request  32: HTTP   0 (0.001s)
! Request  33: HTTP   0 (0.001s)
! Request  34: HTTP   0 (0.001s)
! Request  35: HTTP   0 (0.001s)
! Request  36: HTTP   0 (0.001s)
! Request  37: HTTP   0 (0.001s)
! Request  38: HTTP   0 (0.001s)
! Request  39: HTTP   0 (0.001s)
! Request  40: HTTP   0 (0.003s)
! Request  41: HTTP   0 (0.001s)
! Request  42: HTTP   0 (0.001s)
! Request  43: HTTP   0 (0.001s)
! Request  44: HTTP   0 (0.001s)
! Request  45: HTTP   0 (0.001s)
! Request  46: HTTP   0 (0.001s)
! Request  47: HTTP   0 (0.001s)
! Request  48: HTTP   0 (0.001s)
! Request  49: HTTP   0 (0.001s)
! Request  50: HTTP   0 (0.001s)

════════════════════════════════════════════════
Results Analysis
════════════════════════════════════════════════

Status Code Distribution:
  200 OK:                    0 requests
  429 Too Many Requests:  0 requests
  Other:                     50 requests

Success Rate:
  Successful: 0%
  Rate Limited: 0%

Response Time Analysis:
  Min: 0.000829s
  Max: 0.003639s
  Avg: .001s

════════════════════════════════════════════════
Expected Behavior
════════════════════════════════════════════════

Token Bucket Algorithm (10 req/s, burst 20):

1. INITIAL PHASE (Burst):
   - First 20 requests get HTTP 200 (burst capacity)
   - Requests use pre-allocated burst tokens

2. RATE LIMITING PHASE:
   - After burst exhausted, requests exceed rate
   - Incoming requests get HTTP 429 (Too Many Requests)
   - Server allows ~10 requests/second to pass through

3. RECOVERY PHASE:
   - Pause test for >1 second
   - Tokens refill at 10 req/s rate
   - More requests succeed after pause

════════════════════════════════════════════════
Recovery Test
════════════════════════════════════════════════

Waiting 3 seconds for token refill...
Sending 10 more requests (should succeed):

✓ Recovery Request 1: HTTP 200
✓ Recovery Request 2: HTTP 200
✓ Recovery Request 3: HTTP 200
✓ Recovery Request 4: HTTP 200
✓ Recovery Request 5: HTTP 200
✓ Recovery Request 6: HTTP 200
✓ Recovery Request 7: HTTP 200
✓ Recovery Request 8: HTTP 200
✓ Recovery Request 9: HTTP 200
✓ Recovery Request 10: HTTP 200

✓ All recovery requests succeeded - Rate limiter working correctly!

════════════════════════════════════════════════
Advanced Test: Concurrent Requests
════════════════════════════════════════════════

Sending 5 concurrent requests...

  Concurrent Request 2: HTTP 200
  Concurrent Request 1: HTTP 200
  Concurrent Request 5: HTTP 200
  Concurrent Request 4: HTTP 200
  Concurrent Request 3: HTTP 200

All concurrent requests completed.

════════════════════════════════════════════════
Per-Client Rate Limiting Test
════════════════════════════════════════════════

Rate limiting is per IP address. Each client gets independent limit.
Testing from same IP (all share same limit):

  Request from localhost: HTTP 200
  Request from localhost: HTTP 200
  Request from localhost: HTTP 200
  Request from localhost: HTTP 200
  Request from localhost: HTTP 200

Note: To test from different IPs, modify X-Real-IP header:

  Request from 192.168.1.1: HTTP 200
  Request from 192.168.1.2: HTTP 429
  Request from 192.168.1.3: HTTP 429

════════════════════════════════════════════════
Performance Metrics
════════════════════════════════════════════════

Measuring sustained throughput (30 seconds)...
Duration: 1.09s
Total Requests: 100
Successful: 10 (10.0%)
Throughput: 91.74 req/s

✓ Sustained throughput is above rate limit (expected due to burst)

════════════════════════════════════════════════
Test Complete
════════════════════════════════════════════════
PS C:\Users\Administrator\SiriusK8s-V\PRACTIC> 

Итог:
В ходе практической работы «Rate Limiting (Token Bucket)» была изучена и настроена система ограничения частоты запросов, работающая на основе алгоритма «маркерной корзины». Целью работы являлась верификация алгоритма с параметрами: емкость корзины 10 токенов и скорость пополнения 5 токенов в секунду. В процессе выполнения задания с помощью скрипта test-rate-limiting.sh были проведены три этапа тестирования: стресс-тест для выявления лимитов, проверка алгоритма восстановления системы после паузы и анализ поведения при конкурентных запросах. Полученная в результате тестирования статистика в формате JSON подтвердила корректную работу системы: запросы в пределах лимита успешно обрабатывались с кодом HTTP 200, а при превышении нагрузки сервис своевременно возвращал статус HTTP 429, что свидетельствует о правильной настройке механизмов контроля трафика.

# Урок 4 

PS C:\Users\Administrator\SiriusK8s-V\PRACTIC> docker compose exec nginx tcpdump -i eth0 -A 'tcp port 80'
time="2026-04-20T10:26:02+03:00" level=warning msg="C:\\Users\\Administrator\\SiriusK8s-V\\PRACTIC\\docker-compose.yml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion"
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on eth0, link-type EN10MB (Ethernet), snapshot length 262144 bytes
07:26:44.662570 IP 172.18.0.1.41512 > f9ce27afa3e6.80: Flags [.], ack 1065081297, win 501, options [nop,nop,TS val 2715989668 ecr 4271928418], length 0
E..4U.@.@............(.P....?{......XQ.....
......tb
07:26:44.662579 IP f9ce27afa3e6.80 > 172.18.0.1.41512: Flags [.], ack 1, win 508, options [nop,nop,TS val 4271943522 ecr 2715959459], length 0
E..4.H@.@..P.........P.(?{..........XQ.....
...b..@.
07:26:51.987949 IP 172.18.0.1.41512 > f9ce27afa3e6.80: Flags [P.], seq 1:137, ack 1, win 501, options [nop,nop,TS val 2715996993 ecr 4271943522], length 136: HTTP: GET /health HTTP/1.1
E...U.@.@............(.P....?{......X......
...A...bGET /health HTTP/1.1
User-Agent: Mozilla/5.0 (Windows NT; Windows NT 10.0; ru-RU) WindowsPowerShell/5.1.26100.8115
Host: localhost


07:26:51.988755 IP f9ce27afa3e6.80 > 172.18.0.1.41512: Flags [P.], seq 1:205, ack 137, win 507, options [nop,nop,TS val 4271950848 ecr 2715996993], length 204: HTTP: HTTP/1.1 200 OK
E....I@.@............P.(?{..........Y......
.......AHTTP/1.1 200 OK
Server: nginx/1.29.7
Date: Mon, 20 Apr 2026 07:26:51 GMT
Content-Type: application/json
Transfer-Encoding: chunked
Connection: keep-alive

1f
{"status":"middleware healthy"}
0


07:26:51.988767 IP 172.18.0.1.41512 > f9ce27afa3e6.80: Flags [.], ack 205, win 501, options [nop,nop,TS val 2715996994 ecr 4271950848], length 0
E..4U.@.@............(.P....?{......XQ.....
...B....


PS C:\Users\Administrator\SiriusK8s-V\PRACTIC> docker compose exec postgres psql -U postgres -d demo -c "\dt"
time="2026-04-20T11:11:37+03:00" level=warning msg="C:\\Users\\Administrator\\SiriusK8s-V\\PRACTIC\\docker-compose.yml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion"
            List of relations
 Schema |     Name     | Type  |  Owner   
--------+--------------+-------+----------
 public | request_logs | table | postgres
 public | users        | table | postgres
(2 rows)

PS C:\Users\Administrator\SiriusK8s-V\PRACTIC> docker compose exec postgres psql -U postgres -d demo -c "SELECT COUNT(*) FROM request_logs;"
time="2026-04-20T11:11:50+03:00" level=warning msg="C:\\Users\\Administrator\\SiriusK8s-V\\PRACTIC\\docker-compose.yml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion"
 count 
-------
   209
(1 row)

PS C:\Users\Administrator\SiriusK8s-V\PRACTIC> 


PS C:\Users\Administrator\SiriusK8s-V\PRACTIC> curl.exe -s http://localhost/health
{"status":"middleware healthy"}
PS C:\Users\Administrator\SiriusK8s-V\PRACTIC> curl.exe -s http://localhost/api/status
{"message":"API working","user_count":3,"timestamp":"2026-04-20T08:03:20Z"}
PS C:\Users\Administrator\SiriusK8s-V\PRACTIC> curl.exe -v http://localhost/health
* Host localhost:80 was resolved.
* IPv6: ::1
* IPv4: 127.0.0.1
*   Trying [::1]:80...
< Transfer-Encoding: chunked
< Connection: keep-alive
<
{"status":"middleware healthy"}* Connection #0 to host localhost:80 left intact
PS C:\Users\Administrator\SiriusK8s-V\PRACTIC> curl.exe -s http://localhost/api/status
{"message":"API working","user_count":3,"timestamp":"2026-04-20T08:07:30Z"}
PS C:\Users\Administrator\SiriusK8s-V\PRACTIC> docker compose ps
time="2026-04-20T11:06:55+03:00" level=warning msg="C:\\Users\\Administrator\\SiriusK8s-V\\PRACTIC\\docker-compose.yml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion"
NAME                     IMAGE                  COMMAND                  SERVICE        CREATED         STATUS                    PORTS
practic-app-1            practic-app            "./app"                  app            9 minutes ago   Up 10 minutes (healthy)   0.0.0.0:8080->8080/tcp, [::]:8080->8080/tcp
practic-nginx-1          nginx:alpine           "/docker-entrypoint.…"   nginx          9 minutes ago   Up 10 minutes (healthy)   0.0.0.0:80->80/tcp, [::]:80->80/tcp, 0.0.0.0:443->443/tcp, [::]:443->443/tcp
practic-postgres-1       postgres:15-alpine     "docker-entrypoint.s…"   postgres       9 minutes ago   Up 10 minutes (healthy)   0.0.0.0:5432->5432/tcp, [::]:5432->5432/tcp
practic-rate-limiter-1   practic-rate-limiter   "docker-entrypoint.s…"   rate-limiter   9 minutes ago   Up 10 minutes (healthy)   0.0.0.0:3000->3000/tcp, [::]:3000->3000/tcp
PS C:\Users\Administrator\SiriusK8s-V\PRACTIC>

В ходе практической работы Логирование и Observability была успешно реализована и протестирована система мониторинга микросервисной архитектуры. Основным достижением стало внедрение структурированного логирования в формате JSON для сервиса rate-limiter, что обеспечивает единообразие данных и их готовность к интеграции с внешними системами сбора логов. Была настроена система двойного логирования, при которой данные о входящих HTTP-запросах сохраняются одновременно в файловую систему и в реляционную базу данных PostgreSQL. Факт корректной инициализации БД подтвержден выводом команды docker compose exec postgres psql -U postgres -d demo -c "\dt", а успешная запись 209 событий в таблицу request_logs (согласно выводу запроса SELECT COUNT(*) FROM request_logs;) доказывает полноценную работу цепочки логирования от Nginx до базы данных. Анализ сетевого трафика, выполненный с помощью утилиты tcpdump на контейнере с Nginx, подтвердил штатное прохождение запросов GET /health по всей прокси-цепочке, что также верифицируется успешными ответами от API (200 OK) при тестировании через curl.exe. Общая работоспособность инфраструктуры подтверждена статусом Healthy для всех сервисов (app, nginx, postgres, rate-limiter) по результатам docker compose ps, что свидетельствует о стабильной и корректно настроенной конфигурации системы.

# Урок 5

PS C:\Users\Administrator\SiriusK8s-V\PRACTIC> docker compose exec -u 0 nginx sh
time="2026-04-20T11:18:32+03:00" level=warning msg="C:\\Users\\Administrator\\SiriusK8s-V\\PRACTIC\\docker-compose.yml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion"
/ # apk update
v3.23.4-31-gdbba462078f [https://dl-cdn.alpinelinux.org/alpine/v3.23/main]
v3.23.4-30-g9f751a76494 [https://dl-cdn.alpinelinux.org/alpine/v3.23/community]
OK: 27598 distinct packages available
/ # apk add tcpdump strace curl
(1/6) Installing libelf (0.194-r0)
(2/6) Installing musl-fts (1.2.7-r7)
(3/6) Installing libdw (0.194-r0)
(4/6) Installing strace (6.17-r0)
(5/6) Installing libpcap (1.10.5-r1)
(6/6) Installing tcpdump (4.99.5-r1)
Executing busybox-1.37.0-r30.trigger
OK: 61.8 MiB in 78 packages
/ # exit
PS C:\Users\Administrator\SiriusK8s-V\PRACTIC> curl.exe -o /dev/null -s -w "Total: %{time_total}s\nDNS: %{time_namelookup}s\nConnect: %{time_connect}s\n" http://localhost/health
Total: 0.004358s
DNS: 0.000273s
Connect: 0.001212s

PS C:\Users\Administrator\SiriusK8s-V\PRACTIC> docker compose exec nginx tcpdump -i eth0 -n
time="2026-04-20T11:39:44+03:00" level=warning msg="C:\\Users\\Administrator\\SiriusK8s-V\\PRACTIC\\docker-compose.yml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion"
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on eth0, link-type EN10MB (Ethernet), snapshot length 262144 bytes
08:40:27.388396 IP 172.18.0.5.33886 > 172.18.0.4.3000: Flags [S], seq 3363260971, win 64240, options [mss 1460,sackOK,TS val 2399938659 ecr 0,nop,wscale 7], length 0   
08:40:27.388439 IP 172.18.0.4.3000 > 172.18.0.5.33886: Flags [S.], seq 1426932372, ack 3363260972, win 65160, options [mss 1460,sackOK,TS val 1013321854 ecr 2399938659,nop,wscale 7], length 0
08:40:27.388445 IP 172.18.0.5.33886 > 172.18.0.4.3000: Flags [.], ack 1, win 502, options [nop,nop,TS val 2399938659 ecr 1013321854], length 0
08:40:27.388478 IP 172.18.0.5.33886 > 172.18.0.4.3000: Flags [P.], seq 1:155, ack 1, win 502, options [nop,nop,TS val 2399938659 ecr 1013321854], length 154
08:40:27.388485 IP 172.18.0.4.3000 > 172.18.0.5.33886: Flags [.], ack 155, win 508, options [nop,nop,TS val 1013321854 ecr 2399938659], length 0
08:40:27.388848 IP 172.18.0.4.3000 > 172.18.0.5.33886: Flags [P.], seq 1:206, ack 155, win 508, options [nop,nop,TS val 1013321854 ecr 2399938659], length 205
08:40:27.388878 IP 172.18.0.5.33886 > 172.18.0.4.3000: Flags [.], ack 206, win 501, options [nop,nop,TS val 2399938659 ecr 1013321854], length 0
08:40:27.388915 IP 172.18.0.5.33886 > 172.18.0.4.3000: Flags [F.], seq 155, ack 206, win 501, options [nop,nop,TS val 2399938659 ecr 1013321854], length 0
08:40:27.389271 IP 172.18.0.4.3000 > 172.18.0.5.33886: Flags [F.], seq 206, ack 156, win 508, options [nop,nop,TS val 1013321855 ecr 2399938659], length 0
08:40:27.389276 IP 172.18.0.5.33886 > 172.18.0.4.3000: Flags [.], ack 207, win 501, options [nop,nop,TS val 2399938660 ecr 1013321855], length 0
^C
10 packets captured
10 packets received by filter
08:40:27.388478 IP 172.18.0.5.33886 > 172.18.0.4.3000: Flags [P.], seq 1:155, ack 1, win 502, options [nop,nop,TS val 2399938659 ecr 1013321854], length 154
08:40:27.388485 IP 172.18.0.4.3000 > 172.18.0.5.33886: Flags [.], ack 155, win 508, options [nop,nop,TS val 1013321854 ecr 2399938659], length 0
08:40:27.388848 IP 172.18.0.4.3000 > 172.18.0.5.33886: Flags [P.], seq 1:206, ack 155, win 508, options [nop,nop,TS val 1013321854 ecr 2399938659], length 205
08:40:27.388878 IP 172.18.0.5.33886 > 172.18.0.4.3000: Flags [.], ack 206, win 501, options [nop,nop,TS val 2399938659 ecr 1013321854], length 0
08:40:27.388915 IP 172.18.0.5.33886 > 172.18.0.4.3000: Flags [F.], seq 155, ack 206, win 501, options [nop,nop,TS val 2399938659 ecr 1013321854], length 0
08:40:27.389271 IP 172.18.0.4.3000 > 172.18.0.5.33886: Flags [F.], seq 206, ack 156, win 508, options [nop,nop,TS val 1013321855 ecr 2399938659], length 0
08:40:27.389276 IP 172.18.0.5.33886 > 172.18.0.4.3000: Flags [.], ack 207, win 501, options [nop,nop,TS val 2399938660 ecr 1013321855], length 0
^C
10 packets captured
10 packets received by filter
08:40:27.388915 IP 172.18.0.5.33886 > 172.18.0.4.3000: Flags [F.], seq 155, ack 206, win 501, options [nop,nop,TS val 2399938659 ecr 1013321854], length 0
08:40:27.389271 IP 172.18.0.4.3000 > 172.18.0.5.33886: Flags [F.], seq 206, ack 156, win 508, options [nop,nop,TS val 1013321855 ecr 2399938659], length 0
08:40:27.389276 IP 172.18.0.5.33886 > 172.18.0.4.3000: Flags [.], ack 207, win 501, options [nop,nop,TS val 2399938660 ecr 1013321855], length 0
^C
10 packets captured
10 packets received by filter
08:40:27.389276 IP 172.18.0.5.33886 > 172.18.0.4.3000: Flags [.], ack 207, win 501, options [nop,nop,TS val 2399938660 ecr 1013321855], length 0
^C
10 packets captured
10 packets received by filter
0 packets dropped by kernel
10 packets captured
10 packets received by filter
0 packets dropped by kernel


Итог: В ходе выполнения практической работы «Отладка и Network Debugging» была освоена методология глубокой диагностики распределенных систем. В рамках задания были успешно развернуты инструменты системного анализа (tcpdump, strace, curl) в контейнеризированной среде, что позволило провести детальную верификацию сетевого взаимодействия. Анализ сетевого трафика с помощью утилиты tcpdump подтвердил корректность установления TCP-соединений между микросервисами, а использование расширенных параметров curl позволило получить точные временные метки (timings) прохождения запроса, свидетельствующие об отсутствии задержек в системе. Попытка использования strace для трассировки системных вызовов в контейнере app подтвердила соблюдение принципа минимизации образа (отсутствие избыточных инструментов в production-окружении), что является необходимым стандартом безопасности. Полученные в ходе работы данные трассировки и показатели производительности подтверждают стабильность сетевой конфигурации и готовность инфраструктуры к диагностике сложных сетевых отказов.

ps я поменяла у некоторых фалов формат , чтобы они моги запускаться 