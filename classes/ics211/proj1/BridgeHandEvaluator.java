//****************************************************************************************
/*
Programmer:     David J. Burger
Project Number: 1
Course:         ICS 211
Filename:       BridgeHandEvaluator.java

Program Description:  This program evaluates bridge hands.  Each line of input is a
stream of characters representing a bridge hand in the following format:

2C QD TC AD 6C 3D TD 3H 5H 7H AS JH KH

The input consists of 13 cards with spaces separating each card.  Each card is
defined by two character strings with the first character representing the rank
(2,3,4,5,6,7,8,9,T,J,Q,K,A) and the second character representing the suit (C,D,H,S).

Each hand is processed and the contents of the hand are outputted in the manner
indicated (given the above hand):

The hand entered was:
2C QD TC AD 6C 3D TD 3H 5H 7H AS JH KH
This is your hand sorted by suits:
Clubs		10	6	2	
Diamonds	A	Q	10	3	
Hearts		K	J	7	5	3	
Spades		A	
Points for hand = 16

Scoring of the hand is defined as follows:

Aces count 4
Kings count 3
Queens count 2
Jacks count 1
Voids (no cards in a suit) count 3
Singeltons (one card in s suit) count 2
Doubletons (two cards in a suit) count 1
Long suits with more than 5 cards in the suit count 1 for each card over
    5  in number

Processing is stopped when the user presses enter on a blank line for standard in
from the keyboard or at the end of a file for standard in from a properly formatted
text file.

class  BridgeHandEvaluator - The class containing the main entry point for the
       program.  It uses the card hand class to evaluate card hands.

    static void main(String args[]) - The main entry point for the program.

class CardHand - A class used to represent a hand of cards.
    
    CardHand() - Create a new instance of the CardHand class.

    CardHand(String cards) - Create a new instance of the CardHand class that
        is initialized with the with the cards in String cards.
    
    public void addCardToHand(String aCard) throws IllegalArgumentException -
        Adds the specifed card to the hand.

    public void removeCardFromHand(String aCard) throws IllegalArgumentException -
        Removes the specified card from the hand.

    public void removeCardFromHand(char rank, char suit) throws IllegalArgumentException-
        Removes the specified card from the hand.
        
    public void addCardToHand(char rank, char suit) throws IllegalArgumentException -
        Adds the specified card to the hand.        

    public void removeAllCards() - Removes all cards from the hand.

    public void showHand() throws IllegalArgumentException - Displays the contents
        of the hand.

    public int getHandScore() - Returns the score of the card hand as defined
	in the book.

    private int suitToNum(char suit) throws IllegalArgumentException - returns the index
        value to the cardArray for the suit indicated by char suit.

    private String numToSuit(int suit) throws IllegalArgumentException - returns the
        string representation of the suit indicated by the int suit.

    private String numToRank(int rank) throws IllegalArgumentException - returns the
        string representation of the rand indicated by the int rank.

    private int rankToNum(char rank) throws IllegalArgumentException - returns the index
        value to the cardArray for the rank indicated by the char rank.

    private int pointsForNumCardsInSuit(int numCards) - returns the point value for having
        numCards number of cards in a single suit as defined in the book.
*/
//****************************************************************************************

import java.io.*;
//included for the StringTokenizer class.
import java.util.*;

//****************************************************************************************
/*
class BridgeHandEvaluator:  The class containing the main entry point for the program.
*/
//****************************************************************************************
public class BridgeHandEvaluator {

