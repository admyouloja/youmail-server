CREATE USER IF NOT EXISTS 'youmail_service'@'%'
IDENTIFIED BY 'ALTERAR_VIA_DEPLOY';

GRANT SELECT ON youmail.postfix_virtual_domains
TO 'youmail_service'@'%';

GRANT SELECT ON youmail.postfix_virtual_mailboxes
TO 'youmail_service'@'%';

GRANT SELECT ON youmail.postfix_virtual_aliases
TO 'youmail_service'@'%';

GRANT SELECT ON youmail.dovecot_users
TO 'youmail_service'@'%';

FLUSH PRIVILEGES;