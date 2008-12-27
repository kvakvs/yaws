

ERL="/usr/local/bin/erl"
ERLC="/usr/local/bin/erlc"
YTOP="/Users/klacke/yaws/erlyaws/trunk/yaws"

YAWS=$(YTOP)/bin/yaws

%.beam: %.erl
	"$(ERLC)" -Ddebug $<

none:
	echo "Do make clean|all|test"
	exit 1

tclean:
	@rm -rf logs *.beam *.log yaws.conf erl_crash.dump 2> /dev/null || true


setup:
	@rm -rf logs 2> /dev/null
	@mkdir logs
	$(MAKE) start

start:	
	$(YTOP)/bin/yaws -sname test --daemon --id testid --conf ./yaws.conf
	../support/wait_started.sh

## Interactive node
i:
	$(YTOP)/bin/yaws -sname test -i --id testid --conf ./yaws.conf

PA =           -pa $(YTOP)/test/ibrowse/ebin  \
               -pa $(YTOP)/test/src  \
	       -pa $(YTOP)/ebin

## connect to existing yaws node
connect:
	$(ERL) -sname client $(PA) \
	       -s test connect `hostname`


status:
	$(YTOP)/bin/yaws  --id testid --status
stop:
	$(YTOP)/bin/yaws --id testid --stop

stdconf:
	cat ../conf/stdconf.conf | \
	../../scripts/Subst %YTOP% $(YTOP) \
   	> yaws.conf