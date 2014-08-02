#!/bin/sh

EX_OK=0
EX_BOUNCE=69
EX_DEFER=75

SENDMAIL="/usr/sbin/sendmail -G -i -t"

INPUT=`mktemp /tmp/mail-scanner.XXXXXXXX`
OUTPUT=`mktemp /tmp/mail-scanner.XXXXXXXX`
if [ "$?" != 0 ]; then
    logger -s -p mail.warning -t scanner "Unable to create temporary files, deferring"
    exit $EX_DEFER
fi
trap "rm -f $INPUT $OUTPUT" 0 1 2 3 15
cat >$INPUT

<% if node["posty"]["clamav"]["install"] %>
/usr/bin/clamdscan --quiet - <$INPUT
return="$?"
if [ "$return" = 1 ]; then
    logger -p mail.info "ClamAV found virus, discarding"
    exit $EX_OK
elif [ "$return" != 0 ]; then
    logger -s -p mail.warning -t scanner "Temporary ClamAV failure $return, deferring"
    exit $EX_DEFER
fi
<% end %>

<% if node["posty"]["spamassassin"]["install"] %>
/usr/bin/spamc -u debian-spamd -E -x <$INPUT >$OUTPUT
<% end %>

$SENDMAIL "$@" <$OUTPUT
exit $?
