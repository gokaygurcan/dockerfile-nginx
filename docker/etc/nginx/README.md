# NGINX File Structure

| Path                               | Description                             |
| :--------------------------------- | :-------------------------------------- |
| /etc/nginx/conf.d/\*.conf          | Necessary configuration files           |
| /etc/nginx/conf.optional.d/\*.conf | Extra and re-usable configuration files |
| /etc/nginx/koi-utf                 | Character set                           |
| /etc/nginx/koi-win                 | Character set                           |
| /etc/nginx/mime.types              | MIME types                              |
| /etc/nginx/nginx.conf              | Main configuration file                 |
| /etc/nginx/sites-enabled/\*        | Virtual host configuration files        |
| /etc/nginx/win-utf                 | Character set                           |

---

<h2>conf.d/</h2>

- gzip.conf
- resolver.conf
- security_headers.conf
- ssl.conf
- stub_status.conf

<h2>conf.optional.d/</h2>

- mail.conf
- more_headers.conf
- pagespeed.conf
- sysguard.conf

<h2>sites-enabled/</h2>

- 000-default.conf
- 010-example.com.conf
- 015-sub1.example.com.conf
- 016-sub2.example.com.conf
- 020-example.net.conf
