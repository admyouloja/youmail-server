# RFC-0001 - Arquitetura da Plataforma YouMail

## Objetivo

Definir a arquitetura oficial da plataforma YouMail.

---

## Componentes

- Traefik
- Postfix
- Dovecot
- MariaDB
- Roundcube
- Rspamd
- Redis
- API YouMail
- Base44
- Supabase

---

## Fluxo

Cliente

↓

Internet

↓

Traefik

↓

API

↓

Postfix

↓

Dovecot

↓

Mail Storage

↓

Roundcube