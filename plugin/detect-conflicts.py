#!/usr/bin/python

# A simple plugin to look for key mapping conflicts in Vim
# Copyright (C) 2016 Julien Gamba <julien@jgamba.eu>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

try:
    import vim
    import string

    commands = []
    conflicts = []

    vim.command('redir @a')
    vim.command('silent map')
    vim.command('redir END')
    tmp = vim.eval('@a')
    results = tmp
    
    vim.command('redir @a')
    vim.command('silent nmap')
    vim.command('redir END')
    results = results + vim.eval('@a')
    
    vim.command('redir @a')
    vim.command('silent vmap')
    vim.command('redir END')
    results = results + vim.eval('@a')
    
    vim.command('redir @a')
    vim.command('silent imap')
    vim.command('redir END')
    results = results + vim.eval('@a')

    for line in results.splitlines():
        # check if line is not empty
        if line:
            mode = line[0]
            line = line[3:].strip()
            chunks = line.partition(' ')
            key = chunks[0]
            sequence = chunks[2].lstrip(' ')

            if key[0] is '<':
                command = {
                    'mode': mode,
                    'key': key,
                    'command': sequence
                }

                if command in commands:
                    if "Plug" not in command['key']:
                        conflicts.append(command)
                else:
                    commands.append(command)

    if not conflicts:
        print "No key-mapping conflict found."
    else:
        print format(len(conflicts)), "conflicts found. Check conflicts.log for details"
        with open('./conflicts.log', 'w') as file:
            file.write("Mode  -  Key sequence  -  Command\n\n")
            for command in conflicts:
                tmp = command['mode'] + '\t' \
                        + command['key'] + '\t' \
                        + command['command'] + '\n'
                file.write(tmp)
        file.close()

except vim.error as e:
    print e
