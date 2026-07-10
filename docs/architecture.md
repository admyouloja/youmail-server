# Arquitetura

```text
Notebook
    │
    ▼
GitHub
    │
    ▼
VPS
    │
    ▼
Traefik
    │
    ▼
YouMail API
    │
 ┌──┴───────────────┐
 │                  │
 ▼                  ▼
Postfix         Dovecot
 │                  │
 └──────────┬───────┘
            ▼
         Mail Storage
            │
     ┌──────┴───────┐
     ▼              ▼
 Roundcube      Rspamd
```