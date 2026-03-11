test:
	echo "Running Harbor tests..."
	echo "======================="
	nvim --headless --noplugin -u lua/tests/minimal.lua -c "verbose=1" -c "PlenaryBustedDirectory lua/tests/ {init='lua/tests/minimal.lua', helper='lua/tests/spec_helper.lua'}"
