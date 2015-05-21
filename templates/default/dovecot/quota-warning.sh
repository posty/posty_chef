#!/bin/sh
PERCENT=$1
USER=$2
cat << EOF | /usr/lib/dovecot/dovecot-lda -d $USER -o "plugin/quota=maildir:User quota:noenforcing"
From: postmaster@webflow.de
To: $USER
Subject: E-Mail Speicherplatz Limit fast erreicht
 

Sehr geehrter Benutzer
 
Ihr E-Mail Konto $USER hat den verfügbaren Speicherplatz (nahezu) ausgeschöpft.
Aktuell sind $PERCENT% Ihres Speicherplatzes belegt.

Sollten Sie dazu Fragen haben kontaktieren Sie uns bitte.
 
Ihr Postmaster

EOF
