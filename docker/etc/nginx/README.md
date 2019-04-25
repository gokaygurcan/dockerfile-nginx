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

<h2>conf.d/</h2>

- gzip.conf
- open_file.conf
- resolver.conf
- security_headers.conf
- ssl.conf
- stub_status.conf

<h2>conf.optional.d/</h2>

- brotli.conf
- fancyindex.conf
- mail.conf
- more_headers.conf
- pagespeed.conf
- sysguard.conf

<h2>sites-enabled/</h2>

- localhost/
  - default.conf
- com.example/
  - default.conf
  - subdomain1.conf
  - subdomain2.conf
- net.example/
  - default.conf
