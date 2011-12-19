Camp with meme!
========

Campfire bot for fun and entertainment.
Implemented using Scamp framework (https://github.com/wjessop/Scamp)

How to
========
Rename config.yml.sample to config.yml. Edit sample values to your credentials.
Then run `bundle install` to install all required dependencies
To launch run `ruby meme_bot.rb`.

Commands
========
Some of the things you can do with dumbot.

Essentials
----------
* geminfo __gemname__ - useful info from rubygems
* geminfo __gemname__ more - even more useful info from rubygems
* artme __keyword__ - get a picture from google search (taken from Scamp)
* weather - displays weather in London
* Y U NO __do_something__ - generates and pastes Y U NO meme poster
* last __twitter_name__'s tweet - embed the last tweet for a given twitter handle
* north korea - adds a 'censorship stick' to scroll up whatever you had on the screen

Tasks
-----
* task - List current pending tasks
* task push __work_to_do__ - Adds a task to the current list pending tasks
* task claim __id__ - Claim a task for yourself
* task done __id__ - Mark task as completed
* task help - Print something similar to the above

Motivational
------------
It also matches phrases like __LOL, OMG, ZOMG, facepalm, fffffffuuuuuuuuuuuu, tea break?, not bad, SUCCESS, FAILURE, friday, like a boss, whew, ship it!, humble__ etc..