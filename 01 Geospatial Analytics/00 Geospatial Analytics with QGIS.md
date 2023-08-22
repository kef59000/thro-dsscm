
# Setup
## Installing Docker
Install Docker Desktop on your local machine. Then, run the following code block: 

    docker pull ubuntu
    docker run -it ubuntu bash

## Installing the required software packages
Install the text following software packages:

    apt update
    apt install nano
    apt install vim
    apt install iputils-ping
    apt install curl

## Determine which Shell you are using:
Type in the following command:

    which $SHELL

Alternatively:
    
    which bash
    
# Using the Command Line
Try the following command

    echo "Hi THRO"

# Exercise 1: First Steps
Create a file named **my_bash.sh** using the nano command (basically, you can use any editor of your choice , e.g., vim).

## Step 1: Create your script
In your terminal, run the following code:

    nano my_bash.sh

Enter [this code](<./01 First Steps.sh>).

Search for your file in the directory:

    ls

Execute your script:

    bash my_bash.sh

## Step 2: Make your script executable
Try the following. What happens?

    ./my_bash.sh

Check for the permissions:

    ls -l

Alter the permission:

    chmod +x my_bash.sh

Check for the permissions again:

    ls -l

Try the following again:

    ./my_bash.sh


# Exercise 2: Variables 1
Create a bash file with [this code](<./02 Variables 1.sh>). There are different options to determine the outcome...

# Exercise 3: Variables 2
Create a bash file with [this code](<./03 Variables 2.sh>). 

## Setting system variables
Try the following

    twitter="Elon Musk"
    echo $twitter

Try to use this variable in your script. What happens?

Try the following:

    export twitter

Try to use this variable in your script. What happens now?

## Making your environement variable permanent
Edit the **.bashrc** file (The dot "." indicates that this is a hidden file).

Try the following. Do you see the file?

    ls

Now, try this:

    ls -al

Now, you should see the **.bashrc** file.

Edit the file now:

    nano .bashrc

Add a new line to this file

    twitter="Elon Musk"

Next time you log in to your system, the variable will be set. So, you made it permanent.

## Doing some Bash math
Type in the following code:

    echo $(( 2 + 3 ))
    echo $(( $RANDOM % 10 ))


# Exercise 4: Branching
Create a bash file with [this code](<./04 Branching.sh>). 

# Exercise 5: Looping
Create a bash file with [this code](<./05 Looping.sh>).

Note:
- **Ctrl + C** ...breaks an infinite loop.
- **break** ...breaks the loop
- **continue** ...skips the iteration

Create a file named "cities.txt" and put in these cities, each in a new row: paris, nyc, london

# Basic Bash Commands

| Command    | Description |
| -------- | ------- |
| ps  | Determine your shell type    |
| date | Displays the current date     |
| pwd    | Displays the present working directory    |
| whoami    |     |
| ls    | Lists the contents of the current directory    |
| echo    | Prints a string of text, or value of a variable to the terminal    |
| cd        | Change the directory to a different location.    |
| ls        | List the contents of the current directory.     |
| mkdir     | Create a new directory.   |
| touch     | Create a new file.    |
| rm        | Remove a file or directory.   |
| cp        | Copy a file or directory.   |
| mv        | Move or rename a file or directory.   |
| echo    | Print text to the terminal.   |
| cat    | Concatenate and print the contents of a file.   |
| grep    | Search for a pattern in a file.   |
| chmod    | Change the permissions of a file or directory.   |
| sudo    | Run a command with administrative privileges.   |
| df    | Display the amount of disk space available.   |
| history    | Show a list of previously executed commands.   |
| ps    | Display information about running processes.   |
| head    | Displays the first rows of a file.   |
| tail    | Displays the last rows of a file.   |

# References
- [you need to learn BASH Scripting RIGHT NOW!! // EP 1](https://www.youtube.com/watch?v=SPwyp2NG-bE&t=167s)
- [chmod](https://www.shellbefehle.de/befehle/chmod/)