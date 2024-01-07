# NGINX Folder Structure

| Path                               | Description                              |
| :--------------------------------- | :--------------------------------------- |
| /etc/nginx/conf.d/\*.conf          | Necessary configuration files            |
| /etc/nginx/conf.optional.d/\*.conf | Extra and re-usable configuration files  |
| /etc/nginx/html/index.html         | Generic HTML to serve by default         |
| /etc/nginx/htpasswd                | Basic authentication (username:password) |
| /etc/nginx/koi-utf                 | Character set                            |
| /etc/nginx/koi-win                 | Character set                            |
| /etc/nginx/mime.types              | MIME types                               |
| /etc/nginx/nginx.conf              | Main configuration file                  |
| /etc/nginx/sites-enabled/\*\*/*    | Virtual host configuration files         |
| /etc/nginx/win-utf                 | Character set                            |

---

## conf.d/

- gzip.conf
- open_file.conf
- resolver.conf
- security_headers.conf
- ssl.conf
- stub_status.conf

## conf.optional.d/

- brotli.conf
- fancyindex.conf
- mail.conf
- more_headers.conf
- sysguard.conf

## sites-enabled/

- localhost/
  - default.conf
- com.example/
  - default.conf
  - subdomain1.conf
  - subdomain2.conf
- net.example/
  - default.conf
