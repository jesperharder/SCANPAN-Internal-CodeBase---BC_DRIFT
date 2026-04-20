# BC25 Instance Port Overview

Generated: 2026-04-17

## Instance Ports

| Instance | Auth | Dev | Client | SOAP | OData | Management | Status |
|---|---|---:|---:|---:|---:|---:|---|
| `BC250` | `Windows` | `7049` | `7085` | `7047` | `7048` | `7045` | Running |
| `BC25UserPassword` | `NavUserPassword` | `7146` | `7147` | `7148` | `7149` | `7150` | Ports corrected; service status must be revalidated after restart |
| `BC25Test` | `Windows` | `7246` | `7247` | `7248` | `7249` | `7250` | Running |
| `BC25TestUserPwd` | `NavUserPassword` | `7346` | `7347` | `7348` | `7349` | `7350` | Running |

Port pattern:
- `x46` = `DeveloperServicesPort`
- `x47` = `ClientServicesPort`
- `x48` = `SOAPServicesPort`
- `x49` = `ODataServicesPort`
- `x50` = `ManagementServicesPort`

## Business Central URLs

Validated web access:
- `BC25Test`: `http://srvbcapp2:8080/BC25Test/?company=SCANPAN%20Danmark&dc=0`

Validated service URL from earlier test:
- `BC25TestUserPwd` SOAP/WS: `http://srvbcapp2:7348/BC25TestUserPwd/WS/`

Inferred web URLs from instance names and the shared web-server pattern:
- `BC250`: `http://srvbcapp2:8080/BC250/?company=SCANPAN%20Danmark&dc=0`
- `BC25UserPassword`: `http://srvbcapp2:8080/BC25UserPassword/?company=SCANPAN%20Danmark&dc=0`
- `BC25TestUserPwd`: `http://srvbcapp2:8080/BC25TestUserPwd/?company=SCANPAN%20Danmark&dc=0`

Inferred SOAP/WS URLs from the validated port pattern:
- `BC250`: `http://srvbcapp2:7047/BC250/WS/`
- `BC25UserPassword`: `http://srvbcapp2:7148/BC25UserPassword/WS/`
- `BC25Test`: `http://srvbcapp2:7248/BC25Test/WS/`
- `BC25TestUserPwd`: `http://srvbcapp2:7348/BC25TestUserPwd/WS/`

Notes:
- `BC25Test` returned `PublicWebBaseUrl = http://SRVBCAPP2:8080/BC25Test/WebClient/`.
- `BC25TestUserPwd` also returned `PublicWebBaseUrl = http://SRVBCAPP2:8080/BC25Test/WebClient/`, which looks inconsistent with the instance name. Treat the inferred `BC25TestUserPwd` web URL as unvalidated until it is opened successfully.
- The original port conflict was that both `BC250` and `BC25UserPassword` were configured with `DeveloperServicesPort = 7049`. `BC25UserPassword` was corrected to `7146`.
