*This project contains my settings files for vim, zsh, etc.*


===
VIM
===


**-> Verify that vim has been compiled with +python**

Required Plugins And Libraries::

  indent => http://www.vim.org/scripts/script.php?script_id=974
  Syntax Color => http://www.vim.org/scripts/script.php?script_id=790
  taglist => http://vim.sourceforge.net/scripts/script.php?script_id=273
  pep8 => https://github.com/cburroughs/pep8.py
  pydiction => http://www.vim.org/scripts/script.php?script_id=850
      Place the complete-dict and pydiction.py files into ~/.vim/dicts
  pyflakes => http://www.vim.org/scripts/script.php?script_id=2441
  nose => pip install nose
  vim-nosecompiler => https://github.com/olethanh/vim-nosecompiler
  vim-makegreen => https://github.com/reinh/vim-makegreen
      To fix a bug (when you run the tests with \t, it opens a nose file),
      edit makegreen.vim line 26 and add a ! to the make command like so :
         silent! make! %
  doctest => http://www.vim.org/scripts/script.php?script_id=1867


Maps::

  F1 => help system for the word under the cursor
  F2 => Place a sign in your code (ctrl-F2 to remove it)
  F3 =>
  F4 => Execute python script
  F5 =>
  F6 => CleanText (+ Pep8 if python)
  F7 =>
  F8 => Tag List
  F9 =>
  F10 =>
  F11 =>
  F12 =>


Other Plugins You Could Be Interested By::

  NERDCommenter => http://www.vim.org/scripts/script.php?script_id=1218
  Pydoc => http://www.vim.org/scripts/script.php?script_id=910
      \pw to see definition for word under the cursor
  AutoComplPop => http://www.vim.org/scripts/script.php?script_id=1879
  Bicycle Repair Man => http://bicyclerepair.sourceforge.net/
  SnipMate => http://www.vim.org/scripts/script.php?script_id=2540
  python_match => http://www.vim.org/scripts/script.php?script_id=386
