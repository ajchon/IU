import random
import copy
import sys
import operator

compHand = []
myHand = []
community = []
usedCards = []


def royalFlush(hand):
    if('10d' in hand):
        if('Jd'in hand):
            if('Qd' in hand):
                if('Kd'in hand):
                    if('Ad'in hand):
                        return True
    if('10s' in hand):
        if('Js'in hand):
            if('Qs' in hand):
                if('Ks'in hand):
                    if('As'in hand):
                        return True
    if('10h' in hand):
        if('Jh'in hand):
            if('Qh' in hand):
                if('Kh'in hand):
                    if('Ah'in hand):
                        return True
    if('10c' in hand):
        if('Jc'in hand):
            if('Qc' in hand):
                if('Kc'in hand):
                    if('Ac'in hand):
                        return True
    else:
        return False


def straightFlush(hand):
    for c in hand:
        flush = []
        flush.append(c)
        handcopy = copy.deepcopy(hand)
        handcopy.remove(c)
        for k in handcopy:
            if(c[1] == k[1]):
                flush.append(k)
        if(len(flush) >= 5):
             break
    if(len(flush)<5):
        return False
    flushmap = {}
    for c in flush:
        flushmap[c] = cardValues.get(c)
    flushvalues = flushmap.values()
    flushvalues.sort()
    #print flushvalues
    for j in range(len(flushvalues)-5, -1, -1):
        sf_count = 0
        for i in range(j, len(flushvalues)-1):
            if(flushvalues[i] == flushvalues[i+1]-1):
                sf_count += 1
                #print sf_count
        if(sf_count >= 4):
            return True
        else:
            return False


def flush(hand):
    usedCards = []
    flushcount = 0
    for i in range(0, 7):
        for j in range(0, 7):
            if(hand[i][-1:]==hand[j][-1:]):
                flushcount += 1
                usedCards.append(hand[j])
                # print usedCards
        if(flushcount >= 5):
            return True
            #break
        else:
            usedCards = []
            flushcount = 0
    return False

def straight(hand):
    global usedCards
    straightcount = 0
    valuehand = {hand[0]:cardValues[hand[0]], hand[1]:cardValues[hand[1]], hand[2]:cardValues[hand[2]],
                 hand[3]:cardValues[hand[3]], hand[4]:cardValues[hand[4]], hand[5]:cardValues[hand[5]], hand[6]:cardValues[hand[6]]}
    sorted_hand = sorted(valuehand.items(), key=operator.itemgetter(1))
    #print sorted_hand
    for j in range(2, -1, -1):
        for i in range(j, 4+j):        
            if(cardValues[sorted_hand[i][0]] == cardValues[sorted_hand[i+1][0]]-1):
                straightcount += 1
                if(sorted_hand[i][0] not in usedCards):
                    usedCards.append(sorted_hand[i][0])
                usedCards.append(sorted_hand[i+1][0])
                # print usedCards
        if (straightcount == 4):
            return True
            break
        else:
            usedCards = []
            straightcount = 0
    return False

'''
def straight(hand):
    for c in hand:
            usedCards = []
            usedCards.append(c)
            handcopy = copy.deepcopy(hand)
            handcopy.remove(c)
            value = cardValues[c]
            for k in handcopy:
'''                   
                    
def pairs(hand):
    global paircount
    for c in hand:
        handcopy = copy.deepcopy(hand)
        handcopy.remove(c)
        for k in handcopy:
            if(k[:-1] == c[:-1]):
                paircount +=1
                hand.remove(k)
    if(paircount > 0):
        return True
    else:
        return False


# True if 4 of a kind       
def fourOFkind(hand):
    paircount = 0
    for i in range(0, 7):
        for j in range(0, 7):
            if(hand[i][:-1]==hand[j][:-1]):
                paircount += 1
        if(paircount==4):
            return True
        else:
            paircount = 0
    return False


def threeOFkind(hand):
    paircount = 0
    for i in range(0, 7):
        for j in range(0, 7):
            if(hand[i][:-1]==hand[j][:-1]):
                paircount += 1
        if(paircount==3):
            return True
        else:
            paircount = 0
    return False


def onePair(hand):
    paircount = 0
    for i in range(0, 7):
        for j in range(0, 7):
            if(hand[i][:-1]==hand[j][:-1]):
                paircount += 1
        if(paircount==2):
            return True
        else:
            paircount = 0
    return False


def fullHouse(hand):
    if (threeOFkind(hand)):
        if (onePair(hand)):
            return True
        else:
            return False
    else:
        return False
