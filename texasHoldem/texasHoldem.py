import random
import copy
import sys
import operator
from hand_options import *


cards = ['Ah', 'Ad', 'Ac', 'As', 
	 'Kh', 'Kd', 'Kc', 'Ks',
	 'Qh', 'Qd', 'Qc', 'Qs',
	 'Jh', 'Jd', 'Jc', 'Js',
	 'Th', 'Td', 'Tc', 'Ts',
	 '9h', '9d', '9c', '9s',
	 '8h', '8d', '8c', '8s',
	 '7h', '7d', '7c', '7s',
	 '6h', '6d', '6c', '6s',
	 '5h', '5d', '5c', '5s',
	 '4h', '4d', '4c', '4s',
	 '3h', '3d', '3c', '3s',
	 '2h', '2d', '2c', '2s']
cardValues = {'Ah':1 or 14, 'Ad':1 or 14, 'Ac':1 or 14, 'As':1 or 14, 
	      'Kh':13, 'Kd':13, 'Kc':13, 'Ks':13,
	      'Qh':12, 'Qd':12, 'Qc':12, 'Qs':12,
	      'Jh':11, 'Jd':11, 'Jc':11, 'Js':11,
	      'Th':10, 'Td':10, 'Tc':10, 'Ts':10,
	      '9h':9, '9d':9, '9c':9, '9s':9,
	      '8h':8, '8d':8, '8c':8, '8s':8,
	      '7h':7, '7d':7, '7c':7, '7s':7,
	      '6h':6, '6d':6, '6c':6, '6s':6,
	      '5h':5, '5d':5, '5c':5, '5s':5,
	      '4h':4, '4d':4, '4c':4, '4s':4,
	      '3h':3, '3d':3, '3c':3, '3s':3,
	      '2h':2, '2d':2, '2c':2, '2s':2}

compHand = []
myHand = []
community = []
usedCards = []
currentbet = 0
currentpot = 0
paircount = 0
myWinnings = 50
compWinnings = 50
currentplayer = True #person player

# cardOrder = # depends on Flop (3), Turn (4), or River (5)

def drawBoard():
    global currentplayer
    compcard1 = cardGen()
    compcard2 = cardGen()
    compHand.append(compcard1)
    compHand.append(compcard2)
    handPrint("  ", "  ")
    print "\n"
    mycard1 = cardGen()
    mycard2 = cardGen()
    myHand.append(mycard1)
    myHand.append(mycard2)
    handPrint(mycard1, mycard2)
    print "\n"
    choice1 = ""
    playerprint()
    if(currentplayer):
        choice1 = (raw_input ("Call/Check [c], Bet [b], or Fold [f]?: "))
    if(not currentplayer):
        choice1 = getComputerMove()
    if(choice1 == 'q'):
        print '\nQuitting Texas Holdem...\n'
        sys.exit(0)
    if(choice1 == 'f'):
        fold()
    elif(choice != 'f'):
        choice(choice1)
        print "\n"
        print "Time to Flop.\n"
        flop()

def choice(choice1):
    global currentplayer, currentbet
    if((choice1 == 'c') and (currentbet == 0)):
            currentplayer = not currentplayer
            if(currentplayer):
                    choice1 = (raw_input ("Call/Check [c], Bet [b], or Fold [f]?: "))
            if(not currentplayer):
                    choice1 = getComputerMove()
    if(choice1 == 'q'):
        sys.exit(0)
    if(choice1 == 'c'):
        call()
    if(choice1 == 'b'):
        bet()
    if(choice1 == 'f'):
        fold()
    else:
        choice1 = raw_input("please choose Call/check [c], Bet [b], or Fold [f]: ")
    
def playerprint():
    if(currentplayer):
            print "[YOUR TURN]"
    else:
            print"[COMPUTER'S TURN]"

def call():
    global currentbet
    global currentpot
    global currentplayer, myWinnings, compWinnings
    if(currentplayer):
            myWinnings = myWinnings - int(currentbet)
    if(not currentplayer):
            print 'The computer chose to call/check.'
            compWinnings = compWinnings - int(currentbet)
    currentpot += int(currentbet)
    currentplayer = not currentplayer
    currentbet = 0

def bet():
    global currentbet
    global currentpot
    global currentplayer, myWinnings, compWinnings
    if(currentplayer):
            currentbet = raw_input ("How much do you want to bet? (Integers only): ")
    if(not currentplayer):
            currentbet = getComputerBet()
            print "The computer chose to bet "+str(currentbet)+" dollars."
    print "\n"
    print "Current BET is: ", currentbet
    currentpot += int(currentbet)
    print "Current POT is: ", currentpot
    print "\n"
    if(currentplayer):
            myWinnings = myWinnings - int(currentbet)
    if(not currentplayer):
            compWinnings = compWinnings - int(currentbet)
    currentplayer = not currentplayer
    playerprint()
    if(currentplayer):
            choice1 = raw_input ("Call/Check [c], Bet [b], or Fold [f]?: ")
    if(not currentplayer):
            choice1 = getComputerMove()
    choice(choice1)

