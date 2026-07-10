# Sprint 7 — MariaDB e Redis

## Objetivo

Disponibilizar a infraestrutura inicial de banco de dados e cache do YouMail.

## Serviços

### MariaDB

Responsável futuramente por:

- domínios virtuais;
- caixas postais;
- aliases;
- quotas;
- dados técnicos do Postfix e Dovecot;
- banco do Roundcube.

### Redis

Responsável futuramente por:

- cache;
- filas;
- sessões;
- rate limiting;
- tarefas da API YouMail.

## Segurança

- Nenhuma porta de MariaDB ou Redis é publicada no host.
- Os serviços ficam em uma rede Docker interna.
- Senhas reais não são versionadas.
- Volumes nomeados garantem persistência.
- Healthchecks verificam a disponibilidade dos serviços.

## Comandos

### Validar

```bash
./scripts/docker/validate.sh
```

### Iniciar

```bash
./scripts/docker/start.sh
```

### Verificar status

```bash
./scripts/docker/status.sh
```

### Consultar logs

```bash
./scripts/docker/logs.sh
```

### Parar

```bash
./scripts/docker/stop.sh
```

## Observação

Os scripts Docker devem ser executados na VPS Hostinger ou em uma máquina que possua Docker instalado.