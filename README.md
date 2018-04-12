### ECE 552 MIPS Project


## Quick Git
# Getting git
Git is a versioning system designed to keep track of your code. First, you have to make sure its installed. Get git [here](https://git-scm.com/).

# About Git
Now that you have git, you should have a git bash. This is a fancy term for essentially a minGW terminal that has git commands. MinGW is an environment in windows that emulates the Linux subsystem. In other words, it has (most) linux commands!

# Git Commands
Git has various commands to help you update your code on Github. Ironically, the versioning part of github is done automatically as you update your code.
First, lets grab this repository!
```
git clone https://github.com/TeaOfJay/mips
```
Now that we have this repository, let's move our code into this repository. This is quite simple actually, you simply copy paste your files into your folder! Git will automatically know what has changed through its versioning system. Now, you have to add any new files that aren't tracked by git (since git doesn't want to look at all the files) and 'commit' them, or essentially verify that you want to log these changes. 

```
git add <files or directory containing files>
git commit -m "<insert message here>"
```
Finally, lets update our code on Github. 
```
git push
```
Let's say someone updated the code while we were modifying it! How do we update our local version?
```
git pull
```

