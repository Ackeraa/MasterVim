# master-vim

# from 0 to 1

## Attributes
* HP
* ATK
* money
* keys 
* weapon
* magic

## Movements
Normal Mode:
* h, l, j, k, w/W, e/E, b/B, ge, 0, $ -> basic move
* d*/D -> destroy
* x -> pick up, hold in hand
* p -> use tool in hand
* "[0-9]x -> pick up, put into bag[0-9]
* "[0-9]p -> use tool in bag[0-9]
* >> -> move a sequence of box
* f -> find  sth, hidden trap, use f to jump to safe place
* qx{changes}q -> You perform once, your shadow repeat it
* * -> could find the number of matches
* <C-a>/<C-x> -> change numbers 7 
* gU/gu -> swap uppercase or lowercase
* <C-o> -> insert normal model, could use with only insert enabled 
* <C-r>0 -> paste in insert model, could use with only inert enabled 
* <C-r> = -> calculate
* R -> replace sth
* %normal A;/%normal @q -> add sth to each line


Insert Mode:
* i, I, a, A, s, S -> fill chars, maybe
* c, C

Visual Mode:
* v/V/<C-v> -> used by shadow to clear(move or delete) a path for self, use o to goto the other end
* vit -> more complicated moves

Command-Line Mode:
* [range] delete [x] -> delete into x
* [range] yank [x] -> yank into x
* [line] put [x]  -> put after line
* [range] copy {address} -> copy under address line
* [range] move {address} -> move under address line
* [range] join -> join specific lines
* [range] normal {commands} -> excute normal command on each specific line
* :2,$!sort -t',' -k2 -> filter
* :bnext, bprevisou, blast, bnext -> switch stairs
* :bufdo -> do sth in all stairs
* :args -> list all stairs

Move Faster:
* `. -> location of last move
* `[ -> start of last yank
* `< -> start of last visual selection
* <C-o>/<C-i> -> jump back/forward, used for backward the exact positions
* (/) -> jump to the start of previous/next sentence
* {/} -> jump to the start of previous/next paragraph
* '{mark} -> jump to a mark
* argdo normal @a -> execute ex command in argument list buffers

Match patterns:
* /\v -> very magic search
* /\V -> very no magic search
* /\_s -> white space or line break
* <> -> word boundaries
* /\zs -> start of the match
* /\ze -> end of the match
* /e -> place the cursor at the end of the search
* submatch(0)
* :g//d -> global command
* :v//d -> executes a command that does not match
* :g/TODO/yank A

## Ideas
* Try to keep as simple as possible.
* Encourage fast move by introducing dangerous cells.
* Could use multi-cell as one to imporve UI.
* Get move skills gradually.
* Use buffer command to move between stairs.
* Create maze only surounded could be seen
* How about introducing a shadow, who is more flexable.
* There must be a good story about shadow.


