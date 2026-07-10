# Sprint 8 — Modelo de dados do YouMail

## Objetivo

Criar o modelo MariaDB usado por Postfix, Dovecot e pela futura API YouMail.

## Tabelas

- `domains`: domínios hospedados.
- `mailboxes`: caixas postais virtuais.
- `aliases`: endereços alternativos e encaminhamentos.
- `domain_settings`: configurações específicas do domínio.

## Views técnicas

- `postfix_virtual_domains`
- `postfix_virtual_mailboxes`
- `postfix_virtual_aliases`
- `dovecot_users`

## Segurança

- Senhas reais não são versionadas.
- A conta técnica terá somente permissão de leitura nas views.
- A futura API utilizará outra conta com permissões controladas de escrita.
- As senhas das caixas serão armazenadas como hashes compatíveis com Dovecot.

## Próximas etapas

1. Aplicar o esquema na VPS.
2. Criar um domínio de teste.
3. Criar uma caixa postal de teste.
4. Validar as consultas.
5. Integrar o Postfix.
6. Integrar o Dovecot.