def fold():
    global currentplayer, myWinnings, compWinnings
    if(currentplayer):
            print "The pot goes to the computer player.\n"
            compWinnings += currentpot
    else:
            print "Congrats! Computer folded, you win the pot!\n"
            myWinnings += currentpot
    print "You now have "+ str(myWinnings)
    currentplayer = not currentplayer
    reset()
    #sys.exit(0)

def handPrint(x, y):
    print " ----    ---- \n"
    print "|    |  |    |\n"
    print "| "+x+" |  | "+y+" |\n"
    print "|    |  |    |\n"
    print " ~~~~    ~~~~ \n"

def boardPrint(a, b, c, d, e):
    print "Current POT is: ", currentpot
    print "COMMUNITY CARDS:"
    print " ----    ----    ----    ----    ---- \n"
    print "|    |  |    |  |    |  |    |  |    |\n"
    print "| "+a+" |  | "+b+" |  | "+c+" |  | "+d+" |  | "+e+" |\n"
    print "|    |  |    |  |    |  |    |  |    |\n"
    print " ~~~~    ~~~~    ~~~~    ~~~~    ~~~~ \n"
    print "YOUR CARDS:"
    global myHand
    handPrint(myHand[0], myHand[1])

# storing computer hand for computer heuristics
def flop():
    flopcard1 = cardGen()
    flopcard2 = cardGen()
    flopcard3 = cardGen()
    community.append(flopcard1)
    community.append(flopcard2)
    community.append(flopcard3)
    boardPrint(flopcard1, flopcard2, flopcard3, "  ", "  ") 
    print "\n"
    choice1 = ""
    playerprint()
    if(currentplayer):
            choice1 = (raw_input ("Call/Check [c], Bet [b], or Fold [f]?: "))
    if(not currentplayer):
            choice1 = getComputerMove()
    print "\n"
    if(choice1 == 'f'):
            fold()
    else:
            choice(choice1)
            turn()

def turn():
    global currentplayer
    print "\n"
    print "Play the turn.\n"
    newcard4 = cardGen()
    community.append(newcard4)
    boardPrint(community[0], community[1], community[2], newcard4, "  ") 
    print "\n"
    choice1 = ""
    playerprint()
    if(currentplayer):
            choice1 = (raw_input ("Call/Check [c], Bet [b], or Fold [f]?: "))
    if(not currentplayer):
            choice1 = getComputerMove()
    print "\n"
    if(choice1 == 'f'):
            fold()
    elif(choice1 != 'f'):
            choice(choice1)
            river()

def river():
    global currentplayer
    print "\n"
    print"River Round!\n"
    newcard5 = cardGen()
    community.append(newcard5)
    boardPrint(community[0], community[1], community[2], community[3], newcard5) 
    print "\n"
    playerprint()
    if(currentplayer):
            choice1 = (raw_input ("Call/Check [c], Bet [b], or Fold [f]?: "))
    if(not currentplayer):
            choice1 = getComputerMove()
    print "\n"
    if(choice1 == 'f'):
            fold()
    else:
            choice(choice1)
            endgame()

def endgame():
    global myHand, myWinnings, compWinnings
    global compHand
    boardPrint(community[0], community[1], community[2], community[3], community[4])
    print "COMPUTER HAND: "
    handPrint(compHand[0], compHand[1])
    computer = []
    human = []
    #computer.append(compHand)
    #computer.append(community)
    #human.append(myHand)
    #human.append(community)
    computer = compHand + community
    human = myHand + community
    #print human
    #print computer
    winner = whoWon(handRank(human), handRank(computer))
    print "Good Game!"
    if(winner == 'human'):
            myWinnings += currentpot
    if(winner == 'computer'):
            compWinnings += currentpot
    if(winner == 'draw'):
            compWinnings += (currentpot /2 )
            myWinnings += (currentpot /2)
    print "\n"
    print "You now have "+ str(myWinnings) +" dollars."
    reset()

