# nginx-template-image

This container allows you to use the environment variables set by a
Docker link inside of your nginx configuration.

## Usage

Mount your configuration to `/etc/nginx/sites-templates`, preferably
read-only. To capture logs, mount a writable directory to
`/var/log/nginx`.

Both HTTP (80) and HTTPS (443) ports are exposed.

For example:

```
docker run \
  --name nginx \
  -p 80:80 -p 443:443 \
  -v /tmp/nginx-config:/etc/nginx/sites-templates:ro \
  --link my-rails-app:rails \
  noirvisch/nginx-template-image
```

### Example nginx config

This is just an example of how to use the templating with a linked
container named `rails`, and should not be treated as an nginx
configuration guide!

```
server {
  listen       80;
  server_name  my-cool-app.dev;

  location / {
    if (!-f $request_filename) {
      proxy_pass   http://${RAILS_PORT_3000_TCP_ADDR}:${RAILS_PORT_3000_TCP_PORT};
      break;
    }
  }
}
```

## Further information

### Environment variables

Docker links are communicated via environment variables, but nginx
does not easily allow environment variables in configuration files.

To work around this, configuration files mounted at
`/etc/nginx/sites-templates` will be copied to
`/etc/nginx/sites-enabled`. Any file that ends with `.tmpl` will have
variable references like `${FOO}` replaced with the corresponding
environment variable and have the `.tmpl` suffix removed.

### Only include .conf files

The default nginx configuration includes all files in `sites-enabled`,
which makes it difficult to have supplemental files like SSL keys in
the same directory. This container will only load files that end in
`.conf`.
