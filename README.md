Fuzzy Find to Insert Lines in vis
=================================

Use [fzf](https://github.com/junegunn/fzf) to select lines from a file
insert it.

Usage
------

In vis, use the command `[[1` to `[[9` to select lines from different
files. `[[[` is synonym for `[[1`, `[[(` is synonym for `[[2`.

Configuration
--------------

Put the file `vis-fzf-insert.lua` into a plugin directory of vis (usually
`/usr/share/vis/plugins/`). In visrc.lua:

	plugin_vis_insert = require('plugins/vis-fzf-insert')
	file1="/usr/local/etc/wikititles" --These are just an example
	file2="/usr/local/etc/texts_list"
	plugin_vis_insert.cmd_args = {"--height=40% <"..file1, "--height=40% <"..file2}

One can also specify prefixes and postfixes that get inserted after or
before the line selected from the file:

	plugin_vis_insert.paste_prefix = {"(https://en.wikipedia.org/wiki/", ""}
	plugin_vis_insert.paste_postfix = {")", ""}

Here `"(https://en.wikipedia.org/wiki/"` is a prefix that applies to
lines from the file `wikititles`, and `")"` is a postfix that applies
to the `wikititles` file. `texts_list` has no prefixes or postfixes.

See Also
---------

Forked from
[vis-fzf-open](https://github.com/guillaumecherel/vis-fzf-open/),
in an attempt to re-create the link insertion functionality from
[Wikipedia](https://en.wikipedia.org/wiki/About:Wikipedia).