    //************************************************************************************
    //Purpose:  The main entry point for the BridgeHandEvaluator program.  This method
    //    prompts for and handles the user input as it uses the CardHand class to evaluate
    //    the hands.
    //Preconditions:  None.
    //Postconditions:  The entered card hand data is evaluated and appropriate output is
    //    displayed.  Program execution terminates when the user supplies no data
    //    (presses enter on a blank line).
    //************************************************************************************
    public static void main(String args[]) {
	    try {
	        System.out.println("Bridge Hand Evaluator");
	        System.out.println("Press enter on a blank line to quit.");
		System.out.println("Enter your bridge hand:");
                BufferedReader stdin = new BufferedReader(new InputStreamReader(System.in));
		String input = stdin.readLine();
		CardHand aCardHand;
		    //I did a null test and a test for the empty string
                    //so that my program could work with direct entry
		    //and by using redirection of the stdin with a file
		while ((input != null) && (!input.equals(""))) {
                    System.out.println("\nThe hand entered was:");
	       	    System.out.println(input);
	            aCardHand = new CardHand(input);
                    System.out.println("This is your hand sorted by suits:");
                    aCardHand.showHand();
		    System.out.println("Points for hand = " + aCardHand.getHandScore() + "\n");
		    System.out.println("Enter another bridge hand:");
		    input = stdin.readLine();
                }
		System.out.println("Thank you for using the bridge hand evaluator.");
            } catch (IOException e) {
                System.out.println(e.getMessage());
	    } catch (IllegalArgumentException e) {
               System.out.println(e.getMessage());
            }
    }
}

//****************************************************************************************
/*
class CardHand:  A class that represents a hand of cards from a standard deck of cards.
*/
//****************************************************************************************
class CardHand {

        //the data structure that represents the cards
    private boolean cardArray[][];
    private int numCards;

    //************************************************************************************
    //Purpose:  Create a new instance of the CardHand class.
    //Preconditions:  none.
    //Postconditions:  A new CardHand class is returned with the cardArray created holding
    //    no cards (all false) and the numCards set to 0.
    //************************************************************************************
    CardHand() {
            //all elements of the boolean array default to false, so empty hand to
            //start with
        cardArray = new boolean[13][4];
	numCards = 0;
    }

    //************************************************************************************
    //Purpose:  Create a new instance of the CardHand class.
    //Preconditions:  This method is passed a String cards that contains a valid card
    //    string indicating the cards that should be present in the hand.  The format of
    //    the string was described above.
    //Postconditions:  A new CardHand class is returned with the cardArray created holding
    //    the cards indicated by the initialization String cards.  If the string is
    //    invalid an IllegalArgumentException will result
    //************************************************************************************
    CardHand(String cards) {
        this();
	StringTokenizer inputTokens = new StringTokenizer(cards);
	while (inputTokens.hasMoreTokens())
	    addCardToHand(inputTokens.nextToken());
    }

    //************************************************************************************
    //Purpose:  The purpose of this method is to add a card to the hand.
    //Preconditions:  String aCard is passed a string with the first character
    //    representing the rank (2,3,4,5,6,7,8,9,T,J,Q,K,A) and the second character
    //    representing the suit (C,D,H,S).
    //Postconditions:  The card is added to the hand by setting the appropriate location
    //    in the cardArray to true.  If the String aCard is an invalid or the indicated
    //    card already exists in the hand a IllegalArgumentException is thrown.
    //************************************************************************************
    public void addCardToHand(String aCard) throws IllegalArgumentException {
        if (aCard.length()!= 2)
       	    throw new IllegalArgumentException("Invalid card format.");
        else {
            char theRank = aCard.charAt(0);
       	    char theSuit = aCard.charAt(1);
       	    addCardToHand(theRank, theSuit);
        }
    }

    //************************************************************************************
    //Purpose:  The purpose of this method is to remove a card from the hand.
    //Preconditions:  String aCard is passed a string with the first
    //    character representing the rank (2,3,4,5,6,7,8,9,T,J,Q,K,A) and
    //    the second character representing the suit (C,D,H,S).
    //Postconditions:  The card is removed from the hand by setting the appropriate
    //    location in the cardArray to false.  If the string aCard is invalid or the
    //    indicated card is not already in the hand a IllegalArgumentException is thrown.
    //************************************************************************************
    public void removeCardFromHand(String aCard) throws IllegalArgumentException {
        if (aCard.length() != 2)
       	    throw new IllegalArgumentException("Invalid card format.");
        else {
       	    char theRank = aCard.charAt(0);
       	    char theSuit = aCard.charAt(1);
       	    removeCardFromHand(theRank, theSuit);
        }
    }

