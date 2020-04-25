%authors: Manish Jois and Joseph Hilber
clc
clear
fprintf('Welcome to Blackjack!\n');
initialChoice = -1;
while initialChoice == -1
    choice = input('Do you want to play [Y/N]? ','s');
    if choice == 'Y' || choice == 'y'
        initialChoice = 1;
    elseif choice == 'N' || choice == 'n'
        initialChoice = 0;
    else
        fprintf('Invalid Input! Enter only Y or N!\n');
        initialChoice = -1;
    end
end
playAgain = 1;
while (initialChoice == 1 && playAgain == 1)
    fprintf('\nShuffling deck...\n');
    currentDeck = Blackjack_Shuffle();
    playerCard = currentDeck(1);
    % cardsTaken = 1;
    Blackjack_Decoder(playerCard);
    cardsArray =[playerCard];
    fprintf("Your total is: %.0f\n", mod(Blackjack_Total(cardsArray), 100));
    newCard = -1;
    while newCard == -1
        if (mod(Blackjack_Total(cardsArray), 100) >= 21)
            newCard = 0;
        else
            hitStand = input('Hit or Stand? [H/S] ', 's');
            newCard = Blackjack_Hit(hitStand);
            fprintf("\n");
        end
        if newCard == 0
            newCard = 2;
            dealerCards = [currentDeck(length(cardsArray)+1), currentDeck(length(cardsArray)+2)];
            dealerTotal = mod(Blackjack_Total(dealerCards),100);
            index = length(cardsArray) + 3;
            if ((mod(Blackjack_Total(cardsArray), 100) <= 21))
                while ((dealerTotal < 16) && (mod(Blackjack_Total(cardsArray), 100) >= 16)) || ((dealerTotal <= (mod(Blackjack_Total(cardsArray), 100))) && ((mod(Blackjack_Total(cardsArray), 100))) < 16) || (((mod(Blackjack_Total(cardsArray), 100)) > 16 ) && dealerTotal < (mod(Blackjack_Total(cardsArray), 100))) %creates a "smart" dealer
                        dealerCards = [dealerCards, currentDeck(index)];
                        index = index + 1;
                        dealerTotal = mod(Blackjack_Total(dealerCards), 100);
                end
            end
            fprintf("The dealer's total is: %.0f\n", dealerTotal);
        elseif newCard == 1
            addCard = currentDeck(length(cardsArray)+1);
            cardsArray(end+1) = addCard;
            Blackjack_Decoder(addCard);
            fprintf("Your total is: %.0f\n", mod(Blackjack_Total(cardsArray), 100));
            newCard = -1;
        end
    end
    
    %checks if user or dealer is over
    userTotal = mod(Blackjack_Total(cardsArray), 100);
    if (userTotal > 21)
        userTotal = -1;
    end
    if (dealerTotal > 21)
        dealerTotal = -1;
    end
    
    if (userTotal > dealerTotal)
        fprintf('\nCongratulations!!!!!! YOU WON!!!'); 
    elseif (dealerTotal > userTotal)
        fprintf('\nThe dealer won... :(');
    else
        fprintf('\nIt is a tie!');
    end
    
    fprintf("\n");
    playAgain = Blackjack_PlayAgain();
end
if initialChoice ~= 0
    fprintf('\nThanks for playing! Play again soon!')
    fprintf('\nGoodbye!\n')
else
    fprintf('\nSorry to see you go! Hope you play sometime soon!\n')
end

% Returns and displays a card value (if Hit), returns 0 (if Stand), else
% returns the string "Invalid Input".
% Arguments: number of cards picked previously; user input string.
function [pickedCard] = Blackjack_Hit(inString)
if inString == 'h' || inString == 'H'
    fprintf('Selected to Hit')
    pickedCard = 1;
elseif inString == 's' || inString == 'S'
    pickedCard = 0;
    fprintf('Selected to Stand')
else
    pickedCard = -1;
    fprintf('Invalid Input')
end
end

function[] = Blackjack_Decoder(card)
suit = floor(card/100);
card_value = mod(card,100);
fprintf('\nThe card picked is: ')
if card_value == 1
    fprintf('Ace')
elseif card_value == 2
    fprintf('Two')
elseif card_value == 3
    fprintf('Three')
elseif card_value == 4
    fprintf('Four')
elseif card_value == 5
    fprintf('Five')
elseif card_value == 6
    fprintf('Six')
elseif card_value == 7
    fprintf('Seven')
elseif card_value == 8
    fprintf('Eight')
elseif card_value == 9
    fprintf('Nine')
elseif card_value == 10
    fprintf('Ten')
elseif card_value == 11
    fprintf('Jack')
elseif card_value == 12
    fprintf('Queen')
else
    fprintf('King')
end
fprintf(' of ')
if suit == 1
    fprintf('Clubs\n')
elseif suit == 2
    fprintf('Diamonds\n')
elseif suit == 3
    fprintf('Hearts\n')
else
    fprintf('Spades\n')
end 
end
 
function [userChoice] = Blackjack_PlayAgain()
userChoice = -1;
while userChoice == -1
    choice = input('\nDo you want to play again [Y/N]? ','s');
    if choice == 'Y' || choice == 'y'
        userChoice = 1;
    elseif choice == 'N' || choice == 'n'
        userChoice = 0;
    else
        fprintf('Invalid Input! Enter only Y or N\n')
        userChoice = -1;
    end
end
end

function [shuffledDeck] = Blackjack_Shuffle ()
    suitArray = [1, 2, 3, 4];
    for i = 1:13
        numberArray(i) = i;
    end
    cards = 1;
    for i = 1:length(suitArray)
        for j = 1:length(numberArray)
            cardArray(cards) = (100 * suitArray(i)) + numberArray(j);
            cards = cards + 1;
        end
    end
    
    shuffledDeck = cardArray(randperm(length(cardArray)));
    
    
end

function [sum] = Blackjack_Total(previousCards)
    sum = 0;
    numToAdd = 0;
    j = 0; %number of aces
    noAce = true;
    for i = 1:length(previousCards)
        cardVal = mod(previousCards(i), 100);
        %cardVal %test
        if cardVal == 1
            noAce = false;
            j = j + 1;
        else
            if cardVal > 10
                numToAdd = 10;
            else
                numToAdd = mod(previousCards(i), 100);
            end
            sum = sum + numToAdd;
        end
    end
    
    %noAce %testing
    if ~noAce
        if j == 1 && sum < 11
            sum = sum + 11;
        elseif j == 2 && sum < 10
            sum = sum + 12;
        elseif j == 3 && sum < 9
            sum = sum + 13;
        elseif j == 4 && sum < 8
            sum = sum + 14;
        elseif j == 3 && sum > 8
            sum = sum + j;
        elseif j == 4 && sum > 7
            sum = sum + j;
        else %sum > 10
            sum = sum + j;
        end
    end

end
