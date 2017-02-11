import random
import copy
import sys
import operator
from texasHoldem import drawBoard


def play():
    print 'welcome to the main menu\n'
    print '_________ _______           _______  _______  \n\__   __/(  ____ \|\     /|(  ___  )(  ____ \ \n   ) (   | (    \/( \   / )| (   ) || (    \/ \n   | |   | (__     \ (_) / | (___) || (_____  \n   | |   |  __)     ) _ (  |  ___  |(_____  ) \n   | |   | (       / ( ) \ | (   ) |      ) | \n   | |   | (____/\( /   \ )| )   ( |/\____) | \n   )_(   (_______/|/     \||/     \|\_______) \n \n                                              \n          _______  _        ______   _______  _______  \n|\     /|(  ___  )( \      (  __  \ (  ____ \(       ) \n| )   ( || (   ) || (      | (  \  )| (    \/| () () | \n| (___) || |   | || |      | |   ) || (__    | || || | \n|  ___  || |   | || |      | |   | ||  __)   | |(_)| | \n| (   ) || |   | || |      | |   ) || (      | |   | | \n| )   ( || (___) || (____/\| (__/  )| (____/\| )   ( | \n|/     \|(_______)(_______/(______/ (_______/|/     \|'
    choice = raw_input('would you like to play? y/n: ')
    print 'Enter \'q\' at any time to QUIT.'
    counter = 1
    while (choice=='y'):
        print "\n\n"
        print "ROUND "+str(counter)+"!"
        counter+= 1
        drawBoard()

# will quit game if you decide to fold
