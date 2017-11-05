" A simple plugin to look for key mapping conflicts in Vim
" Copyright 2016-2017 Julien Gamba <julien@jgamba.eu>

" Permission is hereby granted, free of charge, to any person obtaining a copy of
" this software and associated documentation files (the 'Software'), to deal in
" the Software without restriction, including without limitation the rights to
" use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
" of the Software, and to permit persons to whom the Software is furnished to do
" so, subject to the following conditions:

" The above copyright notice and this permission notice shall be included in all
" copies or substantial portions of the Software.

" THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
" SOFTWARE.

""" Utilities
" Convert a list to dictionary. The list entries are of the following form:
"
"   mode | key-map | key-sequence
"
" The resulting dictionary uses the mode as key. Each value is also a
" dictionnary, with the key-map as key. The values of this dictionary are a
" list of the key sequences.
function s:ListToDict(list)
    let dict = {}
    for entry in l
        let splitted = split(list)
        let dict[splitted[0]] = {}
        dict[splitted[0]][splitted[1]] += [splitted[2]]
    endfor
    return dict
endfunc

" Dumps the list of existing conflicts to a file for further analysis.
function s:DictToFile(dict)
    redir >> "./conflicts.log"
    for mmode in keys(dict)
        if mmode ==? "n"
            echom "Normal mode mappings:"
        elseif mmode ==? "i"
            echom "Insert mode mappings:"
        elseif mmode ==? "v"
            echom "Visual and select  mode mappings:"
        elseif mmode ==? "s"
            echom "Select mode mappings:"
        elseif mmode ==? "x"
            echom "Visual mode mappings:"
        elseif mmode ==? "c"
            echom "Command-line mode mappings:"
        elseif mmode ==? "o"
            echom "Operator pending mappings:"
        endif

        for mapping in dict[mmode]
            echom "    " . mapping . " - can mean:"
            for sequence in dict[mmode][mapping]
                echom "\t" . sequence
            endfor
        endfor
    endfor
    redir END
endfunc

""" Mappings getters
" Returns all mappings that work in normal, visual and select and operator
" pending mode
function s:GetMap()
    redir @a
    silent map
    redir END
    let map_mappings = split(@a, '\n')
    return map_mappings
endfunc

" Returns all mappings that work in insert and command-line mode
function s:GetMapExcl()
    redir @a
    silent map!
    redir END
    let map_excl_mappings = split(@a, '\n')
    return map_excl_mappings
endfunc

""" Main function
" Checks if a conflict exists for a given mode
function s:DetectConflicts(list)
    let mappings = ListToDict(list)
    let conflicts = {}
    for mmode in keys(mappings)
        for mapping in mappings[mmode]
            if len(mappings[mmode][mapping]) > 1
                let conflicts[mapping] = mappings[mmode][mapping]
            endif
    endfor

    let nb_conflicts = len(keys(conflicts))
    if nb_conflicts > 0
        echom nb_conflicts . " conflicts detected. "
        echom "Check the conflicts.log file for details."
        return conflicts
    else
        echom "No conflict detected."
    endif
endfunc

" command! CheckMapping call DetectConflicts()
