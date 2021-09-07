#!/bin/bash
{ echo -n '_';cat $1|xxd -u -p|tr -d '\n'|sed 's/.\{6\}/&_/g';}|sed 's/_00/_right /g;s/_01/_left /g;s/_02/_write /g;s/_03/_state /g;s/_04/_close /g;s/_05/_if /g;s/_06/_run /g;s/_07/_print /g;s/_08/_print_tape /g'|tr '_' '\n'
