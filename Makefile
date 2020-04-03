PREFIX = /usr
CONKYDIR = $(DESTDIR)$(PREFIX)/share/conky/naheel

rn: runner.v runners.json build.sh
	sh ./build.sh

install: rn
	cp rn /bin/ || cp rn /usr/local/bin/

gedit:
	mkdir -p ~/.local/share/gedit/plugins/
	cp runner_gedit.py ~/.local/share/gedit/plugins/
	cp runner_gedit.plugin ~/.local/share/gedit/plugins/

uninstall:
	rm -f /bin/rn
	rm -f /usr/local/bin/rn
	rm -f ~/.local/share/gedit/plugins/runner_gedit.py
	rm -f ~/.local/share/gedit/plugins/runner_gedit.plugin

clean:
	rm -rf ~/.cache/runnables
	rm -rf build
	rm -f rn

test:
	./test.sh

.PHONY: clean install uninstall gedit test
