FROM nginx:1.19.3
EXPOSE 80
HEALTHCHECK --interval=45s --timeout=5s --retries=2 --start-period=25s \
  CMD curl localhost:80 || exit 