    //************************************************************************************
    //Purpose:  The purpose of this method is to add a card to the hand.
    //Preconditions:  The chars rank and suit contain valid rank and suit characters
    //    (2,3,4,5,6,7,8,9,T,J,Q,K,A and C,D,H,S respectively).
    //Postconditions:  The indicated card is added to the hand by setting its position in
    //    the cardArray to true.  If the indicated card already exists in the hand or rank
    //    or suit chars are invalid then a IllegalArgumentException is thrown.
    //************************************************************************************
    public void addCardToHand(char rank, char suit) throws IllegalArgumentException {
        if (cardArray[rankToNum(rank)][suitToNum(suit)])
       	    throw new IllegalArgumentException("Duplicate card added to hand error.");
        else {
	    cardArray[rankToNum(rank)][suitToNum(suit)] = true;
	    numCards++;
        }
    }

    //************************************************************************************
    //Purpose:  The purpose of this method is to removed a card from the hand.
    //Preconditions:  The chars rank and suit contain valid rank and suit
    //    characters (2,3,4,5,6,7,8,9,T,J,Q,K,A and C,D,H,S respectively).
    //Postconditions:  The indicated card is removed from the hand by setting its position
    //    in the cardArray to false.  If the indicated card does not exist in the hand or
    //    rank or suit chars are invalid then a IllegalArgumentException is thrown.
    //************************************************************************************
    public void removeCardFromHand(char rank, char suit) throws IllegalArgumentException {
        if (!cardArray[rankToNum(rank)][suitToNum(suit)])
       	    throw new IllegalArgumentException("Removing a card not in the hand error.");
        else {
       	    cardArray[rankToNum(rank)][suitToNum(suit)] = false;
            numCards--;
        }
    }

    //************************************************************************************
    //Purpose:  The purpose of this method is to remove all cards from the hand.
    //Preconditions:  None.
    //Postconditions:  All cards are removed from the hand.  This is accomplished
    //    by instantiating a new array for cardArray.  The new cardArray will
    //    have false in all positions.
    //************************************************************************************
    public void removeAllCards() {
        cardArray = new boolean[13][4];
        numCards = 0;
    }

    //************************************************************************************
    //Purpose:  The purpose of this method is to show what cards are in a hand.
    //Preconditions:  None.
    //Postconditions:  The cards held in the hand are outputted to the screen.
    //************************************************************************************
    public void showHand() {
        for (int suit = 0;suit < 4;suit++) {
       	    System.out.print(numToSuit(suit) + "\t");
    	        //diamonds is longer than the other strings
    	        //and throws the tabs off, so don't put the
    	        //second tab if the suit is diamonds
            if (!numToSuit(suit).equals("Diamonds")) System.out.print("\t");
	    for (int rank = 12;rank > -1;rank--)
	        if (cardArray[rank][suit]) System.out.print(numToRank(rank) + "\t");
            System.out.println();
        }
    }

    //************************************************************************************
    //Purpose:  The purpose of this method is to return the score of the hand.
    //Preconditions:  None.
    //Postconditions:  The score of the hand is returned.  The method of scoring
    //    a hand was described in the problem as follows:
    //    Aces count 4
    //    Kings count 3
    //    Queens count 2
    //    Jacks count 1
    //    Voids (no cards in a suit) count 3
    //    Singeltons (one card in s suit) count 2
    //    Doubletons (two cards in a suit) count 1
    //    Long suits with more than 5 cards in the suit count 1 for each card over
    //        5  in number
    //************************************************************************************
    public int getHandScore() {
        int handScore = 0;
      	int numCardsInSuit;
        for (int suit = 0;suit < 4;suit++) {
       	    numCardsInSuit = 0;
       	    for (int rank = 12;rank > -1;rank--) {
                if (cardArray[rank][suit]) {
    		    numCardsInSuit++;
                    switch(rank) {
                        case(12):
     		            handScore += 4;
			    break;
                        case(11):
		            handScore += 3;
		            break;
                        case(10):
                            handScore += 2;
		            break;
                        case(9):
		            handScore += 1;
		            break;
		    }
		
                }
            }
            handScore += pointsForNumCardsInSuit(numCardsInSuit);
        }
	return handScore;
    }

