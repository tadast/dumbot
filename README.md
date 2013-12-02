Meet Dumbot
========

Dumbot is a Campfire bot for fun, entertainment, and quick task management.
Implemented using Scamp framework (https://github.com/wjessop/Scamp)

How to
========
Rename config.yml.sample to config.yml. Edit sample values to your credentials.
Then run `bundle install` to install all required dependencies.
To launch, run `ruby meme_bot.rb`.

Commands
========
Some of the things you can do with the bot.

Essentials
----------
* geminfo __gemname__ (more) - even more useful info from rubygems. `more` is optional
* artme __keyword__ - get a random picture from google search (taken from Scamp examples)
* meme __&lt;meme-name&gt;__ __&lt;top text&gt;__/__&lt;bottom text&gt;__ - generate a meme with top and bottom captions
* weather - displays weather in London
* Y U NO __do_something__ - generates and pastes Y U NO meme poster
* north korea or CCCP - adds a 'censorship stick' to scroll up whatever you had on the screen

Tasks
-----
* add task __work_to_do__ - Adds a task to the current list pending tasks
* tasks - List current pending tasks
* __id__ is mine - Claim a task for yourself
* my tasks - List current pending tasks assigned to me
* __id__ is done - Mark task as completed
* __id__ is too hard - Unclaim task. Bot will LOL
* __username__ do __id__ - assigns the task to the user
* import tasks '__list of numbered tasks__' - imports the tasks you have pasted
* task help - Print something similar to the above

Motivational
------------
The bot also matches phrases like __LOL, OMG, ZOMG, facepalm, fffffffuuuuuuuuuuuu, tea break?, not bad, SUCCESS, FAILURE, friday, like a boss, whew, ship it!, humble__ etc..
