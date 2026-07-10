CREATE DATABASE IF NOT EXISTS youmail
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE youmail;

CREATE TABLE IF NOT EXISTS domains (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    status ENUM('pending', 'active', 'suspended', 'disabled') NOT NULL DEFAULT 'pending',
    max_mailboxes INT UNSIGNED NOT NULL DEFAULT 5,
    default_quota_mb INT UNSIGNED NOT NULL DEFAULT 1024,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_domains_name (name)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS mailboxes (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    domain_id BIGINT UNSIGNED NOT NULL,
    local_part VARCHAR(128) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    quota_mb INT UNSIGNED NOT NULL DEFAULT 1024,
    status ENUM('active', 'suspended', 'disabled') NOT NULL DEFAULT 'active',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_mailboxes_domain_local (domain_id, local_part),
    KEY idx_mailboxes_domain (domain_id),
    CONSTRAINT fk_mailboxes_domain
        FOREIGN KEY (domain_id)
        REFERENCES domains(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS aliases (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    domain_id BIGINT UNSIGNED NOT NULL,
    source_local_part VARCHAR(128) NOT NULL,
    destination VARCHAR(320) NOT NULL,
    status ENUM('active', 'disabled') NOT NULL DEFAULT 'active',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_alias_source_destination (
        domain_id,
        source_local_part,
        destination
    ),
    KEY idx_aliases_domain (domain_id),
    CONSTRAINT fk_aliases_domain
        FOREIGN KEY (domain_id)
        REFERENCES domains(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS domain_settings (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    domain_id BIGINT UNSIGNED NOT NULL,
    catch_all_enabled BOOLEAN NOT NULL DEFAULT FALSE,
    catch_all_destination VARCHAR(320) NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_domain_settings_domain (domain_id),
    CONSTRAINT fk_domain_settings_domain
        FOREIGN KEY (domain_id)
        REFERENCES domains(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE OR REPLACE VIEW postfix_virtual_domains AS
SELECT name AS domain
FROM domains
WHERE status = 'active';

CREATE OR REPLACE VIEW postfix_virtual_mailboxes AS
SELECT
    CONCAT(m.local_part, '@', d.name) AS email,
    CONCAT(d.name, '/', m.local_part, '/') AS maildir
FROM mailboxes m
INNER JOIN domains d ON d.id = m.domain_id
WHERE m.status = 'active'
  AND d.status = 'active';

CREATE OR REPLACE VIEW postfix_virtual_aliases AS
SELECT
    CONCAT(a.source_local_part, '@', d.name) AS source,
    a.destination
FROM aliases a
INNER JOIN domains d ON d.id = a.domain_id
WHERE a.status = 'active'
  AND d.status = 'active';

CREATE OR REPLACE VIEW dovecot_users AS
SELECT
    CONCAT(m.local_part, '@', d.name) AS email,
    m.password_hash AS password,
    CONCAT('/var/mail/vhosts/', d.name, '/', m.local_part) AS home,
    CONCAT('maildir:/var/mail/vhosts/', d.name, '/', m.local_part, '/Maildir') AS mail,
    m.quota_mb
FROM mailboxes m
INNER JOIN domains d ON d.id = m.domain_id
WHERE m.status = 'active'
  AND d.status = 'active';