def reset():
    global cards, cardValues, compHand, myHand, community, usedCards, currentbet, currentpot, paircount
    cards = ['Ah', 'Ad', 'Ac', 'As', 
             'Kh', 'Kd', 'Kc', 'Ks',
             'Qh', 'Qd', 'Qc', 'Qs',
             'Jh', 'Jd', 'Jc', 'Js',
             'Th', 'Td', 'Tc', 'Ts',
             '9h', '9d', '9c', '9s',
             '8h', '8d', '8c', '8s',
             '7h', '7d', '7c', '7s',
             '6h', '6d', '6c', '6s',
             '5h', '5d', '5c', '5s',
             '4h', '4d', '4c', '4s',
             '3h', '3d', '3c', '3s',
             '2h', '2d', '2c', '2s']
    compHand = []
    myHand = []
    community = []
    usedCards = []
    currentbet = 0
    currentpot = 0
    paircount = 0

def handRank(hand):
    global paircount
    if(royalFlush(hand)):
            return 'Royal Flush'
    elif(straightFlush(hand)):
            return 'Straight Flush'
    elif(fourOFkind(hand)):
            return 'Four Of A Kind'
    elif(fullHouse(hand)):
            return 'Full House'
    elif(flush(hand)):
            return 'Flush'
    elif(straight(hand)):
            return 'Straight'
    elif(threeOFkind(hand)):
            return 'Three Of A Kind'
    elif(pairs(hand)):
            tempcount = paircount
            paircount = 0
            return str(tempcount) + ' Pair(s)'
    else:
            return 'High Card'

rank = {'Royal Flush': 10,
        'Straight Flush': 9,
        'Four Of A Kind': 8,
        'Full House': 7,
        'Flush': 8,
        'Straight': 7,
        'Three Of A Kind': 6,
        '2 Pair(s)': 4,
        '1 Pair(s)': 3,
        'High Card': 2}

def whoWon(human, computer):
    #print rank[computer]
    #print rank[human]
    winner = ""
    if(human == 'High Card' and computer == 'High Card'):
            if(highcard(myHand) > highcard(compHand)):
                    print 'You win! With the higher card'
                    winner = 'human'
            if(highcard(myHand) < highcard(compHand)):
                    print 'You lose! With the lower card'
                    winner = 'computer'
            if(highcard(myHand) == highcard(compHand)):
                    for c in myHand:
                            if(highcard(human)==cardValues.get(c)):
                                    human.remove(c)
                    for k in compHand:
                            if(highcard(computer)==cardValues.get(k)):
                                    human.remove(k)
                    if(highcard(myHand) > highcard(compHand)):
                            print 'You win! With the higher card'
                            winner = 'human'
                    if(highcard(myHand) < highcard(compHand)):
                            print 'You lose! With the lower card'
                            winner = 'computer'
    elif(rank[human] > rank[computer]):
            print human, ' beats ', computer, 'You Won!'
            winner = 'human'
    elif(rank[computer] > rank[human]):
            print computer, ' beats ', human, 'You Lost!'
            winner = 'computer'
    elif(rank[computer]==rank[human]):
            # print 'Draw! Winner goes to Highest card'
            winner = 'draw'
            if(highcard(myHand) > highcard(compHand)):
                    print 'You win with the high card!'
                    winner = 'human'
            if(highcard(myHand) < highcard(compHand)):
                    print 'You lose with the low card!'
                    winner = 'computer'
    return winner
    
#returns highest card
def highcard(hand):
    handvalues = {}
    for c in hand:
            handvalues[c] = cardValues.get(c)
    highest = max(handvalues.values())
    return highest
    
def cardGen():
    if cards:
            index = random.randrange(len(cards))
            return cards.pop(index)
    else:
            return None	
    
def getComputerMove():
    fate = random.randint(0, 1)
    if(fate==1):
            return 'c'
    if(fate==0):
            return 'b'
def getComputerBet():
    bet = random.randint(1, 15)
    return bet






'''
# turn and river flip
def flipPrint(x):
    print " ---- \n"
    print "|    |\n"
    print "| " + x + " |\n"
    print "|    |\n"
    print " ~~~~ \n"
'''

'''        
def highCard(hand):
    valuehand = {hand[0]:cardValues[hand[0]], hand[1]:cardValues[hand[1]], hand[2]:cardValues[hand[2]],
                 hand[3]:cardValues[hand[3]], hand[4]:cardValues[hand[4]], hand[5]:cardValues[hand[5]], hand[6]:cardValues[hand[6]]}
    sorted_hand = sorted(valuehand.items(), key=operator.itemgetter(1))
    return sorted_hand
[Board/Card Example]
----    ----
|    |  |    |
|    |  |    |
|    |  |    |
~~~~    ~~~~
----    ----
|    |  |    |
|  A |  |  K |
|    |  |    |
~~~~    ~~~~
FLOP                    TURN    RIVER
----    ----    ----    ----    ----
|    |  |    |  |    |  |    |  |    |
|  Q |  |  J |  | 10 |  |  9 |  |  A |
|    |  |    |  |    |  |    |  |    |
~~~~    ~~~~    ~~~~    ~~~~    ~~~~
'''