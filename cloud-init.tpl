#cloud-config
write_files:
  - path: /opt/demo/index.html
    permissions: "0644"
    content: |
      <html>
        <head><title>${role}</title></head>
        <body style="font-family: sans-serif">
          <h1>${role} OK</h1>
          <p>Listening on port ${port}</p>
        </body>
      </html>

  - path: /etc/systemd/system/demo.service
    permissions: "0644"
    content: |
      [Unit]
      Description=Simple HTTP demo on port ${port}
      After=network-online.target
      Wants=network-online.target

      [Service]
      Type=simple
      ExecStart=/usr/bin/python3 -m http.server ${port} --directory /opt/demo
      Restart=always

      [Install]
      WantedBy=multi-user.target

runcmd:
  - [ bash, -lc, "systemctl daemon-reload" ]
  - [ bash, -lc, "systemctl enable --now demo.service" ]