    //************************************************************************************
    //Purpose:  Returns the string representation of the suit indicated
    //    by the int suit.
    //Preconditions:  int suit contains a valid array index position
    //    for the cardArray (0,1,2,3).
    //Postconditions:  The string name of the suit indicated by suit is returned.  If suit
    //    is out of range, a IllegalArgumentException is thrown.
    //************************************************************************************
    private String numToSuit(int suit) throws IllegalArgumentException {
        switch(suit) {
       	    case(0):
                return "Clubs";
            case(1):
	        return "Diamonds";
            case(2):
		return "Hearts";
            case(3):
		return "Spades";
            default:
		throw new IllegalArgumentException("Invalid suit index.");
        }
    }

    //************************************************************************************
    //Purpose:  Returns the string representation of the rank indicated by the int rank.
    //Preconditions:  int rank contains a valid array index position
    //    for the cardArray (0,1,2,3,4,5,6,7,8,9,10,11,12).
    //Postconditions:  The string name of the rank indicated by rank is returned.  If
    //    rank is out of range, a IllegalArgumentException is thrown.
    //************************************************************************************
    private String numToRank(int rank) throws IllegalArgumentException {
        switch(rank) {
            case(0):
	        return "2";
            case(1):
	        return "3";
	    case(2):
	        return "4";
            case(3):
	        return "5";
            case(4):
	        return "6";
            case(5):
	        return "7";
            case(6):
	        return "8";
            case(7):
	        return "9";
            case(8):
	        return "10";
            case(9):
	        return "J";
            case(10):
	        return "Q";
            case(11):
	        return "K";
            case(12):
	        return "A";
            default:
	        throw new IllegalArgumentException("Invalid rank index.");
	}
    }

    //************************************************************************************
    //Purpose:  Returns the index value to the cardArray for the suit indicated by char
    //    suit.
    //Preconditions:  The char suit contains a valid suit character (C,D,H,S).
    //Postconditions:  The appropriate array position for the given suit char is returned.
    //    If the suit char is invalid an IllegalArgumentException is thrown.
    //************************************************************************************
    private int suitToNum(char suit) throws IllegalArgumentException {
        switch(suit) {
            case('C'):
                return 0;
            case('D'):
		return 1;
            case('H'):
		return 2;
            case('S'):
		return 3;
            default:
		throw new IllegalArgumentException("Invalid suit character.");
        }
    }

    //************************************************************************************
    //Purpose:  Returns the index value to the cardArray for the rank
    //    indicated by char rank.
    //Preconditions:  The char rank contains a valid rank character
    //    (2,3,4,5,6,7,8,9,T,J,Q,K,A).
    //Postconditions:  The appropriate array position for the given rank char is returned.
    //    If the rank char is invalid a IllegalArgumentException is thrown.
    //************************************************************************************
    private int rankToNum(char rank) throws IllegalArgumentException {
            //I couldn't figure out how to convert a char to an int or I would have
	    //shortened this up a bit because many of these are at position (int)char - 2
        switch(rank) {
	    case('2'):
	        return 0;
            case('3'):
		return 1;
	    case('4'):
	        return 2;
	    case('5'):
	        return 3;
	    case('6'):
	        return 4;
	    case('7'):
	        return 5;
	    case('8'):
	        return 6;
	    case('9'):
	        return 7;
	    case('T'):
                return 8;
	    case('J'):
                return 9;
	    case('Q'):
                return 10;
	    case('K'):
	        return 11;
	    case('A'):
	        return 12;
            default:
	        throw new IllegalArgumentException("Invalid rank character.");
        }
    }

    //************************************************************************************
    //Purpose:  The purpose of this method is to return the point value
    //    for having int numCards number of cards in the hand.
    //Preconditions:  The number of cards in the suit is passed in the
    //    parameter int numCards.
    //Postconditions:  The value for having the number the number of cards
    //    in the suit as described in the problem is returned:
    //    Voids (no cards in a suit) count 3
    //    Singeltons (one card in s suit) count 2
    //    Doubletons (two cards in a suit) count 1
    //    Long suits with more than 5 cards in the suit count 1 for each card over
    //        5  in number
    //************************************************************************************
    private int pointsForNumCardsInSuit(int numCards) {
        int result = 0;
    	switch(numCards) {
       	    case(0):
                result += 3;
	    	break;
            case(1):
	        result += 2;
	    	break;
	    case(2):
	        result += 1;
	    	break;
            case(3):
	    case(4):
	    case(5):
	        break;
            default:
	        result += (numCards - 5);
	        break;
        }
	return result;
    }
}