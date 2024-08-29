# How to ACTUALLY compile:
1. Use Haxe 4.2.5. Not a version before, not a version after. Don't worry, you usually won't lose anything. Just your sanity.
2. Install hmm globally (using `haxelib install hmm --global`), and use `hmm setup` if you want to get the hmm command.
3. Run `haxelib newrepo` in the directory so that libraries from the HMM step don't all install globally. 
These are old versions and ourple v3 was made on an old version of psych engine.

That means installing the libraries that I set in the hmm file for you will get you old libraries, and if you want to use other ones for another project and they're installed globally, you'll have to manually `haxelib set` your libraries to the versions you'll need for those projects.

**If you have 'em (check using `haxelib list --global`) , remove them.**

5. Run `hmm install` like usual.
6. If step 3 was done, ALL libraries installed after should install into the .haxelib directory in the main directory. .haxelib will be gitignored so don't worry about that. If your current working directory has this .haxelib, ALL libraries installed will be installed
  locally for this that repo, as they call it. You must know the difference between a local library and a global library before you proceed.
7. Install hxcodec 2.6.1 GLOBALLY, not locally. If you install it locally, the compile WILL NOT DETECT IT. I have no clue why, but this is how it has been for years. HMM cannot handle this for you, as there is no option to set a library in an hmm json to install globally. You must do it on your own using `haxelib install hxCodec 2.6.1 --global'. You MUST include '--global' or else it will install locally into the .haxelib directory and you will be confused.
8. You're pretty much done.



# But why? Why are things this way?
Because Ourple Guy V3 isn't built off of the same exact most up to date psych engine you know and love. This is a SOURCE CODE mod. If the team decided to just upgrade to a new version just yet, that would be no good, especially with v4 in the works already. There are simply too many conflicts. While yes, V3 was worked on a long time before July, the build only started in July. The mod released in October. Of 2023. That was last year. It's been a year since July of 2023. The version of psych engine you're seeing here is a year old. Things have long changed since then. 
